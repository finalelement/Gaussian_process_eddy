function [h_x,h_y,h_z] = susceptDerivField(boundx, boundy, boundz, voxDim, interval, path_to_top_coeff)
    kVec_x = knotVector(boundx, interval, voxDim(1));
    kVec_y = knotVector(boundy, interval, voxDim(2));
    kVec_z = knotVector(boundz, interval, voxDim(3));
    
    order = 2;
    
%     x_coord = [boundx(1):voxDim(1):boundx(2)];
%     y_coord = [boundy(1):voxDim(2):boundy(2)];
%     z_coord = [boundz(1):voxDim(3):boundz(2)];

    x_coord = [boundx(1):boundx(2)];
    y_coord = [boundy(1):boundy(2)];
    z_coord = [boundz(1):boundz(2)];
    
    b_x = bspline_basismatrix(order,kVec_x,x_coord);
    b_y = bspline_basismatrix(order,kVec_y,y_coord);
    b_z = bspline_basismatrix(order,kVec_z,z_coord);
    
    coeffs = load_untouch_nii(path_to_top_coeff);
    
    coeffs = coeffs.img;
    
    
    
end