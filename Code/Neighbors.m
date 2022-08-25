function [neighbors] = Neighbors(ind, nBox, mBox)
%Returns the neighboring indices surrounding a point on the globe. Disregards the
%neighbors that wrap around on the bottom of the map as they are all land
%values (due to Antarctica). 

k = 0; %index of neighbors, increases as conditions met

%% Top, Bottom, Left, and Right
%Neighbor beneath
Bottom = 0;
if ind/nBox ~= ceil(ind/nBox)   %ie not at bottom of map
    k = k+1;
    Bottom = 1;
    neighbors(k) = ind+1;
end

%Neighbor above
Top = 0;
if (ind-1)/nBox ~= ceil((ind-1)/nBox) & ind ~= 1 %If point is not on top of the map
    k = k+1;
    Top = 1;
    neighbors(k) = ind-1;
end
TopMap = 0;
if mod(ind-1,nBox) == 0   %If point is on top of the map
    k = k+1;
    TopMap = 1;
    myCol = (ind-1)/nBox+1;
    neighborCol = 240-myCol+1;
    neighbors(k) = (neighborCol-1)*nBox+1;
end

%Neighbor right
if ind <= nBox*mBox-nBox  %If point is not on the right edge of map
    k = k+1;
    neighbors(k) = ind + nBox;
end
if ind > nBox*mBox-nBox   %If point is on the right edge of map
    k = k+1;
    neighbors(k) = ind - (nBox*mBox-nBox);
end

%Neighbor left
if ind >= nBox+1       %If point is not on the left edge of the map
    k = k+1;
    neighbors(k) = ind - nBox;
end
if ind < nBox+1        %If point is on the left edge of the map
    k = k+1;
    neighbors(k) = ind + (nBox*mBox-nBox);
end

%% Corners

%Top Left
if Top == 1 %If not on top edge
    k = k+1;
    neighbors(k) = ind-nBox-1;
    if neighbors(k) < 1 %If on left edge therefore the neighbor wraps around
        neighbors(k) = neighbors(k) + nBox*mBox;
    end
end
if TopMap == 1;   %If on top edge
    neighborCol = 240-myCol+1+1;
    if neighborCol ~= mBox+1        %Would be it's own neighbor if condition true
        k = k+1;
        neighbors(k) = (neighborCol-1)*nBox+1;
    end
end

%Top Right
if Top == 1      %If not on top edge
    k = k+1;
    neighbors(k) = ind+nBox-1;
    if neighbors(k) > nBox*mBox %If on right edge therefore the neighbor wraps around
        neighbors(k) = neighbors(k) - nBox*mBox;
    end
end
if TopMap == 1;           %If on top edge
    neighborCol = 240-myCol+1-1;
    if neighborCol ~= 0        %Would be it's own neighbor if condition true
        k = k+1;
        neighbors(k) = (neighborCol-1)*nBox+1;
    end
end

%Bottom Right
if Bottom == 1 
    k = k+1;
    neighbors(k) = ind+nBox+1;
    if neighbors(k) > nBox*mBox %If on right edge therefore the neighbor wraps around
        neighbors(k) = neighbors(k) - nBox*mBox;
    end
end

%Bottom Left
if Bottom == 1 
    k = k+1;
    neighbors(k) = ind-nBox+1;
    if neighbors(k) < 1 %If on left edge therefore the neighbor wraps around
        neighbors(k) = neighbors(k) + nBox*mBox;
    end
end

end
