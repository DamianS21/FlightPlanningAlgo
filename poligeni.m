function [xpunkt,ypunkt,xcentr,ycentr,r,xkolo,ykolo,lstref,lpkt]=polgeni
%/---- Zalozenia projektowe ---/
lstref=5; %Iloœæ stref w przyk³adzie
%---- Zakresy stref ----
% Zakresy wsp. punktów (X) 
zakx(:,1)=[-20 -1];
zakx(:,2)=[20 40];
zakx(:,3)=[70 90];
zakx(:,4)=[45 65];
zakx(:,5)=[45 60];
zakx(:,6)=[10 30];
zakx(:,7)=[100 120];
zakx(:,8)=[90 110];
zakx(:,9)=[70 80];
zakx(:,10)=[20 30];
% Zakresy wsp. punktów (Y)
zaky(:,1)=[10 30];
zaky(:,2)=[30 50];
zaky(:,3)=[90 110];
zaky(:,4)=[60 80];
zaky(:,5)=[20 30];
zaky(:,6)=[1 20];
zaky(:,7)=[20 40];
zaky(:,8)=[70 90];
zaky(:,9)=[45 65];
zaky(:,10)=[60 80];
%----------------------

%------- Generowanie losowych stref i okregów opisanych na strefach---%
for j=1:lstref
    %----- Punkty ------
    lpkt(j)=15; %iloœæ punktów jakie bêd¹ posiadaæ strfy
    
    [xpunkt(:,j),ypunkt(:,j),xcentr(:,j),ycentr(:,j),r(j),xkolo(:,j),ykolo(:,j)] = polygen(lpkt(j),zakx(:,j),zaky(:,j)); %generowanie stref
end
clear zakx;
clear zaky;