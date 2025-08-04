function [x1 y1] = okrag( x, y ,r) 
%_________________________________________________________________________%
%|OKRAG Function generating circle coordinates                          |%
%|Must provide center point coordinates and circle radius              |%
%|Usage example: [x1,y1]=okrag(center_x,center_y,radius)               |%
%|Script is part of diploma thesis at Rzeszow University of Technology |%
%|                    Damian Szumski 2018                               |%
%|                  damianszumski@yahoo.com                             |%
%|______________________________________________________________________ |%
theta = 0 : 0.01 : 2*pi;
x1 = r * cos(theta) + x;
y1 = r * sin(theta) + y;