function [xp,yp,xcentr,ycentr,r,xkolo,ykolo] = polygen(lpkt,zakx,zaky) 
%_________________________________________________________________________%
%| Script for generating random zones with surrounding circles          |%
%|Must provide range for point generation and their quantity            |%
%|Script is part of diploma thesis at Rzeszow University of Technology |%
%|                    Damian Szumski 2018                               |%
%|                  damianszumski@yahoo.com                             |%
%|______________________________________________________________________ |%
%--------------- Stage 1. Generate random points ----------------------%
for i=1:lpkt
    x(i)=randi(zakx); %Random points on x axis
    y(i)=randi(zaky); %Random points on y axis
    plot(x(i),y(i),'r*') %Project points onto 
end
%- Stage 2. Arrange points in non-intersecting way when connected -%
%Source of stage: https://stackoverflow.com/questions/29210958/connecting-random-points-in-matlab-without-intersecting-lines %
P = [x;y]; %// group the points as columns in a matrix
c = mean(P,2); %// center point relative to which you compute the angles 
d = bsxfun(@minus, P, c ); %// vectors connecting the central point and the dots
th = atan2(d(2,:),d(1,:)); %// angle above x axis
[st si] = sort(th);
sP = P(:,si); %// sorting the points

sP = [sP sP(:,1)]; %// add the first point again to close the polygon
xp=sP(1,:);
yp=sP(2,:);
plot(xp,yp, 'x-');%Generate points in coordinate system
%--------------------------------------------------------------
clear sP P c d th st si; %Clear auxiliary variables
%--------------- Stage 3. Determine circle inscribed on figure ----------%
%----------- Stage 3.1. Determine center of gravity of figure ------------%
[geom] = polygeom( xp,yp ); %determine center of gravity of figure
xcentr=geom(2);
ycentr=geom(3);
%----------- Stage 3.2. Determine circle ---------------------------------%
%-- Determine circle as radius from center of gravity to farthest
% point of figure --  
for(i=1:lpkt)
    promien(i)=sqrt((xp(i)-xcentr)^2+(yp(i)-ycentr)^2);
end
rmax=max(promien);
r = rmax;
[xkolo,ykolo]=okrag(xcentr,ycentr,r);
plot(xkolo, ykolo);

end
%############################# EOF #######################################%