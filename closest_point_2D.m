function [io,jo]=closest_point_2D(lon2D,lat2D,lono,lato)

[nx,ny]=size(lon2D);
[jj,ii]=meshgrid(1:ny,1:nx);

m1=nx*ny;
lon1D=reshape(lon2D,[m1 1]);
lat1D=reshape(lat2D,[m1 1]);
ii=reshape(ii,[m1 1]);
jj=reshape(jj,[m1 1]);
[tmp,k]=min((lon1D-lono).^2+(lat1D-lato).^2);
io=ii(k);
jo=jj(k);

