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
mult = 0;       
mult2 = 0;      
for i = 1:NumPacks 
        for j = 1:mPack
            for k = 1:nPack
                %Cycling through each pack:
                PackInd(b+1,i) = (j-1)*nBox + k + mult2*nPack + mult*nBox*mPack;
                b = b+1;
                if Avgs(1,PackInd(b,i)) == NaNset                                 
                     PackInd(b,i) = 0;             
                end
            end

            if b >= nPack*mPack    
                mult2 = mult2+1;        
                b = 0;
            end
        end       
        c = c + 1;         
        if c >= nBox/nPack          
            mult = mult+1;     
            c = 0;
            mult2 = 0;          
        end

end

end
