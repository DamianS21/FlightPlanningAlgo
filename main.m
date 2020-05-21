%________________________________________________________________%
%|         Program generuj�cy strefy zakazane do przelotu.      |%
%|   Pozwala on wybra� miejsce rozpocz�cia startu i ko�ca lotu  |%
%|  Nast�pnie generuje on tras� omijaj�c� po kraw�dziach stref  |%
%|        W nast�pnym kroku generuje on tras� zoptymalizowan�   |%
%|  Do poprawnego dzia�ania programu nale�y posiada� skrypty:   |%
%|       isconvex.m, polygeom.m, okrag.m, circle_points.m       |%
%|                 heading.m, intersection.m                    |%
%|                oraz baze danych punkt�w                      |%
%|                    Damian Szumski 2018                       |%
%|                  damianszumski@yahoo.com                     |%
%|______________________________________________________________|%
clear % Czyszczenie zmiennych
clc % Czyszczenie konsoli
%/---- W�asciwo�ci wykresu ----/
axis square;
grid on;
axis equal;
hold on
%ylim([49 52]); %Zakres AIRAC
%xlim([19 24]);
 xlim([-20 150]); %Zakresy poligeni i strefy_testowe.m
 ylim([0 150]);
%--------------- Etap I - Wyznaczenie punktu startu i celu --------------%
disp("Zaznacz punkt startu i naci�nij ENTER");
[xstart,ystart] = getpts;              % Wprowadzenie startu przez u�ytkownika
plot(xstart,ystart,'r*')               % Dodatnie punktu na wykresie plot
if(or(isempty(xstart),isempty(ystart))) 
error("Brak punktu startu!"); %Komunikat b��du gdy brak punktu
end
%--------------------------- Wsp�rz�dne celu ---------------------------%
disp("Zaznacz punkt celu i naci�nij ENTER"); %Informacja konsolowa
[xcel,ycel] = getpts;                  % Wprowadzenie celu przez u�ytkownika
plot(xcel,ycel,'g*')                   % Dodatnie punktu na wykresie plot
if(or(isempty(xcel),isempty(ycel)))
    error("Brak punktu celu!");
end
if(and(xstart==xcel,ystart==ycel))
    error("B��d 1 - brak trasy");
end
%------  Informacje konsolowe -------%
clc;
disp("Tworzenie trasy...");
tic %Rozpocz�cie liczeniu czasu
%-------------- Etap II - wyznaczenie prostej mi�dzy startem, a celem -------------%
coefficients = polyfit([xstart, xcel], [ystart, ycel], 1);  %Wsp�czynniki prostej kursowej
a1 = coefficients (1);                  % przypisane wsp�cznnika a
b1 = coefficients (2);                  % przypisanie wsp�czynnika b
%-------------- Etap III - Okre�lenie obszaru przeszkua� "przeszk�d"------%
%-------------- Wyznaczenie okr�gu opisanego na prostej start-cel --------%
xpr=(xcel+xstart)/2;                    % Wyznaczenie �rodka okr�gu (X)
ypr=(ycel+ystart)/2;                    % Wyznaczenie �rodka okr�gu (Y)
rpr=sqrt((xcel-xpr)^2+(ycel-ypr)^2);    % Wyznaczneie promienia ko�a
[xkoloa,ykoloa]=okrag(xpr,ypr,rpr);     % Generowanie okregu
plot(xkoloa, ykoloa,'--b');             % Drukowanie okr�gu na p�aszczy�nie
%-------------- Baza danych przeszk�d przszk�d ---------------------%
 [xpunkt,ypunkt,xcentr,ycentr,r,xkolo,ykolo,lstref,lpkt]=poligeni; %�r�d�o
% losowych przeszk�d
%strefy_testowe; %�r�d�o sztucznych przeszk�d
%data_AIRAC; %�r�d�o przeszk�d cyklu AIRAC
%---- Wyznaczanie ilo�ci stref ----%
lstref=numel(xpunkt(1,:));
%-------------- Etap III-2 Opisanie okr�gu na poligonach -----------%
for i=1:lstref
    [xcentr(:,i),ycentr(:,i),r(i),xkolo(:,i),ykolo(:,i)]=circle_points(nonzeros(xpunkt(:,i)),nonzeros(ypunkt(:,i)));
    lpkt(:,i)=numel(nonzeros(xpunkt(:,i)))-1;%Zera wyst�puj� gdy strefa ma mniej punkt�w
end
kstref=[]; %Tworzenie wektora zawieraj�cego numery stref oraz odle�o�ci od �rodka
for t=1:lstref
%---------- Etap IV Okre�lenie przeszk�d w zasi�gu -----------------%
    in(:,t) = inpolygon(xkolo(:,t),ykolo(:,t),xkoloa,ykoloa);
%- Etap V Przypisanie odleg�o�ci i numer�w stref w zasi�gu do macierzy kstref -%
    if(any(in(:,t))==1)
        kstref=[kstref [t;(sqrt((xcentr(:,t)-xstart)^2+(ycentr(:,t)-ystart)^2))]];
        plot(nonzeros(xpunkt(:,t)),nonzeros(ypunkt(:,t)), 'x-');%Generowanie punkt�w w uk�adzie
    end
end
clear in;                               % Czyszczenie zb�dnych zmiennych
if ~isempty(kstref)                     % je�li trasa przelatuje przez strefy:
    ilosc_stref=numel(kstref(1,:));     % Tworzenie zmiennej zawieraj�c� ilo�c stref znajduj�cych si� w obr�bie okr�gu
    kstref=sortrows(kstref',2,'ascend');%Sortowanie stref kolejno�ci� przelotu
    xtrasa=[xstart];                    % Dodanie punktu startu jako pierwszy punkt trasy
    ytrasa=[ystart];
    COURSE=[heading(xstart,xcel,ystart,ycel)]; % Generowanie kurs�w trasy
%- Etap VI Wyznaczneie przeszk�d kolizyjnych poprzez wyznaczenie punkt�w przeci�c prostej start-cel i okreg�w przeszk�d % -------%
    for licznik=1:ilosc_stref
        t=kstref(licznik,1); % Przypisywanie numeru stref pod licznik
        delta(t)=r(:,t)^2*(1+a1^2)-(ycentr(:,t)-a1*xcentr(:,t)-b1)^2;%(Wykorzystuje wsp. �rodka okr�gu)
           %---- Warunek --------
        if(delta(t)>0)
            %-------- Je�li trasa jest ze wscodu na zach�d -------------%
            if(and(COURSE(1)>180,COURSE(1)<360))
                xprzecieciaokregu(1,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1+sqrt(delta(t)))/(1+a1^2);
                xprzecieciaokregu(2,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1-sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(1,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)+a1*sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(2,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)-a1*sqrt(delta(t)))/(1+a1^2);
                kstref(licznik,3)=1;%Informacja do macierzy KSTREF o istnieniu przeci��
            else
                %-------- Je�li trasa jest ze zach�d na wsch�d -------------%
                xprzecieciaokregu(2,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1+sqrt(delta(t)))/(1+a1^2);
                xprzecieciaokregu(1,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1-sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(2,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)+a1*sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(1,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)-a1*sqrt(delta(t)))/(1+a1^2);
                kstref(licznik,3)=1;%Informacja do macierzy KSTREF o istnieniu przeci��
            end
        else
            xprzecieciaokregu(1,t)=0;
            xprzecieciaokregu(2,t)=0;
            yprzecieciaokregu(1,t)=0;
            yprzecieciaokregu(2,t)=0;
            kstref(licznik,3)=0;%Informacja do macierzy KSTREF o braku przeci��
        end
    end
    ilosc_stref=numel(nonzeros(kstref(:,3)));
    licznik=1;
    %----------- Etap VII Wyznaczenie trasy suboptymalnej ----------------%
     for i=1:ilosc_stref
             next=licznik+1;
         while(xprzecieciaokregu(1,kstref(licznik,1))==0)
             licznik=licznik+1;
             next=licznik+1;
         end
            if(i<ilosc_stref)
             while(xprzecieciaokregu(1,kstref(next,1))==0)
             next=next+1;
             end
            %--Etap VII. Krok 1 Wczytanie punkt�w przeszkody i punkt�w przewidywa� -------%
            %------  Generowanie omini�� przeszk�d od przeci�cia do przeci�cia okr�gu strefy-------%
            [trax,tray]=intersection(xtrasa(end),ytrasa(end),xprzecieciaokregu(1,kstref(next,1)),yprzecieciaokregu(1,kstref(next,1)),xprzecieciaokregu(1,kstref(licznik,1)),yprzecieciaokregu(1,kstref(licznik,1)),xprzecieciaokregu(2,kstref(licznik,1)),yprzecieciaokregu(2,kstref(licznik,1)),nonzeros(xpunkt(:,kstref(licznik,1))),nonzeros(ypunkt(:,kstref(licznik,1))),lpkt(:,kstref(licznik,1)));
            end
            if(i>=ilosc_stref)
            %------  Generowanie omini�� przeszkody dla ostatniej strefy -------%
            [trax,tray]=intersection(xtrasa(end),ytrasa(end),xcel,ycel,xprzecieciaokregu(1,kstref(licznik,1)),yprzecieciaokregu(1,kstref(licznik,1)),xprzecieciaokregu(2,kstref(licznik,1)),yprzecieciaokregu(2,kstref(licznik,1)),nonzeros(xpunkt(:,kstref(licznik,1))),nonzeros(ypunkt(:,kstref(licznik,1))),lpkt(:,kstref(licznik,1)));
             end
            %--Etap VII. Krok 7 ��czenie trasy omini�cia z dotyczasow� tras� suboptymlan� -------%
            xtrasa=[xtrasa trax]; 
            ytrasa=[ytrasa tray];
            licznik=licznik+1;
     end

    %Informacja konsolowa:
    disp("Znaleziono tras� standardow�");
    %------------- Dodanie do ko�ca trasy punktu celu ------------------%
    xtrasa=[xtrasa xcel];
    ytrasa=[ytrasa ycel];
    for i=1:(numel(xtrasa)-1)
        COURSE(i)=heading(xtrasa(i),xtrasa(i+1),ytrasa(i),ytrasa(i+1));
    end
    %------------- Liczenie d�ugo�ci trasy standardowej ---------------
    iloscpkttrasa1=numel(xtrasa);
    diststand=0;
    for i=1:(iloscpkttrasa1-1)
        diststand=diststand+sqrt((xtrasa(i+1)-xtrasa(i))^2+(ytrasa(i+1)-ytrasa(i))^2); %Wyznaczanie dystansu trasy
    end
    %--------------- Etap VIII - Wyznaczanie trasy optymalnej ------------------%
    %---------------  Wyznaczanie mozliwych skr�t�w -------------%
    rmax=opti(xtrasa,ytrasa,xpunkt,ypunkt,kstref);
    %lpkt=numel(xpunkt(:,1));
    %------ Etap VIII Krok 4 - U�ycie rmax do wyznaczenia optymalnej trasy ------%
    %------ Tworzenie wektor�w trasy optymalnej ------------%
    optx=[];
    opty=[];
    k=1;
    if(max(rmax)>0)
    %-- Przypisywanie do optx, opty punkt�w trasy optymalnej u�ywaj�c rmax --%
        while(k<max(rmax))
            if(or(k==rmax(k),rmax(k)==0)) %zabezpiecznie przed zablokowaniem algorytmu
                rmax(k)=(rmax(k)+1)
                optx(k)=xtrasa(nonzeros(rmax(k)))
                opty(k)=ytrasa(nonzeros(rmax(k)))
                k=nonzeros(rmax(k));
            else 
            optx(k)=xtrasa(nonzeros(rmax(k)));
            opty(k)=ytrasa(nonzeros(rmax(k)));
                k=nonzeros(rmax(k));
            end
            if(k>=max(rmax))
                break;
            end
        end
    %-------------------- Usuwanie podw�jnych zer -----------------------%
    %| Znajdywanie podw�jnych zer wynikaj�cych z dzia�ania algorytmu     |
    %| przydzielaj�cego punkty do wektor�w optx, opty.                   |
    %| nonzeros usuwa te� zera nale�ace do punkt�w trasy                 |
    %|___________________________________________________________________|
        k=1;
        while(k<numel(optx))
        a=numel(optx);
            if(and(optx(k)==0,opty(k)==0))
                %Usuwanie zer z wektor�w trasy optymalnej optx, opty
                optx(k)=[];
                opty(k)=[];
            else
                k=k+1;
            end
            if(k>=a)
                break;
            end

        end
        if(max(rmax)==0)
            optx=[xtrasa];
            opty=[ytrasa];
            disp("Trasa zoptymalizowana i standardowa s� identyczne");
        end
        optx=[xstart optx];
        opty=[ystart opty];
        toc
        plot(optx,opty,'r');
    %------ Liczenie d�ugo�ci trasy optymalizowanej ----------%
        iloscpkttrasa2=numel(optx);
        distopt=0;
        for i=1:(iloscpkttrasa2-1)
            distopt=distopt+sqrt((optx(i+1)-optx(i))^2+(opty(i+1)-opty(i))^2);
        end
        shortdist=sqrt((xcel-xstart)^2+(ycel-ystart)^2);
    %------  Wyznaczanie kursu trasy optymalnej ----------%
   for i=1:(iloscpkttrasa2-1)
        COURSE_OPT(i)=heading(optx(i),optx(i+1),opty(i),opty(i+1));
   end
    %------ Por�wnywanie dystans�w tras  -----------------------%
        if (diststand>distopt)
            disp("Znaleziono tras� zoptymalizowan�");
            disp(['Trasa optymalizowana jest kr�tsza o: ',num2str(diststand-distopt)]);
            disp(['D�ugo�� trasy suboptymalnej to: ',num2str(diststand)]);
             disp(['D�ugo�� trasy zoptymalizowanej to: ',num2str(distopt)]);
        end
        if (distopt>diststand)
            disp("Znaleziono tras� zoptymalizowan�");
            disp("Trasa standardowa jest kr�tsza.");
        end
        if (distopt==diststand)
            disp("Trasy s� r�wne");
        end
    end

else %Je�eli trasa nie ma przeci�cia z okr�giem:
    disp("Nie wykryto przeci�� z okr�gami.");
    ilosc_stref=0;
    xtrasa=[xstart xcel];
    ytrasa=[ystart ycel];
end
%-------
hold off
%############################# EOF #######################################%