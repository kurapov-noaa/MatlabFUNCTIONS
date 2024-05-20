function [iW,iE]=cutout_lon_indices(lon_global,lonLims)

% If lonLims within the limits of lon_global (without crossing the 0 or
% "date change" line) then iW=[], iE 
% lonLims such that the westmost edge of lon_global is inside the
% subdomain, the total continuous set is [iW iE]

% default lon convention: 0..360
lonSTR=0;
lonEND=360;

if any(lon_global<0)
 lonSTR=-180;
 lonEND=180;
end

if (lon_global(end)-lon_global(1)==360)
 lon_global=lon_global(1:end-1);
end

% Make sure lonLims are within the limits of the global set:
if lonSTR==0
 lonLims(lonLims<0)=lonLims(lonLims<0)+360;   
elseif lonSTR==-180
 lonLims(lonLims>180)=lonLims(lonLims>180)-360;
end

if lonLims(1)<lonLims(2)
 % no crossing the 0 line
 iW=[];
 iE=find(lon_global>=lonLims(1) & lon_global<=lonLims(2));
else
 iW=find(lon_global>=lonLims(1) & lon_global<=lonEND);
 iE=find(lon_global>=lonSTR & lon_global<=lonLims(2));   
end    

iW=iW';
iE=iE';
