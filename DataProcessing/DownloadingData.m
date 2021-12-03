%Ben Walleshauser
%9/20/2021

%Downloads the dataset from oPeNDAP
%% Initializing

%The years and corresponding months that the data will be downloaded for
Years = [2003:2003]';
Months = [01:12]';

%Directory to save to:
MyDir = 'MyDir\';

%% Downloading Data
for i = 1:length(Years)
    for j = 1:length(Months)
        Days = sort(nonzeros(calendar(Years(i),Months(j))));
        for k = 1:length(Days)
             rollingdate = day(datetime(Years(i),Months(j),Days(k)),'dayofyear');
             filename = ['https://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR25/v4.2/',num2str(Years(i)),'/',num2str(rollingdate,'%03.f')...
                ,'/',num2str(Years(i)),num2str(Months(j),'%02.f'),num2str(Days(k),'%02.f'),'090000-JPL-L4_GHRSST-SSTfnd-MUR25-GLOB-v02.0-fv04.2.nc'];
            
            SST = ncread(filename,'analysed_sst');
            save([MyDir,'SST_',num2str(Years(i)),num2str(Months(j),'%02.f'),num2str(Days(k),'%02.f')],'SST');
                        
            %If the data is corrupted redownload set
            while SST(1,720) > 285 %this seemed to be an indicator that something went wrong in the transfer of data
                rollingdate = day(datetime(Years(i),Months(j),Days(k)),'dayofyear');

                filename = ['https://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR25/v4.2/',num2str(Years(i)),'/',num2str(rollingdate,'%03.f')...
                ,'/',num2str(Years(i)),num2str(Months(j),'%02.f'),num2str(Days(k),'%02.f'),'090000-JPL-L4_GHRSST-SSTfnd-MUR25-GLOB-v02.0-fv04.2.nc'];

                SST = ncread(filename,'analysed_sst');   
                save([MyDir,'SST_',num2str(Years(i)),num2str(Months(j),'%02.f'),num2str(Days(k),'%02.f')],'SST');
            end
        end
    end
end

