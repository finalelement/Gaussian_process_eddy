function e = eddyField(x,y,z,B)

    e = zeros(x,y,z);
    for i= 1:x
        for j= 1:y
            for k= 1:z
                basis = [i j k i^2 j^2 k^2 i*j i*k j*k 0];
                e(i,j,k) = basis * B';
            end
        end
    end

end

