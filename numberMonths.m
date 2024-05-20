function [nmo]=numberMonths(date1,date2)

% number of months between the two dates (including the first and last
% months)
v1=datevec(date1);
v2=datevec(date2);

y1=v1(1);
m1=v1(2);

y2=v2(1);
m2=v2(2);

if y1==y2
 nmo=m2-m1+1;
else
 nmo=13-m1+...
     (y2-y1-1)*12+...
     m2;
end
