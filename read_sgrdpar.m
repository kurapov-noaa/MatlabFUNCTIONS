function [theta_s,theta_b,Tcline,N]=read_sgrdpar(fname);

%
% USAGE: 
% [theta_s,theta_b,Tcline,N]=read_sgrdpar(fname);


ncid=mexnc('open',fname,'nowrite');

[varid,status]=mexnc('inq_varid',ncid,'theta_s');
[theta_s,status]=mexnc('get_var_double',ncid,varid);

[varid,status]=mexnc('inq_varid',ncid,'theta_b');
[theta_b,status]=mexnc('get_var_double',ncid,varid);

[varid,status]=mexnc('inq_varid',ncid,'Tcline');
[Tcline,status]=mexnc('get_var_double',ncid,varid);

[dimid,status]=mexnc('inq_dimid',ncid,'s_rho');
[N,status]=mexnc('inq_dimlen',ncid,dimid);

status=mexnc('close',ncid);
