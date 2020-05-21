%________________________________________________________________%
%|         Program generuj¹cy strefy zakazane do przelotu.      |%
%|   Pozwala on wybraæ miejsce rozpoczêcia startu i koñca lotu  |%
%|  Nastêpnie generuje on trasê omijaj¹c¹ po krawêdziach stref  |%
%|        W nastêpnym kroku generuje on trasê zoptymalizowan¹   |%
%|  Do poprawnego dzia³ania programu nale¿y posiadaæ skrypty:   |%
%|       isconvex.m, polygeom.m, okrag.m, circle_points.m       |%
%|                 heading.m, intersection.m                    |%
%|                oraz baze danych punktów                      |%
%|                    Damian Szumski 2018                       |%
%|                  damianszumski@yahoo.com                     |%
%|______________________________________________________________|%
clear % Czyszczenie zmiennych
clc % Czyszczenie konsoli
%/---- W³asciwoœci wykresu ----/
axis square;
grid on;
axis equal;
hold on
%ylim([49 52]); %Zakres AIRAC
%xlim([19 24]);
 xlim([-20 150]); %Zakresy poligeni i strefy_testowe.m
 ylim([0 150]);
%--------------- Etap I - Wyznaczenie punktu startu i celu --------------%
disp("Zaznacz punkt startu i naciœnij ENTER");
[xstart,ystart] = getpts;              % Wprowadzenie startu przez u¿ytkownika
plot(xstart,ystart,'r*')               % Dodatnie punktu na wykresie plot
if(or(isempty(xstart),isempty(ystart))) 
error("Brak punktu startu!"); %Komunikat b³êdu gdy brak punktu
end
%--------------------------- Wspó³rzêdne celu ---------------------------%
disp("Zaznacz punkt celu i naciœnij ENTER"); %Informacja konsolowa
[xcel,ycel] = getpts;                  % Wprowadzenie celu przez u¿ytkownika
plot(xcel,ycel,'g*')                   % Dodatnie punktu na wykresie plot
if(or(isempty(xcel),isempty(ycel)))
    error("Brak punktu celu!");
end
if(and(xstart==xcel,ystart==ycel))
    error("B³¹d 1 - brak trasy");
end
%------  Informacje konsolowe -------%
clc;
disp("Tworzenie trasy...");
tic %Rozpoczêcie liczeniu czasu
%-------------- Etap II - wyznaczenie prostej miêdzy startem, a celem -------------%
coefficients = polyfit([xstart, xcel], [ystart, ycel], 1);  %Wspó³czynniki prostej kursowej
a1 = coefficients (1);                  % przypisane wspó³cznnika a
b1 = coefficients (2);                  % przypisanie wspó³czynnika b
%-------------- Etap III - Okreœlenie obszaru przeszkuañ "przeszkód"------%
%-------------- Wyznaczenie okrêgu opisanego na prostej start-cel --------%
xpr=(xcel+xstart)/2;                    % Wyznaczenie œrodka okrêgu (X)
ypr=(ycel+ystart)/2;                    % Wyznaczenie œrodka okrêgu (Y)
rpr=sqrt((xcel-xpr)^2+(ycel-ypr)^2);    % Wyznaczneie promienia ko³a
[xkoloa,ykoloa]=okrag(xpr,ypr,rpr);     % Generowanie okregu
plot(xkoloa, ykoloa,'--b');             % Drukowanie okrêgu na p³aszczyŸnie
%-------------- Baza danych przeszkód przszkód ---------------------%
 [xpunkt,ypunkt,xcentr,ycentr,r,xkolo,ykolo,lstref,lpkt]=poligeni; %ród³o
% losowych przeszkód
%strefy_testowe; %ród³o sztucznych przeszkód
%data_AIRAC; %ród³o przeszkód cyklu AIRAC
%---- Wyznaczanie iloœci stref ----%
lstref=numel(xpunkt(1,:));
%-------------- Etap III-2 Opisanie okrêgu na poligonach -----------%
for i=1:lstref
    [xcentr(:,i),ycentr(:,i),r(i),xkolo(:,i),ykolo(:,i)]=circle_points(nonzeros(xpunkt(:,i)),nonzeros(ypunkt(:,i)));
    lpkt(:,i)=numel(nonzeros(xpunkt(:,i)))-1;%Zera wystêpuj¹ gdy strefa ma mniej punktów
end
kstref=[]; %Tworzenie wektora zawieraj¹cego numery stref oraz odle³oœci od œrodka
for t=1:lstref
%---------- Etap IV Okreœlenie przeszkód w zasiêgu -----------------%
    in(:,t) = inpolygon(xkolo(:,t),ykolo(:,t),xkoloa,ykoloa);
%- Etap V Przypisanie odleg³oœci i numerów stref w zasiêgu do macierzy kstref -%
    if(any(in(:,t))==1)
        kstref=[kstref [t;(sqrt((xcentr(:,t)-xstart)^2+(ycentr(:,t)-ystart)^2))]];
        plot(nonzeros(xpunkt(:,t)),nonzeros(ypunkt(:,t)), 'x-');%Generowanie punktów w uk³adzie
    end
end
clear in;                               % Czyszczenie zbêdnych zmiennych
if ~isempty(kstref)                     % jeœli trasa przelatuje przez strefy:
    ilosc_stref=numel(kstref(1,:));     % Tworzenie zmiennej zawieraj¹c¹ iloœc stref znajduj¹cych siê w obrêbie okrêgu
    kstref=sortrows(kstref',2,'ascend');%Sortowanie stref kolejnoœci¹ przelotu
    xtrasa=[xstart];                    % Dodanie punktu startu jako pierwszy punkt trasy
    ytrasa=[ystart];
    COURSE=[heading(xstart,xcel,ystart,ycel)]; % Generowanie kursów trasy
%- Etap VI Wyznaczneie przeszkód kolizyjnych poprzez wyznaczenie punktów przeciêc prostej start-cel i okregów przeszkód % -------%
    for licznik=1:ilosc_stref
        t=kstref(licznik,1); % Przypisywanie numeru stref pod licznik
        delta(t)=r(:,t)^2*(1+a1^2)-(ycentr(:,t)-a1*xcentr(:,t)-b1)^2;%(Wykorzystuje wsp. œrodka okrêgu)
           %---- Warunek --------
        if(delta(t)>0)
            %-------- Jeœli trasa jest ze wscodu na zachód -------------%
            if(and(COURSE(1)>180,COURSE(1)<360))
                xprzecieciaokregu(1,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1+sqrt(delta(t)))/(1+a1^2);
                xprzecieciaokregu(2,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1-sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(1,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)+a1*sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(2,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)-a1*sqrt(delta(t)))/(1+a1^2);
                kstref(licznik,3)=1;%Informacja do macierzy KSTREF o istnieniu przeciêæ
            else
                %-------- Jeœli trasa jest ze zachód na wschód -------------%
                xprzecieciaokregu(2,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1+sqrt(delta(t)))/(1+a1^2);
                xprzecieciaokregu(1,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1-sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(2,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)+a1*sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(1,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)-a1*sqrt(delta(t)))/(1+a1^2);
                kstref(licznik,3)=1;%Informacja do macierzy KSTREF o istnieniu przeciêæ
            end
        else
            xprzecieciaokregu(1,t)=0;
            xprzecieciaokregu(2,t)=0;
            yprzecieciaokregu(1,t)=0;
            yprzecieciaokregu(2,t)=0;
            kstref(licznik,3)=0;%Informacja do macierzy KSTREF o braku przeciêæ
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
            %--Etap VII. Krok 1 Wczytanie punktów przeszkody i punktów przewidywañ -------%
            %------  Generowanie ominiêæ przeszkód od przeciêcia do przeciêcia okrêgu strefy-------%
            [trax,tray]=intersection(xtrasa(end),ytrasa(end),xprzecieciaokregu(1,kstref(next,1)),yprzecieciaokregu(1,kstref(next,1)),xprzecieciaokregu(1,kstref(licznik,1)),yprzecieciaokregu(1,kstref(licznik,1)),xprzecieciaokregu(2,kstref(licznik,1)),yprzecieciaokregu(2,kstref(licznik,1)),nonzeros(xpunkt(:,kstref(licznik,1))),nonzeros(ypunkt(:,kstref(licznik,1))),lpkt(:,kstref(licznik,1)));
            end
            if(i>=ilosc_stref)
            %------  Generowanie ominiêæ przeszkody dla ostatniej strefy -------%
            [trax,tray]=intersection(xtrasa(end),ytrasa(end),xcel,ycel,xprzecieciaokregu(1,kstref(licznik,1)),yprzecieciaokregu(1,kstref(licznik,1)),xprzecieciaokregu(2,kstref(licznik,1)),yprzecieciaokregu(2,kstref(licznik,1)),nonzeros(xpunkt(:,kstref(licznik,1))),nonzeros(ypunkt(:,kstref(licznik,1))),lpkt(:,kstref(licznik,1)));
             end
            %--Etap VII. Krok 7 £¹czenie trasy ominiêcia z dotyczasow¹ tras¹ suboptymlan¹ -------%
            xtrasa=[xtrasa trax]; 
            ytrasa=[ytrasa tray];
            licznik=licznik+1;
     end

    %Informacja konsolowa:
    disp("Znaleziono trasê standardow¹");
    %------------- Dodanie do koñca trasy punktu celu ------------------%
    xtrasa=[xtrasa xcel];
    ytrasa=[ytrasa ycel];
    for i=1:(numel(xtrasa)-1)
        COURSE(i)=heading(xtrasa(i),xtrasa(i+1),ytrasa(i),ytrasa(i+1));
    end
    %------------- Liczenie d³ugoœci trasy standardowej ---------------
    iloscpkttrasa1=numel(xtrasa);
    diststand=0;
    for i=1:(iloscpkttrasa1-1)
        diststand=diststand+sqrt((xtrasa(i+1)-xtrasa(i))^2+(ytrasa(i+1)-ytrasa(i))^2); %Wyznaczanie dystansu trasy
    end
    %--------------- Etap VIII - Wyznaczanie trasy optymalnej ------------------%
    %---------------  Wyznaczanie mozliwych skrótów -------------%
    rmax=opti(xtrasa,ytrasa,xpunkt,ypunkt,kstref);
    %lpkt=numel(xpunkt(:,1));
    %------ Etap VIII Krok 4 - U¿ycie rmax do wyznaczenia optymalnej trasy ------%
    %------ Tworzenie wektorów trasy optymalnej ------------%
    optx=[];
    opty=[];
    k=1;
    if(max(rmax)>0)
    %-- Przypisywanie do optx, opty punktów trasy optymalnej u¿ywaj¹c rmax --%
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
    %-------------------- Usuwanie podwójnych zer -----------------------%
    %| Znajdywanie podwójnych zer wynikaj¹cych z dzia³ania algorytmu     |
    %| przydzielaj¹cego punkty do wektorów optx, opty.                   |
    %| nonzeros usuwa te¿ zera nale¿ace do punktów trasy                 |
    %|___________________________________________________________________|
        k=1;
        while(k<numel(optx))
        a=numel(optx);
            if(and(optx(k)==0,opty(k)==0))
                %Usuwanie zer z wektorów trasy optymalnej optx, opty
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
            disp("Trasa zoptymalizowana i standardowa s¹ identyczne");
        end
        optx=[xstart optx];
        opty=[ystart opty];
        toc
        plot(optx,opty,'r');
    %------ Liczenie d³ugoœci trasy optymalizowanej ----------%
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
    %------ Porównywanie dystansów tras  -----------------------%
        if (diststand>distopt)
            disp("Znaleziono trasê zoptymalizowan¹");
            disp(['Trasa optymalizowana jest krótsza o: ',num2str(diststand-distopt)]);
            disp(['D³ugoœæ trasy suboptymalnej to: ',num2str(diststand)]);
             disp(['D³ugoœæ trasy zoptymalizowanej to: ',num2str(distopt)]);
        end
        if (distopt>diststand)
            disp("Znaleziono trasê zoptymalizowan¹");
            disp("Trasa standardowa jest krótsza.");
        end
        if (distopt==diststand)
            disp("Trasy s¹ równe");
        end
    end

else %Je¿eli trasa nie ma przeciêcia z okrêgiem:
    disp("Nie wykryto przeciêæ z okrêgami.");
    ilosc_stref=0;
    xtrasa=[xstart xcel];
    ytrasa=[ystart ycel];
end
%-------
hold off
%############################# EOF #######################################%