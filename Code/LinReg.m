function W_out = LinReg(R,U,beta)
%Performing a ridge regression with a regularization parameter beta
%such that: U=~W_out*R

W_out = (transpose(U)*transpose(R))*(inv( (R*transpose(R)) + beta.*eye(length( R(:,1) ) ) ) );
end
