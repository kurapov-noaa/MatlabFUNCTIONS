function [day]=yeardayAK(date,date_ref,day_ref);

%
% USAGE: 
% day=yeardayAK(date,date_ref,day_ref);
%

day=datenum(date)-datenum(date_ref)+day_ref;
