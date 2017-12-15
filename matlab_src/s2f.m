function xpd = s2f(x,y,z,r,M,h,e,a,vox_coord)
    %assume a is 1x4 according two current volume
    
    X_p = zeros(x,y,z,3);

    R = eye(3);
    for i= 4:6
        R = R * [1 0 0 ; 0 cos(r(i)) sin(r(i)); 0 -sin(r(i)) cos(r(i))];
    end
    
    P = [R r(1:3)'; 0 0 0 1];
    
    
    %Creating the t-form object
    A = P;
    tform = affine3d(A);
    
    % imwarp for rigid body transformation
    h_rigid_out = imwarp(h,tform);
    
    % Eddy rigid registered field with susceptibility field
    phi_field = e + h_rigid_out;
    
    d = zeros(size(X_p));
    x_p = zeros(size(X_p));
    vol_a_11 = zeros(x,y,z);
    
    for i = 1:x
        for j = 1:y
            for k = 1:z
                vol_a_11(i,j,k) = 1/(pinv([squeeze(M(i,j,k,:)); 1])*pinv(P)* ... 
                                       [squeeze(M(i,j,k,:)); 1]);
                       
                       
                %x_p = x_p(1:3);
                x_p(i,j,k,:) = [i j k];
                
                d(i,j,k,:) = pinv([phi_field(i,j,k)*a(1)*a(4) ... 
                              phi_field(i,j,k)*a(2)*a(4) ...
                              phi_field(i,j,k)*a(3)*a(4)]');
                
                %X_p(i,j,k,:) = x_p+d;
                
            end
        end
    end
    
    %d = pinv(d);
    
    xpd = x_p+d;
    
    for v_l=1:3
        xpd(:,:,:,v_l) = xpd(:,:,:,v_l).* vol_a_11;
    end
    
    
    
   
end

