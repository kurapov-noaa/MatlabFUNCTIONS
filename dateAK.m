function [date]=dateAK(day,date_ref,tday_ref);

% USAGE:
% [date]=dateAK(day,date_ref,tday_ref);
% e.g.
% [date]=dateAK(139,'Jan-1-2008',1);
% (returns '18-May-2008 00:00:00')


tdays_jc=day-tday_ref+datenum(date_ref);
ymd=datevec(tdays_jc);
date=datestr(ymd,0);

