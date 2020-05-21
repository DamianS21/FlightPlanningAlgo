function [trasax,trasay] = intersection(xbef,ybef,xaft,yaft, xstart, ystart,xcel,ycel,xp,yp,limit) 
%__________________________________________________________________%
%|Skrypt generuj� trase omijaj�c� przeszkod� po kraw�dziach strefy|%
%|Do programu nale�y poda� punkt startu x, y oraz punkty celu x,y |%
%|        punkty przeszkody x,y, ilo�� punkt�w przeszkody.        |%
%|                    Damian Szumski 2018                         |%
%|                  damianszumski@yahoo.com                       |%
%|________________________________________________________________|%
%--------------- Etap VII Krok 2 Uwypuklenie przeszkody --------------%
znak=isconvex(xp,yp,limit);
if(any(znak(:)<0))
    j = boundary(xp,yp,0);
     plot(xp(j),yp(j)); %Rysowanie obrysu figury
    xp=(xp(j))';
    yp=(yp(j))';
end
clear j
%-------- Lokalizacja punkt�w przeci�cia z przeszkod� ---------------%
xt=[xstart xcel];
yt=[ystart ycel];
[xi,yi] = polyxpoly(xt,yt,xp,yp);
%--- Ustawienie macierzy przeciecia zgodnie z kierunkiem lotu ----%
if(~isempty(xi))%Sprawdzanie czy s� przeci�cia z figur�.
    [maxi,p]=max(xi);
    [mini,l]=min(xi);
    KURS=heading(xstart,xcel,ystart,ycel);
    if(and(KURS>180,KURS<360))
        xprzeciecia(1)=maxi;
        yprzeciecia(1)=yi(p);
        xprzeciecia(2)=mini;
        yprzeciecia(2)=yi(l);
    else
        xprzeciecia(1)=mini;
        yprzeciecia(1)=yi(l);
        xprzeciecia(2)=maxi;
        yprzeciecia(2)=yi(p);
    end
    
%- Etap 4. Wyb�r numer�w punkt�w przypadaj�ce jako pierwsze w locie stref�-%
%-------  Tworzenie macierzy odleg�o�ci mi�dzy punktami -----------%
    limit_zredukowany=numel(xp)-1;
    for i=1:limit_zredukowany
        dist(i)=sqrt((xp(i+1)-xp(i))^2+(yp(i+1)-yp(i))^2);%Odleg�o�� mi�dzy punktami
    end
%------------ Lokalizacja punktu przeci�cia wlotu ---------------%
    for i=1:(limit_zredukowany)
        pdist(i)=sqrt((xp(i)-xprzeciecia(1))^2+(yp(i)-yprzeciecia(1))^2); %Odleglosc mi�dzy pkt przeci�cia, a ka�dym z punkt�w
    end
    for i=1:(limit_zredukowany)
        if(i<limit_zredukowany)
            sumap1(i)=pdist(i)+pdist(i+1);%Suma kolejnych odleg�o�ci mi�dzy pkt przeci�cia, a ka�dym z punkt�w
        end
        if(i==limit_zredukowany)
            sumap1(i)=pdist(i)+pdist(1);
        end
        roznica(i)=abs(sumap1(i)-dist(i));
    end
    [temp, pkt1]=min(roznica);
%------------ Lokalizacja punktu przeci�cia wylotu ---------------%
    %--- Czyszczenie zmiennych pomocnicznych ---
    %
    for i=1:(limit_zredukowany)
        pdist(i)=sqrt((xp(i)-xprzeciecia(2))^2+(yp(i)-yprzeciecia(2))^2); %Odleglosc mi�dzy pkt przeci�cia, a ka�dym z punkt�w
    end
    for i=1:(limit_zredukowany)
        if(i<limit_zredukowany)
            sumap2(i)=pdist(i)+pdist(i+1);%Suma kolejnych odleg�o�ci mi�dzy pkt przeci�cia, a ka�dym z punkt�w
        end
        if(i==limit_zredukowany)
            sumap2(i)=pdist(i)+pdist(1);
        end
        roznica(i)=abs(sumap2(i)-dist(i));
    end
    
    [temp, pkt2]=min(roznica);
%------------- Etap VII Krok 4 Wyznaczanie trasy 1 omini�cia przeszkody ---------------------%
%-------------  Wyznaczanie ilo�ci punkt�w trasy 1------%
    if(pkt2<(pkt1+1))%Je�li punkt jest za ko�cem tablicy 
        iloscpkttrasa1=(limit_zredukowany-(pkt1+1))+pkt2 +1;%Ilosc elementow w tablicy zredukowanej (bez ostatniego) - pozycja pkt wejscia + pozycja pkt wyjscia -1(odj�� jego samego)
    else
        iloscpkttrasa1=abs((pkt2-(pkt1+1))+1);
    end
%------------- Generowanie wsp�rz�dnych X trasy 1-----%
 trasax=[xbef];%Dodanie wsp�rz�denj X punktu przewidywa� 1
    o=pkt1+1;
    for i=1:(iloscpkttrasa1)
        if(o>limit_zredukowany)
            o=1;
        end
        trasax=[trasax xp(o)];
        o=o+1; 
    end
     trasax=[trasax xaft];%Dodanie wsp�rz�denj X punktu przewidywa� 2
%------------- Generowanie wsp�rz�dnych Y trasy 1 -----%
 trasay=[ybef]; %Dodanie wsp�rz�dnej Y punktu przewidywa� 1
    o=pkt1+1;
    for i=1:(iloscpkttrasa1)
        if(o>limit_zredukowany)
            o=1;
        end
        trasay=[trasay yp(o)];
        o=o+1;
    end
     trasay=[trasay yaft]; %Dodanie wsp�rz�dnej Y punktu przewidywa� 2
%------------- Etap VII Krok 5 Wyznaczanie trasy 2 omini�cia przeszkody ---------------------%
%------------- Wyznaczanie ilo�ci punkt�w trasy 2 ------%
    iloscpkttrasa2=limit_zredukowany-iloscpkttrasa1;
    if(iloscpkttrasa2<0)
        iloscpkttrasa2=0;
    end
%------------- Generowanie wsp�rz�dnych X trasy 2 -----%
%     trasax2=[xprzeciecia(1)];
 trasax2=[xbef];
    o=pkt1;
    for i=1:(iloscpkttrasa2)
        if(o<1)
            o=limit_zredukowany;
        end
        trasax2=[trasax2 xp(o)];
        o=o-1;
    end
 trasax2=[trasax2 xaft];
%-------------  Generowanie wsp�rz�dnych Y trasy 2 -----%
%     trasay2=[yprzeciecia(1)];
 trasay2=[ybef];
    o=pkt1;
    for i=1:(iloscpkttrasa2)
        if(o<1)
            o=limit_zredukowany;
        end
        trasay2=[trasay2 yp(o)];
        o=o-1;
    end
    %trasay2=[trasay2 yp(pkt2+1)];
 trasay2=[trasay2 yaft];
%     trasay2=[trasay2 yprzeciecia(2)];
%     plot(trasax2,trasay2,'--r','LineWidth',2);
    
%- Etap VII Krok 6 Wyznaczanie d�ugo�ci tras i wyb�r kr�tszej trasy ------%
%------------- Wyznaczanie d�ugo�ci trasy 1 --------------------%
   iloscpkttrasa1=numel(trasax);
   dist1=0;
   for i=1:(iloscpkttrasa1-1)
       dist1=dist1+sqrt((trasax(i+1)-trasax(i))^2+(trasay(i+1)-trasay(i))^2);
   end
%         plot(trasax,trasay,'-mo','LineWidth',2);
%------------- Wyznaczanie d�ugo�ci trasy 2 --------------------%
   iloscpkttrasa2=numel(trasax2);
   dist2=0;
   for i=1:(iloscpkttrasa2-1)
       dist2=dist2+sqrt((trasax2(i+1)-trasax2(i))^2+(trasay2(i+1)-trasay2(i))^2);
   end
%------------- \ Decyzja kt�ra trasa jest kr�tsza  ---------------%
   if(dist1<dist2)
        clear trasax2 trasay2;
   end
   if(dist2<dist1)
       trasax=trasax2;
       trasay=trasay2;
   end   
%- Etap VII Krok 7 Usuni�cie pierwszego i ostatniego punktu z trasy omini�cia przeszkody ------%
trasax(1)=[];
trasax(end)=[];
trasay(1)=[];
trasay(end)=[];
iloscpkttrasa1=numel(trasax);




end
if(isempty(xi))%Je�eli nie ma przeci�� z figur�
    trasax=[xstart xcel];
    trasay=[ystart ycel];
end
end