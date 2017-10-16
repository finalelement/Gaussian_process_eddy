
function out = gpr_spherical_covar(g,g_prime,alpha,lambda)

    % for two 3D vectors which are g and g_prime. 
    lambda = exp(lambda);
    theta = atan2(norm(cross(g,g_prime)),dot(g,g_prime));
    theta = min(theta, pi-theta);
    if(theta <= alpha)
        out = 1-(3*theta)/(2*alpha)+(theta^3)/(2*alpha^3);
    else
        out = 0;
    end
    out= out*lambda;
end