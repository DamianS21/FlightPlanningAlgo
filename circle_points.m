function [xcentr,ycentr,r,xkolo,ykolo] = circle_points(xp,yp) 
lpkt=numel(nonzeros(xp));
%plot(xp,yp, 'x-');%Generowanie punkt�w w uk�adzie
%---------------------- Wyzaczenia okr�gu opisanego na figurze ----------%
%--------------------- Wyzaczenia �rodka ci�zko�ci figury ----------------%
[geom] = polygeom( xp,yp ); %wyznaczenie �rodka ci�ko�ci figury
xcentr=geom(2);
ycentr=geom(3);
%--------------------- Wyzaczenia okr�gu ---------------------------------%
%-- Wyznaczanie okr�gu jako promie� od �rodka ci�ko�ci do najdalszego
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