function [t,timeUnits,F]=read_series(fhead,fnumSTR,fnumEND,varName,timeName,...
                           startSpaceOnly,countSpaceOnly)
 
 % Read time series data (a huperslab) from a series of files 
 % [fhead int2strPAD(fnum,4) '.nc'], where fnum=fnumSTR:fnumEND
 % varName is the variable name
 % startSpaceOnly,countSpaceOnly are optional and represent the hyperslab 
 % (with the last, time dimension excluded)
 
 %%% Check the list of files for the length of the time dimension
 nt=0;
 for fnum=fnumSTR:fnumEND
  fname=[fhead int2strPAD(fnum,4) '.nc'];
  nt1=ncinfo(fname,timeName).Size;
  nt=nt+nt1;
 end
 
 if ~exist('countSpaceOnly','var')
  % then startSpaceOnly,countSpaceOnly are not provided;
  % find the array spatial dimensions from the file (entire spatial slab):
  s=ncinfo(fname,varName).Size;
  countSpaceOnly=s(1:end-1); % drop time
  startSpaceOnly=ones(size(countSpaceOnly));
 end
 ndims=length(countSpaceOnly);

 timeUnits=ncreadatt(fname,timeName,'units');
 
 %%% Define the output file
 t=nan*zeros(nt,1);
 F=nan*zeros([countSpaceOnly nt]);
 
 %%% Read files one by one, add to the output variable
 cnt=0;
 for fnum=fnumSTR:fnumEND
  fname=[fhead int2strPAD(fnum,4) '.nc'];
  nt1=ncinfo(fname,timeName).Size;
  iit=cnt+[1:nt1]';
  t(iit)=ncread(fname,timeName);
  f=double(ncread(fname,varName,[startSpaceOnly 1],[countSpaceOnly nt1]));
  if ndims==1
   F(:,iit)=f;
  elseif ndims==2
   F(:,:,iit)=f;
  elseif ndims==3
   F(:,:,:,iit)=f;
  end
  cnt=cnt+nt1;  
 end
     
end
