function M = voxel2mm( x,y,z,voxX, voxY, voxZ )

        %Assumptions:
        %   1. Voxel coordinates are at center of Voxel for mm
        %   2. Not rounding the geometric center

    geoCenter = [(x+1)/2, (y+1)/2, (z+1)/2];
    M = zeros(x,y,z,3);
    
    for i =1:x
        for j = 1:y
            for k = 1:z
                M(i,j,k,:) = [(geoCenter(1)-i)*voxX, (geoCenter(2)-j)*voxY, (geoCenter(3)-k)*voxZ];
            end
        end
    end
    
    
    
end

