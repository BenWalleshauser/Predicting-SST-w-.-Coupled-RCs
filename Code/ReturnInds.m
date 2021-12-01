function ind = ReturnInds(lat,lon,nBox)
%Returns the corresponding index of a given latitude and longitude.

if lat == 90;
    lat = 89.99;
elseif lat == -90;
    lat = -89.99;
end

if lon == 180;
    lon = 179.99;
elseif lon == -180;
    lon = -179.99;
end

%Each box is Deg x Deg on the map
Deg = 180/nBox;
ind = nBox*floor((lon+180)/Deg) + ceil((90-lat)/Deg);

end
