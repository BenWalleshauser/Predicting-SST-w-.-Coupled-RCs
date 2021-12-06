function PlotGlobe(n,m,LandInd,SST_predicted,SST_validation,val_days,nBox,SST_IC,mode,az,el)
% Plotting on Globe
clf

%Use these to plot efficiently
SST_1 = zeros(val_days,length(SST_predicted(1,:)));
SST_2 = zeros(val_days,length(SST_predicted(1,:)));
if mode == 1
    SST_1 = SST_predicted;
    SST_2 = SST_validation;
    Title1 = 'Forecasted Sea Surface Temperatures';
    Title2 = 'Actual Sea Surface Temperatures';
    cblim1 = [260 305];
    cblim2 = [260 305];
elseif mode == 2 %Relative change 
    for j = 1:val_days
        SST_1(j,:) = SST_predicted(j,:) - SST_IC;
        SST_2(j,:) = SST_validation(j,:) - SST_IC;
    end
    Title1 = 'Forecasted Change';
    Title2 = 'Actual Change';
    cblim1 = [-12 12];
    cblim2 = [-12 12];
elseif mode == 3 %Error Plot
    SST_1 = abs(SST_predicted-SST_validation);
    SST_2 = abs(SST_predicted-SST_validation);
    Title1 = 'Error';
    Title2 = 'Error';
    cblim1 = [0 12];
    cblim2 = [0 5];
end

Plot_1 = 250.*ones(n,m);
Plot_2 = 250.*ones(n,m);

SavePlot = 0;
%Uncomment if you'd like to save the plot
%filename = ['MyVideo.avi'];
%myVideo = VideoWriter(filename); %open video file
%myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
%myVideo.Quality = 100;
%open(myVideo)
%SavePlot = 1;

[Lat,Lon] = cdtgrid(0.25);
dim = n/nBox; %num of points in discretized row
for elapsed = 1:val_days
    
    %First plot
    box = 1;
    for j = 1:m/dim
        for i = 1:n/dim
            Plot_1((i-1)*dim+1:(i-1)*dim+dim,(j-1)*dim+1:(j-1)*dim+dim) = SST_1(elapsed,box).*ones(dim,dim);
            box = box+1;
        end
    end
    %Then manually throwing land values in
    for i = 1:length(LandInd)
        Plot_1(LandInd(i)) = NaN;
    end
    
    
    %Second plot
    box = 1;
    for j = 1:m/dim
        for i = 1:n/dim
            Plot_2((i-1)*dim+1:(i-1)*dim+dim,(j-1)*dim+1:(j-1)*dim+dim) = SST_2(elapsed,box).*ones(dim,dim);
            box = box+1;
        end
    end
    %Then manually throwing land values in
    for i = 1:length(LandInd)
        Plot_2(LandInd(i)) = NaN;
    end    
    
    
    %Plotting
    f = figure(2);
    f.Position = [300 300 1200 400];
    sgtitle(['Day: ',num2str(elapsed)],'fontweight','bold','fontsize',16)
    
    subplot(1,2,1)
    hold on
    caxis(cblim1)
    globeimage
    globepcolor(Lat,Lon,Plot_1)
    cmocean('thermal')
    %earthimage('watercolor','none')
    axis tight % removes whitespace
    view(az,el)
    cb = colorbar();
    ylabel(cb,'Temperature (Degrees Kelvin)')
    title(Title1)
    set(cb,'position',[.49 .2 .02 .5])
    hold off

    
    subplot(1,2,2)
    hold on
    caxis(cblim2)
    globeimage
    globepcolor(Lat,Lon,Plot_2)
    cmocean('thermal')
    axis tight % removes whitespace
    view(az,el)
    title(Title2)
    if mode == 3
        cb2 = colorbar();
        cb2.Ruler.Scale = 'log';
        cb2.Ruler.MinorTick = 'on';
        cb2.Ticks = [0 0.5 1  2  3  4  5];
        set(cb2,'position',[.6 .2 .02 .5])
        set(cb,'position',[.42 .2 .02 .5])
        ylabel(cb2,'Temperature (Degrees Kelvin)')
    else
        cb2 = colorbar();
        set(cb2,'visible','off')
    end
    hold off
    
    if SavePlot == 1
        frame = getframe(2);    
    writeVideo(myVideo, frame);
    end
end

    
end
