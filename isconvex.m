function [znak]=isconvex(xp,yp,limit)
%ISCONVEX Funkcja sprawdzaj�c� wypuk�o�� figury po podaniu punkt�w tej
%figury oraz jej ilo�ci. Funkcja zwraca znaki. Je�eli kt�ry� z nich jest
%mniejszy ni� zero figura nie jest wypuk�a.
% Nale�y poda� wsp�rz�dne punkt�w figury oraz ilo��
% Przyk�ad u�ycia: znak=iswypuke(wsp_x_figury, wsp_y_figury, ilosc_pkt);
% (C) Damian Szumski 2018
% �r�d�o: https://matlabgeeks.com/tips-tutorials/computational-geometry/check-convexity-of-polygon/
xd=xp(1:end-1);
yd=yp(1:end-1);
v1 = [xd(1) - xd(end), yd(1) - yd(end)];
v2 = [xd(2) - xd(1), yd(2) - yd(1)];
znak(1) = sign(det([v1; v2]));
for k = 2:limit-1
        v1 = v2;
        v2 = [xd(k+1) - xd(k), yd(k+1) - yd(k)];
        znak(k) = sign(det([v1; v2]));
    end
    v1 = v2;
    v2 = [xd(1) - xd(end), yd(1) - yd(end)];
    znak(limit) = sign(det([v1; v2]));
    if(znak(limit)<=0)
    end
end