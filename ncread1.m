function [a] = ncread1(fname,varname);

ncid = netcdf.open(fname,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,varname);
a=netcdf.getVar(ncid,varid,'double'); 
netcdf.close(ncid);
