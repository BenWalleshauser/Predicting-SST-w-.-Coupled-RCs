function A = generate_reservoir(dim_reservoir, rho, density)
%Creates the input matrix from a uniform distribution from -1 to 1.
%The spectral radius is set to rho.

array = rand(dim_reservoir,dim_reservoir) < density;    
ran = 2*(rand(dim_reservoir,dim_reservoir)-0.5);
res = ran.*array;   

[eigvec,eigval]=eig(res) ;    
max_eig = max(max(eigval));    
max_length = abs(max_eig);      
A = res/(max_length).*rho;     
end
