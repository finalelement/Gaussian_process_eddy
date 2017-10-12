% Function to get angle in radians between two gradient directions
% Feed 3D vectors for inputs in the form [a,b,c] , [d,e,f]
function angle_rad = return_angle_two_ngs(x1,x2)

    if (length(x1) == 3 && length(x2) == 3)
        angle_rad = atan2(norm(cross(x1,x2)),dot(x1,x2));
    else
        disp('Error Vector is not 3D')
    end
    
    
end