function [xcentr,ycentr,r,xkolo,ykolo] = circle_points(xp,yp) 
lpkt=numel(nonzeros(xp));
%plot(xp,yp, 'x-');%Generate points in coordinate system
%---------------------- Determine circle inscribed on figure ----------%
%--------------------- Determine center of gravity of figure ------------%
[geom] = polygeom( xp,yp ); %determine center of gravity of figure
xcentr=geom(2);
ycentr=geom(3);
%--------------------- Determine circle ---------------------------------%
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