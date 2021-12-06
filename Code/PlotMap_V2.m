function PlotMap_V2(lon,lat,n,m,LandInd,SST_predicted,SST_validation,val_days,nBox)
% Plotting data on a flat map

dim = n/nBox; %num of points in discretized row
[long, latg] = meshgrid(lon, lat);

SavePlot = 0;
%Uncomment the following lines if you would like to save the simulation as an AVI 
%filename = ['MyVideo.avi'];
%myVideo = VideoWriter(filename); %open video file
%myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
%myVideo.Quality = 100;
%open(myVideo)
%SavePlot = 1;

axis tight manual % this ensures that getframe() returns a consistent size
for elapsed = 1:val_days

    SSTPredicted_Plot = 250.*ones(n,m);
    SSTValidation_Plot = 250.*ones(n,m);
    SSTError_Plot = 250.*ones(n,m);
    %Stores predicted values
    box = 1;
    for j = 1:m/dim
        for i = 1:n/dim
            SSTPredicted_Plot((i-1)*dim+1:(i-1)*dim+dim,(j-1)*dim+1:(j-1)*dim+dim) = SST_predicted(elapsed,box).*ones(dim,dim);
            box = box+1;
        end
    end
    %Then manually throwing land values in
    for i = 1:length(LandInd)
        SSTPredicted_Plot(LandInd(i)) = NaN;
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


    SSTError_Plot = SSTValidation_Plot-SSTPredicted_Plot;
    %Then manually throwing land values in
    for i = 1:length(LandInd)
        SSTError_Plot(LandInd(i)) = NaN;
    end 

%Plotting Map
    figure(1)
    subplot(2,2,1)
    hold on
    pcolor(long, latg, SSTPredicted_Plot);
    xlim([-180 180])
    ylim([-90 90])
    set(gca, 'color', 'k');
    shading flat;
    caxis([270 300]);
    text(60,80, ['Day:', num2str(elapsed)],'Color','white');
    title('Forecasted Sea Surface Temperature')
    cb1 = colorbar;
    ylabel(cb1,'Temperature (Degrees Kelvin)')
    hold off


    subplot(2,2,2)
    hold on
    pcolor(long, latg, SSTValidation_Plot);
    xlim([-180 180])
    ylim([-90 90])
    set(gca, 'color', 'k');
    shading flat;
    caxis([270 300]);
    text(60,80, ['Day:', num2str(elapsed)],'Color','white');
    title('Actual Sea Surface Temperature')
    cb2 = colorbar;
    ylabel(cb2,'Temperature (Degrees Kelvin)')
    hold off


    subplot(2,2,3)
    hold on
    pcolor(long, latg, abs(SSTError_Plot));
    xlim([-180 180])
    ylim([-90 90])
    set(gca, 'color', 'k');
    shading flat;
    caxis([0 12]);
    text(60,80, ['Day:', num2str(elapsed)],'Color','white');
    title('Error in Forecast')
    cb1 = colorbar;
    ylabel(cb1,'Temperature (Degrees Kelvin)')

    subplot(2,2,4)
    hold on
    pcolor(long, latg, abs(SSTError_Plot));
    xlim([-180 180])
    ylim([-90 90])
    set(gca, 'color', 'k','ColorScale','log');
    shading flat;
    caxis([-800 9]);
    text(60,80, ['Day:', num2str(elapsed)],'Color','white');
    title('Error in Forecast')
    cb4 = colorbar();
    cb4.Ruler.Scale = 'log';
    cb4.Ruler.MinorTick = 'on';
    cb4.Ticks = [0 1 2  4  6  8  10];
    ylabel(cb4,'Temperature (Degrees Kelvin)')
    ylabel(cb1,'Temperature (Degrees Kelvin)')
    
    if SavePlot == 1
        frame = getframe(1);    
        writeVideo(myVideo, frame);
    end

    pause(0.001)

end
end
