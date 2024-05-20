function d=distBigArc(lon0,lat0,lon,lat,R)

% find the distance between pnt (lon0,lat0) and a set of points (lon,lat)
% that can be presented by arrays lon and lat of any shape
%
% USAGE: d=distBigArc(lon0,lat0,lon,lat)

pi_o_180=pi/180;
lon_rad=lon*pi_o_180;
lat_rad=lat*pi_o_180;
lon0_rad=lon0*pi_o_180;
lat0_rad=lat0*pi_o_180;

nn=size(lon_rad);
lon_rad=reshape(lon_rad,[prod(nn) 1]);
lat_rad=reshape(lat_rad,[prod(nn) 1]);

[x,y,z]=sph2cart(lon_rad,lat_rad,1);
[x0,y0,z0]=sph2cart(lon0_rad,lat0_rad,1);

n=length(lon_rad);

X=[x y z];
X0=[x0 y0 z0];

S=cross(X,repmat(X0,[n 1]));
S=sqrt(dot(S,S,2)); % the norm of the cross product

C=dot(X,repmat(X0,[n 1]),2);

d=R*atan2(S,C);
d=reshape(d,nn);

