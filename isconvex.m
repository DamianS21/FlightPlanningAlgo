function [znak]=isconvex(xp,yp,limit)
%ISCONVEX Function checking convexity of figure by providing points of this
%figure and their quantity. Function returns signs. If any of them is
%less than zero the figure is not convex.
% Must provide figure point coordinates and quantity
% Usage example: sign=isconvex(figure_x_coords, figure_y_coords, point_count);
% (C) Damian Szumski 2018
% Source: https://matlabgeeks.com/tips-tutorials/computational-geometry/check-convexity-of-polygon/
xd=xp(1:end-1);
yd=yp(1:end-1);
v1 = [xd(1) - xd(end), yd(1) - yd(end)];
v2 = [xd(2) - xd(1), yd(2) - yd(1)];
znak(1) = sign(det([v1; v2]));
for k = 2:limit-1
        v1 = v2;
        v2 = [xd(k+1) - xd(k), yd(k+1) - yd(k)];
        znak(k) = sign(det([v1; v2]));
    end
    v1 = v2;
    v2 = [xd(1) - xd(end), yd(1) - yd(end)];
    znak(limit) = sign(det([v1; v2]));
    if(znak(limit)<=0)
    end
end