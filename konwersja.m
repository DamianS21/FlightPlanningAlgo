function [x,y]=konwersja(data)
x=dms2degrees(data);
for i=1:numel(x)
if(rem(i,2)==0)
y(i-1)=x(i);
end
end
y=nonzeros(y);
x(2:2:end) = [];
x(end+1)=x(1);
y(end+1)=y(1);