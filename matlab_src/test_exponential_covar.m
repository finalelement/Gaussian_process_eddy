% Please note this is a simple test to replicate Fig 2 from the Anderson
% paper.

function [out,theta] = test_exponential_covar(g,g_prime,alpha)

    % If shit doesn't go down then check on the minimum angle stuff again
    % for two 3D vectors which are g and g_prime. 
    
    theta = atan2(norm(cross(g,g_prime)),dot(g,g_prime));
    theta = min(theta, pi-theta);
    out = exp(-theta/alpha);
end