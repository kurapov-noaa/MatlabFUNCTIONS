function [fnum1,fnum2]=get_fnum(filehead);

% USAGE:
% [fnum1,fnum2]=get_fnum(filehead);
%

a=evalc(['ls -l ' filehead '*.nc']);
in=findstr(a,'.nc');
fnum1=a(in(1)-4:in(1)-1);
fnum2=a(in(end)-4:in(end)-1);

fnum1=str2num(fnum1);
fnum2=str2num(fnum2);
