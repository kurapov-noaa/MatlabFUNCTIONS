function [date_out]=firstOfNextMonth(date_in)

% [date_out]=firstOfNextMonth(date_in)
% date_in can be any date, date_out will be the 1st date of the next month
dv=datevec(date_in);
dv(:,3)=1;               % change the day of the input date to the 1st
d=datenum(dv)+45;      % move to the middle of the next month
dv=datevec(d);
dv(:,3)=1;               % change the day of the next month date to the 1st
date_out=datestr(dv);  % output

