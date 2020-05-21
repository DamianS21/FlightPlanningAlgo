function [rmax] = opti(xtrasa,ytrasa,xpunkt,ypunkt,kstref) 
j=1;
for k=1:numel(xtrasa)
        rmax(k)=[0];%Tworzenie wektora przeskok�w pomi�dzy punktami
        for r=k:numel(xtrasa)
            flag=0; %Zerowanie flagi wyzwalaj�cej pozytywny wynik po��czenia
            %Je�eli flaga jest pozytywna po��czenie xodc, yodc mo�e by� zrealizowane 
            %---- Etap VIII Krok 1 Generowanie sprawdzanego odcinkia -----%
            xodc=[xtrasa(k) xtrasa(r)]; %Tworzenie wektora po��czenia (X)
            yodc=[ytrasa(k) ytrasa(r)]; %Tworzenie wektora po��czenia (Y)
            F2x=0;
            F3x=0;
            clear F1x;
            nprzeciec(j)=0; %Zerowanie wektora ilo�ci przeci��
            for j=1:numel(kstref(:,1))
                %- Etap VIII Krok 2 Wyznaczanie przeci�� odcinka z aktualnie sprawdzan� stref� i generowanie macierzy F1x w przypadku braku -%
                [xtemp,ytemp] = polyxpoly(xodc,yodc,nonzeros(xpunkt(:,kstref(j,1))'),nonzeros(ypunkt(:,kstref(j,1))')); % Wyznaczanie przeci�� ze stref�
                F1x(j)=isempty(xtemp);
                nprzeciec(j)=numel(unique(xtemp));
                %--- Etap 5.1.2. - Sprawdzanie warunk�w podnosz�cych flagi o poprawno�ci przeci�cia-----%
                %Flaga typu 1) Je�eli nie ma przeci��
                if(and(~min(F1x)==0,j==numel(kstref(:,1)))) 
                    flag=1;
%                     disp("F1");

                    break;
                end
                %Flaga typu 2) Je�eli jest jedno przeci�cie r�wne drugiemu punktowi
                if(and(numel(unique(xtemp))==1,or(and(xtemp==xodc(1),ytemp==yodc(1)),and(xtemp==xodc(2),ytemp==yodc(2)))))
                    F2x(j)=1;
%                     disp("F2");
                end
                if(and(max(F2x)==1,j==numel(kstref(:,1))))
                    if(sum(F1x)==(numel(kstref(:,1))-1)) %je�li jest przeci�cie tylko z jedn� stref�
                        flag=1;
%                         k
%                         r
%                         disp("FLAGA2.1");
                        break;
                    end
                end
                if(and(max(F2x)==1,j==numel(kstref(:,1))))
                    if(sum(F1x)==(numel(kstref(:,1))-2)) %je�li s� dwie strefy przeci�te
                        if(sum(nprzeciec)==2)
                            flag=1;
%                             k
%                             r
%                             disp("FLAGA2.2");
                            break;
                        end
                    end
                end
                %Flaga typu 3) Je�eli s� dwa przeci�cia r�wne kolejnym punktom
                if(numel(unique(xtemp.','rows'))>=2)
                    if(r-k==1)
                        if(or(and(xtemp(1)==xodc(1),xtemp(2)==xodc(2)),and(xtemp(2)==xodc(1),xtemp(1)==xodc(2))))
                            if(or(and(ytemp(1)==yodc(1),ytemp(2)==yodc(2)),and(ytemp(2)==yodc(1),ytemp(1)==yodc(2))))
                                F3x(j)=1;
%                                 disp("FLAGA3");
%                                 k
%                                 r
                            end                           
                        end
                    end
                end
                if(and(max(F3x)==1,j==numel(kstref(:,1))))
                    if(sum(F1x)==(numel(kstref(:,1))-1))
                        flag=1;
%                         disp("F3");
                        break;
                    end
                end
            end
            %---- Etap VIII Krok 3 Dodanie do macierzy rmax punkt�w wzgl�dem kt�rych mo�na stworozy� przeskok -----%
            if(flag==1)
                if(r>rmax(k))
                    rmax(k)=[r];
                end
            end
            
        end
    end