function [xp,yp,xcentr,ycentr,r,xkolo,ykolo] = polygen(lpkt,zakx,zaky) 
%_________________________________________________________________________%
%| Skrypt s≥uøπcy generacji losowych stref z otaczajπcymi je okrÍgami    |%
%|Naleøy podaÊ zakres w jakim majπ byÊ wygenerowane punkty oraz ich iloúÊ|%
%|Skrypt jest czÍúciπ pracy dyplomowej na Politechnice Rzeszowskiej KAiS |%
%|                    Damian Szumski 2018                                |%
%|                  damianszumski@yahoo.com                              |%
%|______________________________________________________________________ |%
%--------------- Etap 1. Generacja losowych punktÛw ----------------------%
for i=1:lpkt
    x(i)=randi(zakx); %Losowe punkty osi x
    y(i)=randi(zaky); %Losowe punkty osi y
    plot(x(i),y(i),'r*') %Rzutowanie punktÛw na 
end
%- Etap 2. Ustawianie punktÛw w sposÛb nieprzecinajπcy siÍ po po≥πczeniu -%
%èrÛd≥o etapu: https://stackoverflow.com/questions/29210958/connecting-random-points-in-matlab-without-intersecting-lines %
P = [x;y]; %// group the points as columns in a matrix
c = mean(P,2); %// center point relative to which you compute the angles 
d = bsxfun(@minus, P, c ); %// vectors connecting the central point and the dots
th = atan2(d(2,:),d(1,:)); %// angle above x axhis
[st si] = sort(th);
sP = P(:,si); %// sorting the points

sP = [sP sP(:,1)]; %// add the first point again to close the polygon
xp=sP(1,:);
yp=sP(2,:);
plot(xp,yp, 'x-');%Generowanie punktÛw w uk≥adzie
%--------------------------------------------------------------
clear sP P c d th st si; %Czyszczenie zmiennych pomocnicznych
%--------------- Etap 3. Wyzaczenia okrÍgu opisanego na figurze ----------%
%----------- Etap 3.1. Wyzaczenia úrodka ciÍzkoúci figury ----------------%
[geom] = polygeom( xp,yp ); %wyznaczenie úrodka ciÍøkoúci figury
xcentr=geom(2);
ycentr=geom(3);
%----------- Etap 3.2. Wyzaczenia okrÍgu ---------------------------------%
%-- Wyznaczanie okrÍgu jako promieÒ od úrodka ciÍøkoúci do najdalszego
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