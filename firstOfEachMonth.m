function [dates]=firstOfEachMonth(dateSTR,dateEND)

% [dates]=firstOfEachMonth(dateSTR,dateEND)
%
% Creates the vector of dates between dateSTR and dateEND including the 
% 1st of each month. Include the 1st of dateSTR and dateEND months

nmo=numberMonths(dateSTR,dateEND);

tSTR=datenum(dateSTR);
tEND=datenum(dateEND);

tt=zeros(nmo,1);
k=0;
tday=tSTR;
while tday<=tEND
 k=k+1;
 dv=datevec(tday);
 dv(3)=1;
 dv(4:6)=0;
 tt(k)=datenum(dv);
 tday=datenum(firstOfNextMonth(datestr(tday)));
end
  
dates=datestr(tt);
