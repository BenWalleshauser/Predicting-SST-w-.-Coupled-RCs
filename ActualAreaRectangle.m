function area = ActualAreaRectangle(ind)
    %Input the indice of the box (e.g., 1 is the top left, 120 is the
    %bottom left, 121 is first row second column, etc.)
    
    %Number of rows in a column
    nBox = 120;
    
    %Longitude:
    lon1 = -180+1.50*floor((ind-1)/nBox);
    lon2 = lon1+1.5;

    %Latitude:
    if rem(ind,nBox) ~= 0
        lat1 = 90-rem(ind,nBox)*1.5;
        lat2 = lat1 + 1.5;
    elseif rem(ind,nBox) == 0
        lat1 = -88.5;
        lat2 = -90;
    end
    
    %Area of rectangle:
    area = areaquad(lat1,lon1,lat2,lon2);
end