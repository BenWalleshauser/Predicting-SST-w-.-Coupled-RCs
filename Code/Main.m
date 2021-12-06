%Ben Walleshauser
%10/14/2021

%% Importing Data
clear
clc

Data = load('SST_Data');

SST_total = Data.SST_total;   %Each rows of SST_total corresponds to a new day, each column corresponds to a different index on the map
LandInd = Data.LandInd;       %The land indices of the original undiscretized map. Only used for plotting purposes at the end
lat = Data.lat;               %Latitude values -use these to label plots
lon= Data.lon;                %Longitude values -use these to label plots

%The value which NaNs (points on land) are set to
NaNset = 250;

%Splitting data into training and validation sets
val_days = 42;    %Number of days to forecast for
train_days = length(SST_total(:,1))-val_days;
SST_train = SST_total(1:train_days,:);
SST_validate = SST_total(train_days+1:length(SST_total(:,1)),:);


%% Sorting Paramters

%Number of rows and columns of indices on the original map
%-given by dataset (don't change unless changing datasets)
n = 720;    %Number of latitudes
m = 1440;   %Number of longitudes

%Number of rows and columns of indices on the discretized map
%-chosen when discretizing (don't change unless you want to discretize
%dataset yourself, but keep 1:2)
nBox = 120;   %Number of latitudes 
mBox = 240;   %Number of longitudes

%Number of rows and columns per RC (can change)
nPack = 4;
mPack = 4;
NumPacks = (nBox*mBox)/(nPack*mPack);    %Number of packs, each pack will have its own RC

%Each PackInd(:,i) will have its own RC
PackInd = FindPackIndices(SST_total,nBox,mBox,nPack,mPack,NaNset);

%Important: The index notation used in this code follows standard matrix
%notation used by MATLAB:
%     [1  5   9    13
%      2  6   10   14
%      3  7   11   15
%      4  8   12   16]
%   Therefore the SST at the top left of the map on the j_th day is found by using SST_total(j,1)
%% RC Parameters
%Metaparameters for the reservoir computer

%Metaparameters:
sigma=3e-4;                      %Multiplier of random input matrix,
rho=1.0;                         %Desired spectral radius of A
density=0.05;                    %Density of A
beta = 0.02;                     %Regularization parameter
bias = 0;                        %Bias
dim_reservoir = 550;             %Fixed for all RCs

%% Training RC
%Training the reservoir computer by training W_out for each pack at a time
%before moving to the next pack.

A = GenerateReservoir(dim_reservoir, rho, density); 

f = waitbar(0,'Please wait...');
warning('off')
W_out = {};
W_in = {};   %make a bunch of input matrices for a given dimension (if 0 skip)
for i = 1:(nPack+2)*(mPack+2)
    W_in{1,i} = 2*sigma*(rand(dim_reservoir, i) - 0.5);
end
b = bias*ones(dim_reservoir,1);

for p = 1:NumPacks   %creating NGRC for each group
    
    iPackInd = nonzeros(PackInd(:,p));                      %The indices that are going to be predicted with the given RC                     
    CloudInd = zeros(8,length(iPackInd));                   %The indices that surround the pack

    %Finding the indices that are going to be considered in RC
    for z = 1:length(iPackInd)
        nbInds = Neighbors(iPackInd(z),nBox,mBox);          %The neighboring indices for a given point
        for i = 1:length(nbInds)                            %Getting rid of neighbor if it is on land
            if SST_total(1,nbInds(i)) == NaNset
                nbInds(i) = 0;              
            end
        end
        CloudInd(1:length(nbInds),z) = nbInds;              %All of the neighboring indices
    end

    CloudInd = reshape(CloudInd,[],1);
    TotalInd = [iPackInd; CloudInd];            
    TotalInd = unique(TotalInd,'stable');                   %Getting rid of repeat Neighbors while preserving order of indices
    TotalInd = TotalInd(TotalInd~=0);                       %Total Indices being condsidered in the given RC (nonzero)  
    SST = SST_train(:,TotalInd);                            %The values of the SST being used
    
    dim_system = length(TotalInd);
    if dim_system == 0                                      %if all box indices are on land skip 
        continue
    end
    r_state = zeros(dim_reservoir,1);                         
    R = zeros(dim_reservoir, length(train_days));
    for i = 1:train_days
        R(:,i) = r_state; 
        r_state = tanh(A*r_state + W_in{1,dim_system}*SST(i,:)'+b);
    end
    
    W_out{1,p} = LinReg(R,SST_train(:,iPackInd),beta);      %Storing the values of the trained readout matrix in cell

    f = waitbar(p/NumPacks,f,['Model being trained. Percent completed:',num2str(100*p/NumPacks),'%']);
end
close(f)

%% Forecasting with the RC
%Forecasting with the trained model. The model uses all of the trained RCs
%every time step to get a prediction for the next day, and then inputs
%these predictions back into the reservoir the next day.

SST_predicted = NaNset.*ones(val_days+1,nBox*mBox);        %Forecasted SST
SST_predicted(1,:) = SST_train(train_days,:);              %Initial Condition
g = waitbar(0,'Please wait...');
clear r_state                                              %Clearing reservoir state
r_state = {};

for i = 1:val_days
    for p = 1:NumPacks
        
        iPackInd = nonzeros(PackInd(:,p));
        CloudInd = zeros(8,length(iPackInd));
        %Finding the indices of the boxes that are going to be considered in RC
        for z = 1:length(iPackInd)
            nbInds = Neighbors(iPackInd(z),nBox,mBox);
            for y = 1:length(nbInds)
                if SST_total(1,nbInds(y)) == NaNset     
                    nbInds(y) = 0;
                end
            end
            CloudInd(1:length(nbInds),z) = nbInds;   
        end

        CloudInd = reshape(CloudInd,[],1);
        TotalInd = [iPackInd; CloudInd];
        TotalInd = unique(TotalInd,'stable');       
        TotalInd = TotalInd(TotalInd~=0); 
        dim_system = length(TotalInd);
        if dim_system == 0                                     
            continue
        end
        if i == 1   
           r_state{1,p} = tanh(W_in{1,dim_system}*SST_predicted(i,TotalInd)'+b);                    %initializing reservoir state for each pack
        else
            r_state{1,p} = tanh(A*r_state{1,p} + W_in{1,dim_system}*SST_predicted(i,TotalInd)'+b);  %cycling reservoir state
        end
        SST_predicted(i+1,iPackInd) = W_out{1,p}*r_state{1,p};                                      %reading out predicted SST

    end
    g = waitbar(i/val_days,g,['Model is forecasting. Percent completed:',num2str(100*i/val_days),'%']);
end
close(g)
SST_predicted = SST_predicted(2:val_days+1,:);                                                      %getting rid of initial condition from prediction

%% Plot Map
%Modes:
% 1-Regular SST
% 2-Change in SST
% 3-Error
Mode =1;

PlotMap(lon,lat,n,m,LandInd,SST_predicted,SST_validate,val_days,nBox,SST_train(train_days,:),Mode)
%PlotMap_V2(lon,lat,n,m,LandInd,SST_predicted,SST_validate,val_days,nBox) %Use this version if you don't have the Climate Data Toolbox

%% Plot Globe
%Modes:
% 1-Regular SST
% 2-Change in SST
% 3-Error
Mode = 1;

%Camera settings: 
az = 50;
el = 10;

PlotGlobe(n,m,LandInd,SST_predicted,SST_validate,val_days,nBox,SST_train(train_days,:),Mode,az,el)
%PlotGlobe_V2(lon,lat,n,m,LandInd,SST_predicted,SST_validate,val_days,nBox,az,el)  %Use this version if you don't have the Climate Data Toolbox

%% Plot Error
PlotError(SST_predicted,SST_validate,val_days,nBox,mBox,NaNset)

%% Plot Time Series at Specific Coordinates
%Desired latitude and longitude to be sampled:
MyLat = -8.25;
MyLon = 179.25;
PlotTimeSeries(SST_predicted,SST_total,val_days,MyLat,MyLon,train_days,nBox)












