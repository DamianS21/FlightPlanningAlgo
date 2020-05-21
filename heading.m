function [CRS] = heading(trasax1,trasax2,trasay1,trasay2);
%_________________________________________________________________________%
%|Funkcja generuj¹ca wskazania kursowe po podaniu odcinka                |%
%|Nale¿y podaæ wspó³rzêdne punktów odcinka do wzynacznia                 |%
%|wskazania kursowego.                                                   |%
%|Przyk³ad u¿ycia:                                                       |%
%|KURS=heading(wsp_x_poczatku, wsp_x_konca, wsp_y_poczatku, wsp_y_konca);|%
%|Skrypt jest czêœci¹ pracy dyplomowej na Politechnice Rzeszowskiej KAiS |%
%|                    Damian Szumski 2018                                |%
%|                  damianszumski@yahoo.com                              |%
%|______________________________________________________________________ |%
%------------------ Etap 1. Wyznaczanie wspó³czynnika a prostej
CRS=rad2deg(atan2((trasax2-trasax1),(trasay2-trasay1)));
if(CRS<0)
    CRS=CRS+360;
end