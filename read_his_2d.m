function [days,a]=read_his_2d(filehead,fnum1,fnum2,varName,start,count)

% Usage: AK 2019/06/07. No Tan. Simply concatenate fields from fnum1 to fnum2. 
% [ocean_time,a]=read_his_2d(filehead,fnum1,fnum2,varName,start,count);
% start =[io jo], count=[nx ny] (matlab indices)
% Just 1 variable

% First obtain the total length of the time series of inputs:
nt=0;
for k=fnum1:fnum2
 fname=[filehead int2strPAD(k,4) '.nc'];
 finfo=ncinfo(fname);
 dimNames = {finfo.Dimensions.Name};
 dimL={finfo.Dimensions.Length};
 if k==fnum1
  %%% Using the first file in the list: 
  % - determine order of time dimension on the list: 
  iTime=find(strncmpi(dimNames,'ocean_time',length('ocean_time')) | ... 
             strncmpi(dimNames,'ocean_time',length('time')));
  
  % determine ref time:
  units=ncreadatt(fname,'ocean_time','units');
  ref_date=recognize_time_stamp(units);
  t0=datenum(ref_date);
 end
 nt=nt+dimL{iTime};
 
end
disp(['nt=' int2str(nt)]);

days=zeros(nt,1);
a=zeros([count nt]);

nt=0; % var nt recycled after arrays days and a are defined
for k=fnum1:fnum2
 fname=[filehead int2strPAD(k,4) '.nc'];
 disp(fname);
 t=ncread(fname,'ocean_time')/24/3600+t0;
 nt1=length(t);
 iit=nt+[1:nt1];
 days(iit)=t;
 a(:,:,iit)=ncread(fname,varName,[start 1],[count nt1]);
 nt=nt+nt1;
end