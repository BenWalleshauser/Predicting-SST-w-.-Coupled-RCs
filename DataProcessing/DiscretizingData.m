% Ben Walleshauser
% 9/27

%Discretizes and compiles data
%% Initialization Data
clc
clear 

%Time frame to sample 
Years = [2003:2020]';    
Months = [1:12]';

%Directory where data was saved
MyDir = 'MyDir\';

NaNset = 250;       %Setting NaNs to this number to make them easier to deal with
n = 720;            %Number of latitude pts in data set
m = 1440;           %Number of longitude pts in data set
dim = 6;            %Number of data points over a length of box (therefore nBox = 720/dim and mBox = 1440/dim)
NumBoxes = n*m/dim^2;   %Total number of boxes

Avgs = zeros(10,NumBoxes);    %row refers to sample, column refers to the grouping index
LandInd = zeros(5,500000);      %row refers to the time sample

%% Compiling Data 
%Essentially grouping original data into 'boxes' and then takes the average
%over the entire box. If a box contains land, it is ignored in the
%computation of the average of the box. These boxes are then the basis of
%the new processed dataset.

tic
elapsed = 1;
for yr = 1:length(Years)
    for mo = 1:length(Months)
        Days = sort(nonzeros(calendar(Years(yr),Months(mo))));
        for day = 1:length(Days)   
            clear SST_sample SST
            SST_sample = load([MyDir,'SST_',num2str(Years(yr)),num2str(Months(mo),'%02.f'),num2str(Days(day),'%02.f'),'.mat']);
            SST = flip(SST_sample.SST');    
            
            %Switching NaNs to NaNset
            for i = 1:length(SST(:,1))
                for j = 1:length(SST(1,:))
                    if isnan(SST(i,j)) == 1;
                        SST(i,j) = NaNset;
                    end
                end
            end
           
            %Finding the indices in each grouping
            BoxInd = zeros(dim^2,NumBoxes);
            d = 1;
            c = 0;
            b = 0;
            mult = 0;       
            mult2 = 0;      
            for i = 1:NumBoxes 
                    for j = 1:dim
                        for k = 1:dim
                            %Cycling through box:

                            BoxInd((j-1)*dim+k,i) = (j-1)*n + k + mult2*dim + mult*n*dim;
                            b = b+1;
                            if SST(BoxInd((j-1)*dim+k,i)) == NaNset    %if index is on land
                                LandInd(elapsed,d) = BoxInd((j-1)*dim+k,i);     %record index of land value for plotting
                                d = d+1;                                
                                BoxInd((j-1)*dim+k,i) = 0;       
                            end
                        end
                        if b >= dim^2    
                            mult2 = mult2+1;        
                            b = 0;
                        end
                    end       
                    c = c + 1;         
                    if c >= n/dim          
                        mult = mult+1;     
                        c = 0;
                        mult2 = 0;            
                    end

            end            
            
            %Finding the averages over the box
            for i = 1:NumBoxes
                Avgs(elapsed,i) = sum(SST(nonzeros(BoxInd(:,i))))./length(nonzeros(BoxInd(:,i)));
            end
            
            %Switch to next day
            elapsed = elapsed +1;
            
                              
        end
    end
end
toc








