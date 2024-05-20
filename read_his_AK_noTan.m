function [ocean_time,a]=read_his(filehead,fnum1,fnum2,field_list,start_3d,count_3d,Tan)

% Usage:
% [ocean_time,var_list]=read_his_fast_AK(filehead,fnum1,fnum2,field_list,start,count,Tan);
%

ocean_time=[];
a=[];

fnums=[fnum1:fnum2]';
nf=length(fnums);

% Get time length:
nnt=zeros(nf,1);

for kf=1:nf
 
 fname=[filehead '_' int2strPAD(fnums(kf),4) '.nc'];
     
 ncid = netcdf.open(fname,'NC_NOWRITE');
  varid = netcdf.inqVarID(ncid,'ocean_time');
  t=netcdf.getVar(ncid, varid,'double'); 
  in=findin(t,Tan);
  nnt(kf)=length(in);
 netcdf.close(ncid);
end 

nt=sum(nnt);

% Initialize output arrays:
ocean_time=NaN*zeros(nt,1);

if nt>0
 fname=[filehead '_' int2strPAD(fnums(1),4) '.nc'];
 disp(fname);
 ncid = netcdf.open(fname,'NC_NOWRITE');

 for kv=1:length(field_list)
  varid=netcdf.inqVarID(ncid,field_list{kv});
  [varname,xtype,dimids,natts] = netcdf.inqVar(ncid,varid);
  ndims=length(dimids);
  
  if ndims==3     % 2D field
   eval(['a.' field_list{kv} '= NaN*zeros([count_3d(1:2) nt]);']);
   
  elseif ndims==4 % 3D field
   eval(['a.' field_list{kv} '= NaN*zeros([count_3d(1:3) nt]);']);
  end
 
 end

 netcdf.close(ncid);

end % nt>0

% Fill in arrays (structure a):
it1=1;

for kf=1:nf
 
 if nnt(kf)>0

  fname=[filehead '_' int2strPAD(fnums(kf),4) '.nc'];
     
  ncid = netcdf.open(fname,'NC_NOWRITE');

  varid = netcdf.inqVarID(ncid,'ocean_time');
  t=netcdf.getVar(ncid, varid,'double'); 
  in=findin(t,Tan);
  ntk=length(in);
  itt=[it1:it1+ntk-1];
  ocean_time(itt)=t(in);

  for kv=1:length(field_list)
   varid=netcdf.inqVarID(ncid,field_list{kv});
   [varname,xtype,dimids,natts] = netcdf.inqVar(ncid,varid);
   ndims=length(dimids);
   disp(['reading ' varname ', ...' fname(end-20:end)]);
   if ndims==3     % 2D field
    eval(['a.' field_list{kv} '(:,:,itt)  = netcdf.getVar(ncid,varid,[start_3d(1:2) in(1)]-1,[count_3d(1:2) ntk],''double'');']);
   
   elseif ndims==4 % 3D field
    eval(['a.' field_list{kv} '(:,:,:,itt)=netcdf.getVar(ncid,varid,[start_3d(1:3) in(1)]-1,[count_3d(1:3) ntk],''double'');']);
   end
  end
  it1=it1+ntk;
  netcdf.close(ncid);

 end % nnt(kf)>0
end % for kf=1:nf


