function [dt,Tracks,NbPoints,Cycles,lon,lat,BeginDates,ind,SSH]=read_along_track_file(fname);

ncid=mexnc('open',fname,'nowrite');
 [varid, status] = mexnc('inq_varid',ncid,'Longitudes');
 [lon,status] = mexnc ('get_var_double',ncid,varid); 
 [lon_scale, status] = mexnc ( 'get_att_double',ncid,varid,'scale_factor');
 [lon_fill_value, status] = mexnc ( 'get_att_double',ncid,varid,'_FillValue'); 
 
 lon(find(lon==lon_fill_value))=NaN;
 lon=lon*lon_scale;

 [varid, status] = mexnc('inq_varid',ncid,'Latitudes');
 [lat,status] = mexnc ('get_var_double',ncid,varid); 
 [lat_scale, status] = mexnc ( 'get_att_double',ncid,varid,'scale_factor');
 [lat_fill_value, status] = mexnc ( 'get_att_double',ncid,varid,'_FillValue');

 lat(find(lat==lat_fill_value))=NaN;
 lat=lat*lat_scale;

 [varid, status] = mexnc('inq_varid',ncid,'DeltaT');
% varid
 [dt,status] = mexnc ('get_var_double',ncid,varid); 
 [dt_scale, status] = mexnc ( 'get_att_double',ncid,varid,'scale_factor');

 dt=dt*dt_scale;

 [varid, status] = mexnc('inq_varid',ncid,'BeginDates');
 [BeginDates,status] = mexnc ('get_var_double',ncid,varid); 
 [fill_value, status] = mexnc ( 'get_att_double',ncid,varid,'_FillValue');

 BeginDates(find(BeginDates==fill_value))=NaN;

 [varid, status] = mexnc('inq_varid',ncid,'NbPoints');
 [NbPoints,status] = mexnc ('get_var_double',ncid,varid); 

 [varid, status] = mexnc('inq_varid',ncid,'Tracks');
 [Tracks,status] = mexnc ('get_var_double',ncid,varid); 

 [varid, status] = mexnc('inq_varid',ncid,'Cycles');
 [Cycles,status] = mexnc ('get_var_double',ncid,varid); 

 [varid, status] = mexnc('inq_varid',ncid,'DataIndexes');
 [ind,status] = mexnc ('get_var_double',ncid,varid); 

% choose SLA or ADT

 [nvars, status] = mexnc ( 'inq_nvars', ncid );
 [varid_sla, status] = mexnc('inq_varid',ncid,'SLA');
 [varid_adt, status] = mexnc('inq_varid',ncid,'ADT');

nvarsm1=nvars-1;

 if varid_sla>nvarsm1 & varid_adt>nvarsm1
  error(['File ' fname ': no variables SLA or ADT']);
 end

 varid=varid_sla;
 if varid>nvarsm1
  varid=varid_adt;
 end
% nvars
% disp(['varid_sla=' num2str(varid_sla)]);
% disp(['varid_adt=' num2str(varid_adt)]);
% disp(['varid=' num2str(varid)]);

 [SSH,status] = mexnc ('get_var_double',ncid,varid); 
 [ssh_scale, status] = mexnc('get_att_double',ncid,varid,'scale_factor');
 SSH=SSH*ssh_scale;

status=mexnc('close',ncid);
