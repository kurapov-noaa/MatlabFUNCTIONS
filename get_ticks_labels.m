function [tcks,labels]=get_ticks_labels(date1,date2,freqID,dt,fmt)

% USAGE: [tcks,labels]=get_ticks_labels(date1,date2,freqID,dt,fmt)
% freqID: 'monthly','equal'
% If 'equal', then dt = tick offset

if strcmp(freqID,'monthly')
 % first of the month: for the entire year
 v1=datevec(date1);
 v2=datevec(date2);
 
 years=[v1(1):v2(1)];
 ny=length(years);
 [yy,mm]=meshgrid(years,1:12);
 
 ntcks=12*ny;
 vv=[reshape(yy,[ntcks 1]) reshape(mm,[ntcks 1]) ones(ntcks,1) zeros(ntcks,3)];
 tcks=datenum(vv);
 labels=datestr(vv,fmt);
 
elseif strcmp(freqID,'equal')

 tcks=datenum(date1):dt:datenum(date2);
 labels=datestr(tcks',fmt);
    
end