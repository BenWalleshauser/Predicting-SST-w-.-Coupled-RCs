function W_out = LinReg(R, U,beta)
Rt = transpose(R);

W_out = (transpose(U)*Rt)*(inv( (R*Rt) + beta.*eye(length( R(:,1) ) ) ) );
end
