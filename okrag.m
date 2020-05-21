function [x1 y1] = okrag( x, y ,r) 
%_________________________________________________________________________%
%|OKRAG Funkcja generuj�ca wsp�rz�dne okr�gu                            |%
%|Nale�y poda� wsp�rz�dne punkt�w �rodka i promie� okr�gu               |%
%|Przyk�ad u�ycia: [x1,y1]=okrag(x_�rodka,y_�rodka,promie�)              |%
%|Skrypt jest cz�ci� pracy dyplomowej na Politechnice Rzeszowskiej KAiS |%
%|                    Damian Szumski 2018                                |%
%|                  damianszumski@yahoo.com                              |%
%|______________________________________________________________________ |%
theta = 0 : 0.01 : 2*pi;
x1 = r * cos(theta) + x;
y1 = r * sin(theta) + y;