function [xpunkt,ypunkt,xcentr,ycentr,r,xkolo,ykolo,lstref,lpkt]=poligeni
%/---- Design assumptions ---/
lstref=5; %Number of zones in example
%---- Zone ranges ----
% Point coordinate ranges (X) 
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
% Point coordinate ranges (Y)
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

%------- Generate random zones and circles inscribed on zones---%
for j=1:lstref
    %----- Points ------
    lpkt(j)=15; %number of points that zones will have
    
    [xpunkt(:,j),ypunkt(:,j),xcentr(:,j),ycentr(:,j),r(j),xkolo(:,j),ykolo(:,j)] = polygen(lpkt(j),zakx(:,j),zaky(:,j)); %generate zones
end
clear zakx;
clear zaky;