function [e_x, e_y, e_z] = eddyDerivField(x,y,z,B)

    e_x = zeros(x,y,z);
    e_y = zeros(x,y,z);
    e_z = zeros(x,y,z);
    for i= 1:x
        for j= 1:y
            for k= 1:z
                basis_x = [1 0 0 2*i 0 0 j k 0 0];
                basis_y = [0 1 0 0 2*j 0 i 0 k 0];
                basis_z = [0 0 1 0 0 2*k i j 0 0];
                e_x(i,j,k) = basis_x * B';
                e_y(i,j,k) = basis_y * B';
                e_z(i,j,k) = basis_z * B';
            end
        end
    end

end

