function [date_out]=firstOfThisMonth(date_in)

% [date_out]=firstOfNextMonth(date_in)
% date_in can be any date, date_out will be the 1st date of the same month
%
% 5-12-2021: extend to v=arrays where each row is a date string

dv=datevec(date_in);
dv(:,3)=1;
date_out=datestr(dv);
