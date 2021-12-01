function PlotMap(lon,lat,n,m,LandInd,SSTpredicted,ValAvgs,val_days,nBox)
% Plotting Globe Data

SSTPredicted_Plot = 250.*ones(n,m);
SSTValidation_Plot = 250.*ones(n,m);

dim = n/nBox; %num of points in discretized row
for elapsed = 1:val_days
    
    %Stores predicted values
    box = 1;
    for j = 1:m/dim
        for i = 1:n/dim
            SSTPredicted_Plot((i-1)*dim+1:(i-1)*dim+dim,(j-1)*dim+1:(j-1)*dim+dim) = SSTpredicted(elapsed,box).*ones(dim,dim);
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
            SSTValidation_Plot((i-1)*dim+1:(i-1)*dim+dim,(j-1)*dim+1:(j-1)*dim+dim) = ValAvgs(elapsed,box).*ones(dim,dim);
            box = box+1;
        end
    end
    %Then manually throwing land values in
    for i = 1:length(LandInd)
        SSTValidation_Plot(LandInd(i)) = NaN;
    end    
    
    
    
%Plotting

figure(2)
clf
colormap default
caxis([260 305])
[x,y,z] = sphere;
h = surface(x,y,z, 'FaceColor','texturemap',...
'EdgeColor','none','Cdata',flipud(SSTPredicted_Plot));
grid on
title('Forecasted Sea Surface Temperature')
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'ztick',[])
view(50,10)
cb = colorbar();
ylabel(cb,'Temperature (Degrees Kelvin)')
set(gca, 'color', 'k');


figure(3)
clf
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
view(50,10)
cb = colorbar();
ylabel(cb,'Temperature (Degrees Kelvin)')
set(gca, 'color', 'k');


end
end