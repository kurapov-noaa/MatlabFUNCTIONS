function [dimLength]=read_ncdim(filename,dimName)

% 10/20/2020, AK: 
% read nc dimension, provided filename and dimension name

ncid = netcdf.open(filename,'NC_NOWRITE');
dimid = netcdf.inqDimID(ncid,dimName);
[dimname_out,dimLength] = netcdf.inqDim(ncid,dimid);
netcdf.close(ncid);
