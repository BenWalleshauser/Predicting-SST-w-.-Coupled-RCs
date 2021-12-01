function PlotTimeSeries(SST_predicted,SST_total,val_days,MyLat,MyLon,train_days,nBox)
%Plots time series of selected points.

% Plotting Time Series
TotalTime = train_days + val_days;
P1 = ReturnInds(MyLat,MyLon,nBox);
[lat1,lon1] = ReturnCoords(P1,nBox);

clf
delay = 50;
figure(8)
hold on
plot(TotalTime-val_days:TotalTime-1,SST_predicted(1:val_days,P1),'r')
plot(TotalTime-val_days-delay:TotalTime,SST_total(TotalTime-val_days-delay:TotalTime,P1),'b')
grid on
xlabel('Days into Data Set','FontSize', 15)
ylabel('SST (Degrees Kelvin)','FontSize', 15)
%title('Forecasted vs. Actual SST')
title('Pacific Ocean near Tuvalu')
ylim=get(gca,'ylim');
xlim=get(gca,'xlim');
text(xlim(2)-97,ylim(2)-0.05*(ylim(2)-ylim(1)),['Lat: ', num2str(lat1)],'FontSize', 15);
text(xlim(2)-97,ylim(2)-0.13*(ylim(2)-ylim(1)),['Lon: ', num2str(lon1)],'FontSize', 15);
%legend('Forecast','Actual')
set(gca,'FontSize',15)

hold off
end