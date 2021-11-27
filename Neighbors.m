function [neighbors] = Neighbors(num, rows, cols)
    
k = 0; %num of neighbors
%Neighbor beneath
Bottom = 0;
if num/rows ~= ceil(num/rows)   %ie not at bottom of matrix
    k = k+1;
    Bottom = 1;
    neighbors(k) = num+1;
end

%Neighbor above
Top = 0;
if (num-1)/rows ~= ceil((num-1)/rows) & num ~= 1
    k = k+1;
    Top = 1;
    neighbors(k) = num-1;
end

%Neighbor right
Right = 0;
if num <= rows*cols-rows
    k = k+1;
    Right = 1;
    neighbors(k) = num + rows;
end
if num > rows*cols-rows   %if on far edge of map
    k = k+1;
    %Right = 1;
    neighbors(k) = num - (rows*cols-rows);
end

%Neighbor left
Left = 0;
if num >= rows+1
    k = k+1;
    Left = 1;
    neighbors(k) = num - rows;
end
if num < rows+1
    k = k+1;
    %Left = 1;
    neighbors(k) = num + (rows*cols-rows);
end

%Top Left
if Top == 1 %if not on top edge
    k = k+1;
    neighbors(k) = num-rows-1;
    if neighbors(k) < 1 %if wraps around
        neighbors(k) = neighbors(k) + rows*cols;
    end
end

%Top Right
if Top == 1 
    k = k+1;
    neighbors(k) = num+rows-1;
    if neighbors(k) > rows*cols %if wraps around
        neighbors(k) = neighbors(k) - rows*cols;
    end
end

%Bottom Right
if Bottom == 1 
    k = k+1;
    neighbors(k) = num+rows+1;
    if neighbors(k) > rows*cols %if wraps around
        neighbors(k) = neighbors(k) - rows*cols;
    end
end

%Bottom Left
if Bottom == 1 
    k = k+1;
    neighbors(k) = num-rows+1;
    if neighbors(k) < 1 %if wraps around
        neighbors(k) = neighbors(k) + rows*cols;
    end
end


end