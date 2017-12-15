function X_p = f2s(x,y,z,r,M,h,e,a,vox_coord)
    %assume a is 1x4 according two current volume
    
    X_p = zeros(x,y,z,3);

    R = eye(3);
    for i= 4:6
        R = R * [1 0 0 ; 0 cos(r(i)) sin(r(i)); 0 -sin(r(i)) cos(r(i))];
    end
    
    P = [R r(1:3)'; 0 0 0 1];
    Pv = pinv(P);
    
    
    %Creating the t-form object
    A = P;
    tform = affine3d(A);
    
    % imwarp for rigid body transformation
    ef_rigid_out = imwarp(e,tform);
    
    % Eddy rigid registered field with susceptibility field
    phi_field = h + ef_rigid_out;
    
    
    %NOTE: NOT CORRECT, X IS INCREASING ROW WISE AND NOT COLUMN WISE,
    %               CHECK Y AS WELL.
    
    for i = 1:x
        for j = 1:y
            for k = 1:z
                x_p = pinv([squeeze(M(i,j,k,:)); 1])*pinv(P)* ... 
                           [squeeze(M(i,j,k,:)); 1]*[i j k 1]';
                       
                x_p = x_p(1:3);
                
                d = [phi_field(i,j,k)*a(1)*a(4) ... 
                    phi_field(i,j,k)*a(2)*a(4) ...
                    phi_field(i,j,k)*a(3)*a(4)]';
                
                X_p(i,j,k,:) = x_p+d;
                
            end
        end
    end
   
end

