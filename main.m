%________________________________________________________________%
%|         Program generating restricted flight zones.         |%
%|   Allows selecting start and destination flight points      |%
%|  Then generates route avoiding zone edges                   |%
%|        Next step generates optimized route                  |%
%|  For correct program operation, the following scripts       |%
%|  are required: isconvex.m, polygeom.m, okrag.m,           |%
%|       circle_points.m, heading.m, intersection.m           |%
%|                and points database                          |%
%|                    Damian Szumski 2018                      |%
%|                  damianszumski@yahoo.com                    |%
%|______________________________________________________________|%
clear % Clear variables
clc % Clear console
%/---- Chart properties ----/
axis square;
grid on;
axis equal;
hold on
%ylim([49 52]); %AIRAC range
%xlim([19 24]);
 xlim([-20 150]); %Ranges for poligeni and strefy_testowe.m
 ylim([0 150]);
%--------------- Stage I - Determining start and destination points --------------%
disp("Mark start point and press ENTER");
[xstart,ystart] = getpts;              % User input for start point
plot(xstart,ystart,'r*')               % Add point to plot
if(or(isempty(xstart),isempty(ystart))) 
error("Missing start point!"); %Error message when no point
end
%--------------------------- Destination coordinates ---------------------------%
disp("Mark destination point and press ENTER"); %Console information
[xcel,ycel] = getpts;                  % User input for destination
plot(xcel,ycel,'g*')                   % Add point to plot
if(or(isempty(xcel),isempty(ycel)))
    error("Missing destination point!");
end
if(and(xstart==xcel,ystart==ycel))
    error("Error 1 - no route");
end
%------  Console information -------%
clc;
disp("Creating route...");
tic %Start timing
%-------------- Stage II - determining line between start and destination -------------%
coefficients = polyfit([xstart, xcel], [ystart, ycel], 1);  %Direct route line coefficients
a1 = coefficients (1);                  % assign coefficient a
b1 = coefficients (2);                  % assign coefficient b
%-------------- Stage III - Define obstacle area "obstacles"------%
%-------------- Determine circle inscribed on start-destination line --------%
xpr=(xcel+xstart)/2;                    % Determine circle center (X)
ypr=(ycel+ystart)/2;                    % Determine circle center (Y)
rpr=sqrt((xcel-xpr)^2+(ycel-ypr)^2);    % Determine circle radius
[xkoloa,ykoloa]=okrag(xpr,ypr,rpr);     % Generate circle
plot(xkoloa, ykoloa,'--b');             % Draw circle on plane
%-------------- Obstacle database ---------------------%
 [xpunkt,ypunkt,xcentr,ycentr,r,xkolo,ykolo,lstref,lpkt]=poligeni; %Source of
% random obstacles
%strefy_testowe; %Source of artificial obstacles
%data_AIRAC; %Source of AIRAC cycle obstacles
%---- Determining number of zones ----%
lstref=numel(xpunkt(1,:));
%-------------- Stage III-2 Describe circles on polygons -----------%
for i=1:lstref
    [xcentr(:,i),ycentr(:,i),r(i),xkolo(:,i),ykolo(:,i)]=circle_points(nonzeros(xpunkt(:,i)),nonzeros(ypunkt(:,i)));
    lpkt(:,i)=numel(nonzeros(xpunkt(:,i)))-1;%Zeros occur when zone has fewer points
end
kstref=[]; %Create vector containing zone numbers and distances from center
for t=1:lstref
%---------- Stage IV Determine obstacles in range -----------------%
    in(:,t) = inpolygon(xkolo(:,t),ykolo(:,t),xkoloa,ykoloa);
%- Stage V Assign distances and zone numbers in range to kstref matrix -%
    if(any(in(:,t))==1)
        kstref=[kstref [t;(sqrt((xcentr(:,t)-xstart)^2+(ycentr(:,t)-ystart)^2))]];
        plot(nonzeros(xpunkt(:,t)),nonzeros(ypunkt(:,t)), 'x-');%Generate points in system
    end
end
clear in;                               % Clear unnecessary variables
if ~isempty(kstref)                     % if route passes through zones:
    ilosc_stref=numel(kstref(1,:));     % Create variable containing number of zones within circle
    kstref=sortrows(kstref',2,'ascend');%Sort zones in flight order
    xtrasa=[xstart];                    % Add start point as first route point
    ytrasa=[ystart];
    COURSE=[heading(xstart,xcel,ystart,ycel)]; % Generate route headings
%- Stage VI Determine collision obstacles by finding intersection points of start-destination line and obstacle circles % -------%
    for licznik=1:ilosc_stref
        t=kstref(licznik,1); % Assign zone numbers to counter
        delta(t)=r(:,t)^2*(1+a1^2)-(ycentr(:,t)-a1*xcentr(:,t)-b1)^2;%(Uses circle center coordinates)
           %---- Condition --------
        if(delta(t)>0)
            %-------- If route is east to west -------------%
            if(and(COURSE(1)>180,COURSE(1)<360))
                xprzecieciaokregu(1,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1+sqrt(delta(t)))/(1+a1^2);
                xprzecieciaokregu(2,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1-sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(1,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)+a1*sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(2,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)-a1*sqrt(delta(t)))/(1+a1^2);
                kstref(licznik,3)=1;%Information to KSTREF matrix about intersection existence
            else
                %-------- If route is west to east -------------%
                xprzecieciaokregu(2,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1+sqrt(delta(t)))/(1+a1^2);
                xprzecieciaokregu(1,t)=((xcentr(:,t)+ycentr(:,t)*a1)-b1*a1-sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(2,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)+a1*sqrt(delta(t)))/(1+a1^2);
                yprzecieciaokregu(1,t)=(b1+(xcentr(:,t)*a1)+(ycentr(:,t)*a1^2)-a1*sqrt(delta(t)))/(1+a1^2);
                kstref(licznik,3)=1;%Information to KSTREF matrix about intersection existence
            end
        else
            xprzecieciaokregu(1,t)=0;
            xprzecieciaokregu(2,t)=0;
            yprzecieciaokregu(1,t)=0;
            yprzecieciaokregu(2,t)=0;
            kstref(licznik,3)=0;%Information to KSTREF matrix about no intersection
        end
    end
    ilosc_stref=numel(nonzeros(kstref(:,3)));
    licznik=1;
    %----------- Stage VII Determine suboptimal route ----------------%
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
            %--Stage VII. Step 1 Load obstacle points and prediction points -------%
            %------  Generate obstacle avoidance from intersection to zone circle intersection-------%
            [trax,tray]=intersection(xtrasa(end),ytrasa(end),xprzecieciaokregu(1,kstref(next,1)),yprzecieciaokregu(1,kstref(next,1)),xprzecieciaokregu(1,kstref(licznik,1)),yprzecieciaokregu(1,kstref(licznik,1)),xprzecieciaokregu(2,kstref(licznik,1)),yprzecieciaokregu(2,kstref(licznik,1)),nonzeros(xpunkt(:,kstref(licznik,1))),nonzeros(ypunkt(:,kstref(licznik,1))),lpkt(:,kstref(licznik,1)));
            end
            if(i>=ilosc_stref)
            %------  Generate obstacle avoidance for last zone -------%
            [trax,tray]=intersection(xtrasa(end),ytrasa(end),xcel,ycel,xprzecieciaokregu(1,kstref(licznik,1)),yprzecieciaokregu(1,kstref(licznik,1)),xprzecieciaokregu(2,kstref(licznik,1)),yprzecieciaokregu(2,kstref(licznik,1)),nonzeros(xpunkt(:,kstref(licznik,1))),nonzeros(ypunkt(:,kstref(licznik,1))),lpkt(:,kstref(licznik,1)));
             end
            %--Stage VII. Step 7 Connect avoidance route with current suboptimal route -------%
            xtrasa=[xtrasa trax]; 
            ytrasa=[ytrasa tray];
            licznik=licznik+1;
     end

    %Console information:
    disp("Found standard route");
    %------------- Add destination point to end of route ------------------%
    xtrasa=[xtrasa xcel];
    ytrasa=[ytrasa ycel];
    for i=1:(numel(xtrasa)-1)
        COURSE(i)=heading(xtrasa(i),xtrasa(i+1),ytrasa(i),ytrasa(i+1));
    end
    %------------- Calculate standard route length ---------------
    iloscpkttrasa1=numel(xtrasa);
    diststand=0;
    for i=1:(iloscpkttrasa1-1)
        diststand=diststand+sqrt((xtrasa(i+1)-xtrasa(i))^2+(ytrasa(i+1)-ytrasa(i))^2); %Calculate route distance
    end
    %--------------- Stage VIII - Determine optimal route ------------------%
    %---------------  Determine possible shortcuts -------------%
    rmax=opti(xtrasa,ytrasa,xpunkt,ypunkt,kstref);
    %lpkt=numel(xpunkt(:,1));
    %------ Stage VIII Step 4 - Use rmax to determine optimal route ------%
    %------ Create optimal route vectors ------------%
    optx=[];
    opty=[];
    k=1;
    if(max(rmax)>0)
    %-- Assign to optx, opty optimal route points using rmax --%
        while(k<max(rmax))
            if(or(k==rmax(k),rmax(k)==0)) %protection against algorithm blocking
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
    %-------------------- Remove double zeros -----------------------%
    %| Finding double zeros resulting from algorithm operation       |
    %| assigning points to optx, opty vectors.                      |
    %| nonzeros also removes zeros belonging to route points        |
    %|_______________________________________________________________|
        k=1;
        while(k<numel(optx))
        a=numel(optx);
            if(and(optx(k)==0,opty(k)==0))
                %Remove zeros from optimal route vectors optx, opty
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
            disp("Optimized and standard routes are identical");
        end
        optx=[xstart optx];
        opty=[ystart opty];
        toc
        plot(optx,opty,'r');
    %------ Calculate optimized route length ----------%
        iloscpkttrasa2=numel(optx);
        distopt=0;
        for i=1:(iloscpkttrasa2-1)
            distopt=distopt+sqrt((optx(i+1)-optx(i))^2+(opty(i+1)-opty(i))^2);
        end
        shortdist=sqrt((xcel-xstart)^2+(ycel-ystart)^2);
    %------  Determine optimal route heading ----------%
   for i=1:(iloscpkttrasa2-1)
        COURSE_OPT(i)=heading(optx(i),optx(i+1),opty(i),opty(i+1));
   end
    %------ Compare route distances  -----------------------%
        if (diststand>distopt)
            disp("Found optimized route");
            disp(['Optimized route is shorter by: ',num2str(diststand-distopt)]);
            disp(['Suboptimal route length: ',num2str(diststand)]);
             disp(['Optimized route length: ',num2str(distopt)]);
        end
        if (distopt>diststand)
            disp("Found optimized route");
            disp("Standard route is shorter.");
        end
        if (distopt==diststand)
            disp("Routes are equal");
        end
    end

else %If route has no intersection with circle:
    disp("No intersections with circles detected.");
    ilosc_stref=0;
    xtrasa=[xstart xcel];
    ytrasa=[ystart ycel];
end
%-------
hold off
%############################# EOF #######################################%