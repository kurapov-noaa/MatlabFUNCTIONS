function [a] = ncdim1(fname,dimname);

ncid = netcdf.open(fname,'NC_NOWRITE');
dimid = netcdf.inqDimID(ncid,dimname);
[tmp,a]=netcdf.inqDim(ncid,dimid); 
netcdf.close(ncid);
