function [ kVector ] = knotVector(bounds, interval, voxDim)
    
    interval = floor(interval/voxDim)*voxDim;
    kVector = [];
    i = bounds(1);
    while i < bounds(2)
        kVector = [kVector, i];
        i = i+interval;
    end

end

