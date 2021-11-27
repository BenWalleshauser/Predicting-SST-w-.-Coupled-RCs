%Ben Walleshauser
%10/14/2021

%% Importing Data
clear
clc

Data = load('SST_Data');

SST_total = Data.SST_total;
LandInd = Data.LandInd;
lat = Data.lat;
lon= Data.lon;

%The value which NaNs (points on land) are set to
NaNset = 250;

%Splitting data into training and validation sets
val_days = 42;    %Number of days to forecast for
train_days = length(SST_total(:,1))-val_days;
SST_train = SST_total(1:train_days,:);
SST_validate = SST_total(train_days+1:length(SST_total(:,1)),:);


%% Sorting Paramters

%Given By Data (don't change unless changing datasets)
n = 720;    %Number of latitudes
m = 1440;   %Number of longitudes

%Chosen when Discretizing (don't change unless you want to discretize
%dataset yourself)
nBox = 120;   
mBox = 240;

%Number of Rows and Columns per RC (can change)
nPack = 4;
mPack = 4;
NumPacks = (nBox*mBox)/(nPack*mPack);

%Each PackInd(:,i) will have its own RC
PackInd = FindPackIndices(SST_total,nBox,mBox,nPack,mPack,NaNset);

%% RC Parameters

%Metaparameters:
sigma=3e-4;                      %Multiplier of random input matrix,
rho=1.0;                        %Desired spectral radius of A
density=0.05;                   %Density of A
beta = 0.02;                     %Regularization parameter
bias = 0;                        %Bias
dim_reservoir = 550;             %Fixed for all RCs

%% Training RC

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
    
    iPackInd = nonzeros(PackInd(:,p));        %The indices of the boxes that are going to be predicted with the given RC                     
    CloudInd = zeros(8,length(iPackInd));     %The indices that surround the pack

    %Finding the indices of the boxes that are going to be considered in RC
    for z = 1:length(iPackInd)
        nbInds = Neighbors(iPackInd(z),nBox,mBox);          %The neighboring indices for a given point in pack
        for i = 1:length(nbInds)                            %Getting rid of index if it is on land
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
    
    W_out{1,p} = LinReg(R,SST_train(:,iPackInd),beta);      %Storing the values of the readout matrix in cell because not same dimension for all

    f = waitbar(p/NumPacks,f,['Model being trained. Estimated time left:',num2str(p/NumPacks),'%']);
end
close(f)

%% Forecasting with the RC


SST_predicted = NaNset.*ones(val_days+1,nBox*mBox);           
SST_predicted(1,:) = SST_train(train_days,:);   %Pre-filling 
g = waitbar(0,'Please wait...');
clear r_state
r_state = {};

for i = 1:val_days
    for p = 1:NumPacks
        
        iPackInd = nonzeros(PackInd(:,p));
        CloudInd = zeros(8,length(iPackInd));
        %Finding the indices of the boxes that are going to be considered in RC
        for z = 1:length(iPackInd)
            nbInds = Neighbors(iPackInd(z),nBox,mBox);
            for y = 1:length(nbInds)
                if SST_total(1,nbInds(y)) == NaNset       %ie if neighbor on land get rid
                    nbInds(y) = 0;
                end
            end
            CloudInd(1:length(nbInds),z) = nbInds;   
        end

        CloudInd = reshape(CloudInd,[],1);
        TotalInd = [iPackInd; CloudInd];
        TotalInd = unique(TotalInd,'stable');       %preserving order
        TotalInd = TotalInd(TotalInd~=0); 
        dim_system = length(TotalInd);
        if dim_system == 0                                      %if all box indices are on land skip
            continue
        end
        if i == 1   
           r_state{1,p} = tanh(W_in{1,dim_system}*SST_predicted(i,TotalInd)'+b);  %initializing reservoir state
        else
            r_state{1,p} = tanh(A*r_state{1,p} + W_in{1,dim_system}*SST_predicted(i,TotalInd)'+b);  %cycling reservoir state
        end
        SST_predicted(i+1,iPackInd) = W_out{1,p}*r_state{1,p};

    end
    g = waitbar(i/val_days,g,['Model is forecasting. Percent completed:',num2str(i/val_days),'%']);
end
close(g)
SST_predicted = SST_predicted(2:val_days+1,:); %getting rid of initial condition

%% Plot Map

PlotMap(lon,lat,n,m,LandInd,SST_predicted,SST_validate,val_days)

%% Plot Globe

PlotGlobe(lon,lat,n,m,LandInd,SST_predicted,SST_validate,val_days)

%% Plot Error

PlotError(SST_predicted,SST_validate,val_days,nBox,mBox,NaNset)

%% Plot Time Series at Specific Coordinates

%Desired Latitude and Longitude:
MyLat = -30;
MyLon = -170;
PlotTimeSeries(SST_predicted,SST_total,val_days,MyLat,MyLon,length(SST_total(:,1)))












