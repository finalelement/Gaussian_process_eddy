function K_y = gpr_K_matrix(b_vectors,b_vectors_prime, theta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% theta = [alpha, lambda, sigma]

    dims = size(b_vectors);
    K = zeros(dims(1));
    for i=1:dims(1)
        for j=1:dims(1)
            K(i,j) = gpr_spherical_covar(b_vectors(i,:),b_vectors(j,:),theta(1),theta(2));
        end        
    end

    theta(3) = exp(theta(3)^2);    
    K_y = K + theta(3) * eye(dims(1));

end