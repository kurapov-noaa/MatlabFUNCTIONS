function [value]=read_att(file,varname,attname);

% USAGE:
%
% value=read_att(file,varname,attname);


ncid=mexnc('open',file,'nowrite');
[varid, status] = mexnc('inq_varid',ncid,varname);
[datatype,attlen,status]=mexnc('inq_att',ncid,varid,attname);
if datatype==nc_char
 [value,status]=mexnc('get_att_text',ncid,varid,attname); 
else
 error('read_att: datatype not known');
end
status=mexnc('close',ncid);

