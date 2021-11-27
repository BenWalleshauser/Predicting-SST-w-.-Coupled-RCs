function PackInd = FindPackIndices(Avgs,nBox,mBox,nPack,mPack,NaNset)
%Returns the matrix indices that are in each pack. Each column of indices
%contains the points within a pack.


if nBox/nPack ~= ceil(nBox/nPack) | mBox/mPack ~= ceil(mBox/mPack)
    error('Number of Boxes needs to be divisible by num of RCs (Packs)')
end
NumPacks = (nBox*mBox)/(nPack*mPack);

%Finding the indices of the boxes per pack/RC
PackInd = zeros(nPack*mPack,NumPacks);
d = 1;
c = 0;
b = 0;
e = 0;
mult = 0;       %shifts right 
mult2 = 0;      %shifts down'
for i = 1:NumPacks 
        for j = 1:mPack
            for k = 1:nPack
                %Cycling through pack:
                PackInd(b+1,i) = (j-1)*nBox + k + mult2*nPack + mult*nBox*mPack;
                b = b+1;
                if Avgs(1,PackInd(b,i)) == NaNset    %if index is on land                                
                     PackInd(b,i) = 0;             %get rid of index 
                end
            end

            if b >= nPack*mPack    %ie if completed a box, shift points down dim
                mult2 = mult2+1;        
                b = 0;
            end
        end       
        c = c + 1;          %increment if pack completed
        if c >= nBox/nPack           %ie if column of groupings full 
            mult = mult+1;      %increment numbers right by n*dim
            c = 0;
            mult2 = 0;            %reset shift down
        end

end

end
