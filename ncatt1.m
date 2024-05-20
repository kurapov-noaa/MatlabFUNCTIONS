function [a] = ncatt1(fname,varname,attname);

ncid = netcdf.open(fname,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,varname);
a = netcdf.getAtt(ncid,varid,attname);

netcdf.close(ncid);
