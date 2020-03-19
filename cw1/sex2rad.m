function [ rad ] = sex2rad( deg, min, sec )
    rad = deg2rad(deg + (min + sec/60)/60);
    
end
