function [ocean_time,var_list]=read_his_fast(fileheadorcn,fnum1,fnum2,field_list,start_3d_big,count_3d_big,Tan,bequiet);
% Usage:
% [ocean_time,var_list]=read_his_fast(fileheadorcn,fnum1,fnum2,field_list,start_3d,count_3d,Tan,bequiet);
% start_3d =[io jo no], count_3d=[nx ny nz] (matlab indices). Well, not
% exactly. start_3d_big(k,:) and count_3d_big(k,:) correspond to the start
% and count values for the i-th entry in the field list.
%
% Program structure
% 1. Get the size of the time dimensions - size of space dimensions is
% known apriori
% 2. Initialize structure - use apriori knowledge of spatial dimensions
% 3. Fill structure

if isstr(fileheadorcn)
   filehead=fileheadorcn;
else
  [~, ~, ~, ~, filehead, ~, ~]=case_data(fileheadorcn);
end
clear fileheadorcn

if nargin<8
     bequiet=0;
end

nfields=length(field_list);
if nfields ==0
     disp('No fields to be read from file')
     return
end

if size(start_3d_big,1)<nfields
     start_3d_big=repmat(start_3d_big,nfields,1);
     count_3d_big=repmat(count_3d_big,nfields,1);
end

firstfile=1;

% 1. Get fields' dimensions
for k=fnum1:fnum2
     fname=[filehead '_' int2strPAD(k,4) '.nc'];
     
     if ~bequiet
          disp(['finding length of time dimension in ' fname '...']);
     end
     
     ncid=mexnc('open',fname,'nowrite'); %closes on line 47
     [varid, status] = mexnc('inq_varid',ncid,'ocean_time');
     [t, status] = mexnc ( 'get_var_double', ncid, varid);
     in_time=findin(t,Tan);
     nt=length(in_time);
     t=t(in_time);
     
     if firstfile
          ocean_time=t;
          firstfile=0;
     else
          ocean_time=[ocean_time;t];
     end
     
     status=mexnc('close',ncid); %opens on line 33
end % k=fnum1:fnum2

% 2. Initialize structure - use apriori knowledge of spatial dimensions
% (but check to see if 3d or 4d)



if length(ocean_time)>1
     for f_lp=1:nfields
          fname=[filehead '_' int2strPAD(fnum1,4) '.nc'];
          ncid=mexnc('open',fname,'nowrite'); %close on line 74
          field=field_list{f_lp};
          [varid,status]=mexnc('inq_varid',ncid,field);
          [ndims,status]=mexnc('inq_varndims',ncid,varid);
          start_3d=start_3d_big(f_lp,:);
          count_3d=count_3d_big(f_lp,:);
          if ndims==3
               %                disp(['var_list.' field '=zeros([count_3d(1:2),length(ocean_time)]);']);
               eval(['var_list.' field '=zeros([count_3d(1:2),length(ocean_time)]);']);
          elseif ndims==4
               %                disp(['var_list.' field '=zeros([count_3d(1:3),length(ocean_time)]);']);
               eval(['var_list.' field '=zeros([count_3d(1:3),length(ocean_time)]);']);
          else
               %                error(['read_his: field ' field ' is not 3 or 4 dim, ndims=' num2str(ndims)]);
               if ~bequiet
                    disp(['read_his: field ' field ' is not 3 or 4 dim, ndims=' num2str(ndims) '; output is NaN']);
               end
               var_list=NaN;
          end
          status=mexnc('close',ncid); %opens on line 58
     end
end

% 3. Fill structure
time_start=1;
chunksizehint=16*prod([count_3d_big(1,:),nt]);
for k=fnum1:fnum2
     %      tic
     fname=[filehead '_' int2strPAD(k,4) '.nc'];
     if ~bequiet
          disp(['reading data from' fname '...']);
     end
     
     ncid=mexnc('open',fname,'nowrite',chunksizehint); %close on line 129
     [varid, status] = mexnc('inq_varid',ncid,'ocean_time');
     [t, status] = mexnc ( 'get_var_double', ncid, varid);
     in_time=findin(t,Tan);
     nt=length(in_time);
     
     
     if nt>0
          for n=1:nfields
               start_3d=start_3d_big(n,:);
               count_3d=count_3d_big(n,:);
               field=field_list{n};
               
               [varid,status]=mexnc('inq_varid',ncid,field);
               [ndims,status]=mexnc('inq_varndims',ncid,varid);
               
               if ndims==3
                    start_rhf=[in_time(1)-1 start_3d(2)-1 start_3d(1)-1];
                    count=[nt count_3d(2) count_3d(1)];
               elseif ndims==4
                    start_rhf=[in_time(1)-1 fliplr(start_3d)-1];
                    count=[nt fliplr(count_3d)];
                    %                     disp(start);
                    %                     disp(count);
               else
                    disp(['read_his: field ' field ' is not 3 or 4 dim, ndims=' num2str(ndims) '; output is NaN']);
                    var_list=NaN;
                    start_rhf=start_3d;
                    count=count_3d;
               end
               
               [a,status]=mexnc('get_vara_double',ncid,varid,start_rhf,count);
               
               if ndims==3
                    if ~bequiet
                         disp(['var_list.',field,'(:,:,:,time_start:time_start+nt-1)=a;']);
                    end
                    eval(['var_list.',field,'(:,:,time_start:time_start+nt-1)=a;']);
               elseif ndims==4
                    if ~bequiet
                         disp(['var_list.',field,'(:,:,:,time_start:time_start+nt-1)=a;']);
                    end
                    eval(['var_list.',field,'(:,:,:,time_start:time_start+nt-1)=a;']);
               end
               
               
          end % "for n=1:nfields"
          
     end % if nt>0
     
     status=mexnc('close',ncid); %open on line 86
     time_start=time_start+nt;
     %      toc
end % k=fnum1:fnum2
end %main function