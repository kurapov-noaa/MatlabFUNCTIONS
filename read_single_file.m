function [ocean_time,var_list]=read_single_file(fname,field_list,start_3D,count_3D,Tan);

% Usage: 
% [ocean_time,var_list]=read_single_file(fname,field_list,start_3D,count_3D,Tan);
% start_3D =[io jo no], count_3D=[nx ny nz] (matlab indices)

Nfields=length(field_list);

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


     disp(['var_list.' field '=a;']);
     eval(['var_list.' field '=a;']);

   end % "for n=1:Nfields"

   ocean_time=t; 

 end % if nt>0

 status=mexnc('close',ncid);









