function [gamma] = angle_ContourDirectionFromEast(lons,lats)

% gamma (degrees): Contour direction measured from east
% Inputs: lons,lats: of the same length, are the contour coordinates on the
% sphere (in degrees)

% Algorithm: use local plane approximation in each point, centeral
% differences except at the ends

n=length(lons);

d2r=pi/180;

dx=nan*zeros(size(lons));
dy=nan*zeros(size(lons));
dy(2:end-1)=d2r*(lats(3:end)-lats(1:end-2));
dx(2:end-1)=d2r*(lons(3:end)-lons(1:end-2)).*cos(d2r*lats(2:end-1));

% process the ends:
if (lons(1)==lons(end) && lats(1)==lats(end))
 % closed contour:
 dy(1)=d2r*(lats(2)-lats(end-1));
 dx(1)=d2r*(lons(2)-lons(end-1))*cos(d2r*lats(1));
 dy(end)=dy(1);
 dx(end)=dx(1);
else
 % open contour, 1-side difference at the ends:
 dy(1)=d2r*(lats(2)-lats(1));
 dx(1)=d2r*(lons(2)-lons(1))*cos(d2r*lats(1));
 dy(end)=d2r*(lats(end)-lats(end-1));
 dx(end)=d2r*(lons(end)-lons(end-1))*cos(d2r*lats(end));
end
 
xE=dx;
yE=zeros(1,n);
dp=xE.*dx+yE.*dy;
cp=xE.*dy-yE.*dx;
gamma=atan2(cp,dp);

gamma=180*gamma/pi;

