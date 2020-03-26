function [ rad ] = sex2deg( deg, min, sec )
    rad = deg + (min + sec/60)/60;
    
end
