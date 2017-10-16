
function out = gpr_spherical_covar(g,g_prime,alpha)

    % If shit doesn't go down then check on the minimum angle stuff again
    % for two 3D vectors which are g and g_prime. 
    
    theta = atan2(norm(cross(g,g_prime)),dot(g,g_prime));
    
    if(theta <= alpha)
        out = 1-(3*theta)/(2*alpha)+(theta^3)/(2*alpha^3);
    else
        out = 0;
    end
end