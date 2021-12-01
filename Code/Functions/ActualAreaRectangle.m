function area = ActualAreaRectangle(ind,nBox)
    %Returns the actual area on a map encompassed by a given index on a map that has
    %nBox rows of indexes and has indices which have equal degree spacing
    %in both the latitudal and longitudinal direction. (E.g., 0.5x0.5
    %degree grid).
    
    %Degree spacing (assuming same in longitudinal direction)
    Deg = 180/nBox;
    
    %Longitude:
    lon1 = -180+Deg*floor((ind-1)/nBox);
    lon2 = lon1+Deg;

    %Latitude:
    if rem(ind,nBox) ~= 0
        lat1 = 90-rem(ind,nBox)*Deg;
        lat2 = lat1 + Deg;
    elseif rem(ind,nBox) == 0
        lat1 = -90+Deg;
        lat2 = -90;
    end
    
    %Area of rectangle:
    area = areaquad(lat1,lon1,lat2,lon2);
end
