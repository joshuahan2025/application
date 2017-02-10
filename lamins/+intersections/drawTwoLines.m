function [ I ] = drawTwoLines( angles, overlap )
%drawTwoLines draw lines at the angles going symmetrically through the
%center

I = zeros(100);
I_size = size(I);
radius = I_size(1)/2 -1;
center = I_size / 2;
% I(center(1),:) = 1;
for angle = angles
    projection = [cos(angle) sin(angle)]*radius;
    p = bresenham(round(center + projection), round(center - projection),8);
    idx = sub2ind(I_size, p(:,2), p(:,1));
    I(idx) = I(idx) + 1;
end

if(nargin < 2 || ~overlap)
    I = double(logical(I));
end


end

