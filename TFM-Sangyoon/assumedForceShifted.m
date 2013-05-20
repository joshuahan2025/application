function force = assumedForceShifted(j,x,y,xshift,yshift,wx,wy,d1,d2,forceType)
% This function assumedForceShifted takes grid x and y and make gaussian
% distributed force field of which sources are xshift and yshift.
% input     :   x           grid of x coordinates
%               y           grid of y coordinates
%               xshift      x value of point source of force
%               yshift      y value of point source of force
%               wx          x component of force orientation
%               wy          y component of force orientation
%               forceType   type of force
%               ('pointForce','groupForce', or 'smoothForce')
%               FAsize      'largeFA' or 'smallFA'
%               dx,dy       diameter of FA in pixel in directions of normal
%               and tangential to (wx, wy) assuming that the length of FA
%               is in parallel with the direction of force
%               
% output    :   force       x or y grid of force distribution (if j=1 or 2,
% respectively)
%              
% Sangyoon Han Jan 2013
% if strcmp(FAsize,'largeFA')
%     std = 4.5;
%     adh_r = 4.1; % adhesion diameter in pixel
% else
%     std = 1.5;
%     adh_r = 1.1;
% end

% orientation of force
theta = atan2(wy,wx);

stdx = d1+0.5;
stdy = d2+0.5;
adh_rx = d1;
adh_ry = d2;
amp = sqrt(wx^2+wy^2);
if j==1
    switch(forceType)
        case 'groupForce'
            % force is generated first in reference frame
%             x = u * cos(theta) + v * sin(theta);                    % u --> x
%             y = u * sin(-theta) + v * cos(theta);                   % v --> y
%             force = exp( - 0.5 * x^2 / (sigmaX^2) - 0.5 * y^2 / (sigmaY^2));

            force = anisoGaussian2D(xshift, yshift, amp, stdx, stdy, theta, x(1,:), y(:,1)');
            force = reshape(force,size(x));
                % anisotropic Gaussian 2D model defined by 6 parameters:
                %    xy      : position of the segment's center
                %    amp     : mean amplitude along the segment
                %    sigmaX  : dispersion along the main axis
                %    sigmaY  : dispersion aside the main axis
                %    theta   : orientation [-pi/2, pi/2)
            
%             force=wx*(heaviside(adh_r-sqrt((x-xshift).^2+(y-yshift).^2)).*...
%                 (exp(-((x-xshift).^2+(y-yshift).^2)/(2*std^2))));
        case 'pointForce'
            force=wx*(x==xshift || y==yshift);
        case 'smoothForce'
            force=wx*(exp(-((x-xshift).^2+(y-yshift).^2)/(2*std^2)));
    end
elseif j==2
    switch(forceType)
        case 'groupForce'
            force=wy*(heaviside(adh_r-sqrt((x-xshift).^2+(y-yshift).^2)).*...
                (exp(-((x-xshift).^2+(y-yshift).^2)/(2*std^2))));
        case 'pointForce'
            force=wy*(x==xshift || y==yshift);
        case 'smoothForce'
            force=wy*(exp(-((x-xshift).^2+(y-yshift).^2)/(2*std^2)));
    end
else
    error('please input 1 or 2 for j');
end

return

% test in 1D
x = 0:1:20;
xshift = 7;
std1d = 2;
w = 1300;
fd = w*heaviside(2.1-sqrt((x-xshift).^2)).*...
    exp(-((x-xshift).^2)/(2*std1d^2));
% fd = exp(-((x-xshift).^2)/(std^2));
% fd = x==xshift;
figure,plot(x,fd)
     
% test in 2D
[x,y] = meshgrid(1:20,1:20);
xshift = 7;
yshift = 9;
std1d = 2;
wx = 10;
wy = 100;
amp = (wx^2+wy^2)^.5;
d1 = 2;
d2 = 10;
forceType = 'groupForce';
force = assumedForceShifted(1,x,y,xshift,yshift,wx,wy,d1,d2,forceType);

force = anisoGaussian2D(xshift, yshift, amp, stdx, stdy, theta, x(1,:), y(:,1)');
force = reshape(force,size(x));
% fd = exp(-((x-xshift).^2)/(std^2));
% fd = x==xshift;
figure,plot(x,fd)
