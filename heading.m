function [CRS] = heading(trasax1,trasax2,trasay1,trasay2);
%_________________________________________________________________________%
%|Function generating heading indications by providing segment           |%
%|Must provide coordinates of segment points to determine               |%
%|heading indication.                                                   |%
%|Usage example:                                                        |%
%|COURSE=heading(x_start_coord, x_end_coord, y_start_coord, y_end_coord);|%
%|Script is part of diploma thesis at Rzeszow University of Technology  |%
%|                    Damian Szumski 2018                               |%
%|                  damianszumski@yahoo.com                             |%
%|______________________________________________________________________ |%
%------------------ Stage 1. Determine coefficient a of line
CRS=rad2deg(atan2((trasax2-trasax1),(trasay2-trasay1)));
if(CRS<0)
    CRS=CRS+360;
end