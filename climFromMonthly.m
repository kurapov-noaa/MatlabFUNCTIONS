function [aCLIM]=climFromMonthly(t,a)

% [aCLIM]=climFromMonthly(t,a)
%
% Develop monthly climatology given several years of monthly data
% t: datenum matlab format (monthly values, in principle any values 
% as the code will average all the entries for the corresponding month)
%
% This works for 3 mo running averages as well if the running ave for each
% mo is computed prior to computing the climatology

nn=size(a);

aCLIM=zeros([prod(nn(1:end-1)) 12]);

a=reshape(a,[prod(nn(1:end-1)) nn(end)]);

dv=datevec(t);

for mo=1:12
 in_t=find(dv(:,2)==mo);
 aCLIM(:,mo)=mean(a(:,in_t),2,'omitnan');
end

aCLIM=reshape(aCLIM,[nn(1:end-1) 12]);
