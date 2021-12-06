function PlotGlobe(lon,lat,n,m,LandInd,SST_predicted,SST_validation,val_days,nBox)
% Plotting Globe Data

SST_predicted_Plot = 250.*ones(n,m);
SSTValidation_Plot = 250.*ones(n,m);

SavePlot = 0;
%Uncomment if you'd like to save the plot
% filename = ['C:\Users\benwa\Documents\Research\SST Predictor\Vids\',num2str(now*10^10),'.avi'];
% myVideo = VideoWriter(filename); %open video file
% myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
% myVideo.Quality = 100;
% open(myVideo)
% SavePlot = 1;

%Camera settings: 
az = 50+180;
el = 10;

dim = n/nBox; %num of points in discretized row
for elapsed = 1:val_days
    
    %Stores predicted values
    box = 1;
    for j = 1:m/dim
        for i = 1:n/dim
            SST_predicted_Plot((i-1)*dim+1:(i-1)*dim+dim,(j-1)*dim+1:(j-1)*dim+dim) = SST_predicted(elapsed,box).*ones(dim,dim);
            box = box+1;
        end
    end
    %Then manually throwing land values in
    for i = 1:length(LandInd)
        SST_predicted_Plot(LandInd(i)) = NaN;
    end
    
    
    %Stores true values
    box = 1;
    for j = 1:m/dim
        for i = 1:n/dim
            SSTValidation_Plot((i-1)*dim+1:(i-1)*dim+dim,(j-1)*dim+1:(j-1)*dim+dim) = SST_validation(elapsed,box).*ones(dim,dim);
            box = box+1;
        end
    end
    %Then manually throwing land values in
    for i = 1:length(LandInd)
        SSTValidation_Plot(LandInd(i)) = NaN;
    end    
    
    
    
%Plotting

f = figure(2);
f.Position = [300 300 1200 400];
sgtitle(['Day: ',num2str(elapsed)],'fontweight','bold','fontsize',16)
subplot(1,2,1)
hold on
colormap default
caxis([260 305])
[x,y,z] = sphere;
h = surface(x,y,z, 'FaceColor','texturemap',...
'EdgeColor','none','Cdata',flipud(SST_predicted_Plot));
grid on
title('Forecasted Sea Surface Temperature')
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'ztick',[])
view(az,el)
cb = colorbar();
ylabel(cb,'Temperature (Degrees Kelvin)')
set(gca, 'color', 'k');
hold off

subplot(1,2,2)
hold on
colormap default
caxis([260 305])
[x,y,z] = sphere;
h = surface(x,y,z, 'FaceColor','texturemap',...
'EdgeColor','none','Cdata',flipud(SSTValidation_Plot));
grid on
title('Actual Sea Surface Temperature')
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'ztick',[])
view(az,el)
cb = colorbar();
ylabel(cb,'Temperature (Degrees Kelvin)')
set(gca, 'color', 'k');
hold off

if SavePlot == 1
    frame = getframe(2);    
    writeVideo(myVideo, frame);
end
    
end
end
