function [trasax,trasay] = intersection(xbef,ybef,xaft,yaft, xstart, ystart,xcel,ycel,xp,yp,limit) 
%__________________________________________________________________%
%|Script generates route avoiding obstacle along zone edges     |%
%|Must provide start point x, y and destination points x,y      |%
%|        obstacle points x,y, number of obstacle points.      |%
%|                    Damian Szumski 2018                       |%
%|                  damianszumski@yahoo.com                     |%
%|________________________________________________________________|%
%--------------- Stage VII Step 2 Convexify obstacle --------------%
znak=isconvex(xp,yp,limit);
if(any(znak(:)<0))
    j = boundary(xp,yp,0);
     plot(xp(j),yp(j)); %Draw figure outline
    xp=(xp(j))';
    yp=(yp(j))';
end
clear j
%-------- Locate intersection points with obstacle ---------------%
xt=[xstart xcel];
yt=[ystart ycel];
[xi,yi] = polyxpoly(xt,yt,xp,yp);
%--- Set intersection matrix according to flight direction ----%
if(~isempty(xi))%Check if there are intersections with figure.
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
    
%- Stage 4. Select point numbers falling first in zone flight-%
%-------  Create distance matrix between points -----------%
    limit_zredukowany=numel(xp)-1;
    for i=1:limit_zredukowany
        dist(i)=sqrt((xp(i+1)-xp(i))^2+(yp(i+1)-yp(i))^2);%Distance between points
    end
%------------ Locate entry intersection point ---------------%
    for i=1:(limit_zredukowany)
        pdist(i)=sqrt((xp(i)-xprzeciecia(1))^2+(yp(i)-yprzeciecia(1))^2); %Distance between intersection point and each point
    end
    for i=1:(limit_zredukowany)
        if(i<limit_zredukowany)
            sumap1(i)=pdist(i)+pdist(i+1);%Sum of consecutive distances between intersection point and each point
        end
        if(i==limit_zredukowany)
            sumap1(i)=pdist(i)+pdist(1);
        end
        roznica(i)=abs(sumap1(i)-dist(i));
    end
    [temp, pkt1]=min(roznica);
%------------ Locate exit intersection point ---------------%
    %--- Clear auxiliary variables ---
    %
    for i=1:(limit_zredukowany)
        pdist(i)=sqrt((xp(i)-xprzeciecia(2))^2+(yp(i)-yprzeciecia(2))^2); %Distance between intersection point and each point
    end
    for i=1:(limit_zredukowany)
        if(i<limit_zredukowany)
            sumap2(i)=pdist(i)+pdist(i+1);%Sum of consecutive distances between intersection point and each point
        end
        if(i==limit_zredukowany)
            sumap2(i)=pdist(i)+pdist(1);
        end
        roznica(i)=abs(sumap2(i)-dist(i));
    end
    
    [temp, pkt2]=min(roznica);
%------------- Stage VII Step 4 Determine route 1 obstacle avoidance ---------------------%
%-------------  Determine number of route 1 points------%
    if(pkt2<(pkt1+1))%If point is beyond end of array 
        iloscpkttrasa1=(limit_zredukowany-(pkt1+1))+pkt2 +1;%Number of elements in reduced array (without last) - entry point position + exit point position -1(subtract itself)
    else
        iloscpkttrasa1=abs((pkt2-(pkt1+1))+1);
    end
%------------- Generate X coordinates for route 1-----%
 trasax=[xbef];%Add prediction point 1 X coordinate
    o=pkt1+1;
    for i=1:(iloscpkttrasa1)
        if(o>limit_zredukowany)
            o=1;
        end
        trasax=[trasax xp(o)];
        o=o+1; 
    end
     trasax=[trasax xaft];%Add prediction point 2 X coordinate
%------------- Generate Y coordinates for route 1 -----%
 trasay=[ybef]; %Add prediction point 1 Y coordinate
    o=pkt1+1;
    for i=1:(iloscpkttrasa1)
        if(o>limit_zredukowany)
            o=1;
        end
        trasay=[trasay yp(o)];
        o=o+1;
    end
     trasay=[trasay yaft]; %Add prediction point 2 Y coordinate
%------------- Stage VII Step 5 Determine route 2 obstacle avoidance ---------------------%
%------------- Determine number of route 2 points ------%
    iloscpkttrasa2=limit_zredukowany-iloscpkttrasa1;
    if(iloscpkttrasa2<0)
        iloscpkttrasa2=0;
    end
%------------- Generate X coordinates for route 2 -----%
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
%-------------  Generate Y coordinates for route 2 -----%
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
    
%- Stage VII Step 6 Determine route lengths and select shorter route ------%
%------------- Determine route 1 length --------------------%
   iloscpkttrasa1=numel(trasax);
   dist1=0;
   for i=1:(iloscpkttrasa1-1)
       dist1=dist1+sqrt((trasax(i+1)-trasax(i))^2+(trasay(i+1)-trasay(i))^2);
   end
%         plot(trasax,trasay,'-mo','LineWidth',2);
%------------- Determine route 2 length --------------------%
   iloscpkttrasa2=numel(trasax2);
   dist2=0;
   for i=1:(iloscpkttrasa2-1)
       dist2=dist2+sqrt((trasax2(i+1)-trasax2(i))^2+(trasay2(i+1)-trasay2(i))^2);
   end
%------------- \ Decision which route is shorter  ---------------%
   if(dist1<dist2)
        clear trasax2 trasay2;
   end
   if(dist2<dist1)
       trasax=trasax2;
       trasay=trasay2;
   end   
%- Stage VII Step 7 Remove first and last point from obstacle avoidance route ------%
trasax(1)=[];
trasax(end)=[];
trasay(1)=[];
trasay(end)=[];
iloscpkttrasa1=numel(trasax);




end
if(isempty(xi))%If no intersections with figure
    trasax=[xstart xcel];
    trasay=[ystart ycel];
end
end