function [ocean_time,var_list]=read_his(filehead,fnum1,fnum2,field_list,start_3D,count_3D)

% Usage: AK 2019/06/07. Totally reworking this old obsolete file, from mexnc
% times. No Tan. Simply concatenate fields from fnum1 to fnum2. 
% [ocean_time,var_list]=read_his(filehead,fnum1,fnum2,field_list,start_3D,count_3D);
% start_3D =[io jo no], count_3D=[nx ny nz] (matlab indices)

nfields=length(field_list);

% First obtain the total length of the time series of inputs:
nt=0;
for k=fnum1:fnum2
 fname=[filehead int2strPAD(k,4) '.nc'];
 finfo=ncinfo(fname);
 dimNames = {finfo.Dimensions.Name};
 dimL={finfo.Dimensions.Length};
 if k==fnum1
  %% Using the first file in the list: 
  % - determine order of time dimension on the list: 
  iTime=find(strncmpi(dimNames,'ocean_time',length('ocean_time')) | ... 
             strncmpi(dimNames,'ocean_time',length('time')));
  
  % - For each var on the list, determine start and count (3D or 2D)       
  for kfi=1:nfields
   varNames={finfo.Variables.Name};
   ivar=
  end
  
 end
 nt=nt+dimL{iTime};
end
disp(['nt=' int2str(nt)]);

ocean_time=zeros(nt,1);
var_list=[];




for fnum1:fnum2


% 
% 
%     
%     fname=[filehead '_' int2strPAD(k,4) '.nc'];
%  disp(['reading ' fname '...']);
% 
%  ncid=mexnc('open',fname,'nowrite');
%   [varid, status] = mexnc('inq_varid',ncid,'ocean_time');
%   [t, status] = mexnc ( 'get_var_double', ncid, varid);
%   in_time=findin(t,Tan);
%   nt=length(in_time);
%   t=t(in_time);
% 
%   if nt>0
% 
%    for n=1:Nfields
% 
%     field=field_list{n};
% 
%     [varid,status]=mexnc('inq_varid',ncid,field);
%     [Ndims,status]=mexnc('inq_varndims',ncid,varid);
% 
%     if Ndims==3
%      start=[in_time(1)-1 start_3D(2)-1 start_3D(1)-1];
%      count=[nt count_3D(2) count_3D(1)];
%     elseif Ndims==4
%      start=[in_time(1)-1 fliplr(start_3D)-1];
%      count=[nt fliplr(count_3D)];     
%      disp(start);
%      disp(count);
%     else
%      error(['read_his: field ' field ' is not 3 or 4 dim, Ndims=' num2str(Ndims)]); 
%     end
% 
%     [a,status]=mexnc('get_vara_double',ncid,varid,start,count); 
% 
%     if firstfile
% 
%      disp(['var_list.' field '=a;']);
%      eval(['var_list.' field '=a;']);
% 
%     else     
% 
%      disp(['var_list.' field '=cat(Ndims,var_list.' field ',a);']);
%      eval(['var_list.' field '=cat(Ndims,var_list.' field ',a);']);
%     end % firstfile
% 
%    end % "for n=1:Nfields"
% 
%    if firstfile 
%     ocean_time=t; 
%     firstfile=0;
%    else 
%     ocean_time=[ocean_time;t];
%    end
% 
%  end % if nt>0
% 
%  status=mexnc('close',ncid);
% 
% end % k=fnum1:fnum2









