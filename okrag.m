function [x1 y1] = okrag( x, y ,r) 
%_________________________________________________________________________%
%|OKRAG Funkcja generuj¹ca wspó³rzêdne okrêgu                            |%
%|Nale¿y podaæ wspó³rzêdne punktów œrodka i promieñ okrêgu               |%
%|Przyk³ad u¿ycia: [x1,y1]=okrag(x_œrodka,y_œrodka,promieñ)              |%
%|Skrypt jest czêœci¹ pracy dyplomowej na Politechnice Rzeszowskiej KAiS |%
%|                    Damian Szumski 2018                                |%
%|                  damianszumski@yahoo.com                              |%
%|______________________________________________________________________ |%
theta = 0 : 0.01 : 2*pi;
x1 = r * cos(theta) + x;
y1 = r * sin(theta) + y;