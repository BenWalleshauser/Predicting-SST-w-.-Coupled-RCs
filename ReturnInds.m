function ind = ReturnInds(lat,lon)

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

%Each box is 1.50 degree x 1.50 degree on the map
dim = 1.50;
ind = 120*floor((lon+180)/dim) + ceil((90-lat)/dim);

end