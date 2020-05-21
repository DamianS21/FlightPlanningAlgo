function [xcentr,ycentr,r,xkolo,ykolo] = circle_points(xp,yp) 
lpkt=numel(nonzeros(xp));
%plot(xp,yp, 'x-');%Generowanie punktów w uk³adzie
%---------------------- Wyzaczenia okrêgu opisanego na figurze ----------%
%--------------------- Wyzaczenia œrodka ciêzkoœci figury ----------------%
[geom] = polygeom( xp,yp ); %wyznaczenie œrodka ciê¿koœci figury
xcentr=geom(2);
ycentr=geom(3);
%--------------------- Wyzaczenia okrêgu ---------------------------------%
%-- Wyznaczanie okrêgu jako promieñ od œrodka ciê¿koœci do najdalszego
% punktu figury --  
for(i=1:lpkt)
    promien(i)=sqrt((xp(i)-xcentr)^2+(yp(i)-ycentr)^2);
end
rmax=max(promien);
r = rmax;
[xkolo,ykolo]=okrag(xcentr,ycentr,r);
plot(xkolo, ykolo);

end
%############################# EOF #######################################%