function [fnames,tt,IT1,NT]=formtimeser(pdir,Tan);
% Form one time series from a set of history files
%
% USAGE: [fnames,tt,IT1,NT]=formtimeser(pdir,Tan);
% INPUTS: 
%   pdir: directory where history files from one run are stored
%   Tan:  analysis period
% OUTPUTS: 
%   fnames: file names found (a cell variable)
%   tt:     selected time series from each file (a cell variable)
%   IT1:    first element index to read in the netcdf file (netcdf convention: 
%           first element would be 0)
%   NT:     length of selected time series

% 1/10/04: modification to allow one file ('ocean_his.nc')

if pdir(end)~='/' pdir=[pdir '/']; end

a=evalc(['ls -l ' pdir 'ocean_his*.nc']);
II1=findstr(a,'his')+4;
II2=findstr(a,'.nc')-1;

nfiles=length(II2);
IT1=zeros(nfiles,1); % <- locations of first elements in the time series
NT=zeros(nfiles,1);  % <- lengths of time series to read 
tt=cell(nfiles,1);    % <- stores time series
fnames=cell(nfiles,1);

for k=1:nfiles
 if II1(k)>II2(k)
  fnames{k}='ocean_his.nc';
 else
  fnames{k}=['ocean_his_' a(II1(k):II2(k)) '.nc'];
 end
 cdfid=mexnc('open',[pdir fnames{k}],'nowrite');
  
  [t,status] = mexnc('VARGET',cdfid,'ocean_time',[0],[-1],1);
  t=t/3600/24;

  if k==1
   it1=1;
  else
   it1=min(find(t>tt{k-1}(end)));
   t=t(it1:end);
  end

  tt{k}=t; 
  IT1(k)=it1-1;    % <- netcdf convention
  NT(k)=length(t);

 status=mexnc('close',cdfid);
end

% Adjust for Tan:
for k=1:nfiles
 t=tt{k};
 in=findin(t,Tan);
 tt{k}=t(in);
 NT(k)=length(tt{k});
 if NT(k)==0
  IT1(k)=NaN;
 else
  IT1(k)=IT1(k)+in(1)-1;
 end
end
