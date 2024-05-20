function [date_out]=lastOfThisMonth(date_in)

% [date_out]=firstOfNextMonth(date_in)
% date_in can be any date, date_out will be the 1st date of the next month
date_out=datestr(datenum(firstOfNextMonth(date_in))-1);
