function [lat,lon] = ReturnCoords(ind,nBox)
%Input the index of a point on the map and get the corresponding
%coordinates of the center of the index.

Deg = 180/nBox;

%Longitude:
lon1 = -180+Deg*floor((ind-1)/nBox);
lon2 = lon1+Deg;
lon = (lon1 + lon2)/2;

%Latitude:
if rem(ind,nBox) ~= 0
    lat1 = 90-rem(ind,nBox)*Deg;
    lat2 = lat1 + Deg;
    lat = (lat1+lat2)/2;
elseif rem(ind,nBox) == 0
    lat1 = -90+Deg;
    lat2 = -90;
    lat = (lat1+lat2)/2;
end
end