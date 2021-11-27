function PlotError(SST_predicted,SST_validation,val_days,nBox,mBox,NaNset)

%% Finding Average Error

SSTdiff = abs(SST_predicted(1:val_days,:)-SST_validation);
SSTavgdiff = zeros(val_days,1);

%Finding the total area encompassed by the sea and actual area encompassed
%by each index, TotalArea is the fraction of the Earth that is water
TotalArea = 0;
area = zeros(1,nBox*mBox);
for i = 1:nBox*mBox
    if SST_validation(1,i) ~= NaNset
        TotalArea = TotalArea+ActualAreaRectangle(i);
        area(i) = ActualAreaRectangle(i);
    end
end

%Performing a weighted average
for i = 1:val_days
    for j = 1:nBox*mBox
        if SST_validation(1,j) ~= NaNset   %ie it is on land
            SSTavgdiff(i)=SSTavgdiff(i)+SSTdiff(i,j)*area(j);
        end    
    end
end
SSTavgdiff = SSTavgdiff/TotalArea;       

%% Finding Max Error

for j = 1:val_days
    SSTmaxdiff(j) = max(SSTdiff(j,:));
end


%% Plotting

figure(2)
plot(SSTavgdiff)
xlabel('Number of Days into Prediction')
ylabel('Average Error (Degrees Kelvin)')
title('Average Error over Forecast')
grid on
set(gca,'FontSize',15)

figure(3)
plot(SSTmaxdiff)
xlabel('Number of Days into Prediction')
ylabel('Maximum Error (Degrees Kelvin)')
title('Maximum Error over Forecast')
grid on
set(gca,'FontSize',15)

end