function [a1]=ave_3mo(t,a,dSTR,dEND)

 % Three-month running average of a time series: 
 % t: time
 % a: an array with the last dim = length(t)

 a1.time=[];
 a1.value=[];
 
 % The 1st of each output month:
 dates_1st=firstOfEachMonth(dSTR,dEND);
 nt=size(dates_1st,1);
 
 nn=size(a);

 a1.time=nan*zeros(nt,1);
 a1.value=nan*zeros([prod(nn(1:end-1)) nt]);
 
 a=reshape(a,[prod(nn(1:end-1)) nn(end)]);
 
 for it=1:nt
  date_i=dates_1st(it,:);
  date_str=firstOfLastMonth(date_i);
  date_end=firstOfNextMonth(firstOfNextMonth(date_i));
  t_str=datenum(date_str);
  t_end=datenum(date_end);
  in_t=find(t>=t_str & t<t_end);
  a1.time(it)=mean(t(in_t));   
  a1.value(:,it)=mean(a(:,in_t),2);
 end

 a1.value=reshape(a1.value,[nn(1:end-1) nt]);
end