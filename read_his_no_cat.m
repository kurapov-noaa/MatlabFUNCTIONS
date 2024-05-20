function [ocean_time,var_list]=read_hisno_cat(filehead,fnum1,fnum2,field_list,start_3D,count_3D,Tan);

% Usage: 
% [ocean_time,var_list]=read_his_no_cat(filehead,fnum1,fnum2,field_list,start_3D,count_3D,Tan);
% start_3D =[io jo no], count_3D=[nx ny nz] (matlab indices)

Nfields=length(field_list);
firstfile=1;

for k=fnum1:fnum2
 fname=[filehead '_' int2strPAD(k,4) '.nc'];
 disp(['checking ' fname '...']);

 ncid=mexnc('open',fname,'nowrite');
  [varid, status] = mexnc('inq_varid',ncid,'ocean_time');
  [t, status] = mexnc ( 'get_var_double', ncid, varid);
  in_time=findin(t,Tan);

  if nt>0
   nt=length(in_time);
   t=t(in_time);

   if firstfile 
    ocean_time=t; 
    firstfile=0;
   else 
    ocean_time=[ocean_time;t];
   end
  end

 status=mexnc('close',ncid);
end
NT=length(ocean_time);

firstfile=1;
i1=1;

for k=fnum1:fnum2
 fname=[filehead '_' int2strPAD(k,4) '.nc'];
 disp(['reading ' fname '...']);

 ncid=mexnc('open',fname,'nowrite');
  [varid, status] = mexnc('inq_varid',ncid,'ocean_time');
  [t, status] = mexnc ( 'get_var_double', ncid, varid);
  in_time=findin(t,Tan);
  nt=length(in_time);
  t=t(in_time);

  if nt>0

   for n=1:Nfields

    field=field_list{n};

    [varid,status]=mexnc('inq_varid',ncid,field);
    [Ndims,status]=mexnc('inq_varndims',ncid,varid);

    if Ndims==3
     start=[in_time(1)-1 start_3D(2)-1 start_3D(1)-1];
     count=[nt count_3D(2) count_3D(1)];
    elseif Ndims==4
     start=[in_time(1)-1 fliplr(start_3D)-1];
     count=[nt fliplr(count_3D)];     
     disp(start);
     disp(count);
    else
     error(['read_his: field ' field ' is not 3 or 4 dim, Ndims=' num2str(Ndims)]); 
    end

    [a,status]=mexnc('get_vara_double',ncid,varid,start,count); 

    if firstfile

     disp(['var_list.' field '=;']);
     eval(['var_list.' field '=a;']);

     firstfile=0;

    else     

     disp(['var_list.' field '(:,:,:,i1:i1+nt-1)=a.;']);
     eval(['var_list.' field '(:,:,:,=cat(Ndims,var_list.' field ',a);']);
    end % firstfile

   end % "for n=1:Nfields"


 end % if nt>0

 status=mexnc('close',ncid);

end % k=fnum1:fnum2









