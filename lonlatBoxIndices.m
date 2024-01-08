function [start,count,iSTR,iEND,jSTR,jEND]=lonlatBoxIndices(x2D,y2D,xlims,ylims)

% INPUTS: x2D, y2D: 2d grid (curvilinear, like lon_rho,lat_rho)
%         xlims,ylims: box limits in x and y

% OUTPUT: 
% start: indices of the bounding box in x2D,y2D that includes points 
%        within xlims, ylims
% count: the size of the box in each direction (number of elements)

[nx,ny]=size(x2D);
 
[jj,ii]=meshgrid(1:ny,1:nx);
 
msk=zeros(nx,ny);
msk(x2D>=xlims(1) & x2D<=xlims(2) & ...
    y2D>=ylims(1) & y2D<=ylims(2) )=1;
kk=find(msk==1);
 
iSTR=min(ii(kk));
iEND=max(ii(kk));
jSTR=min(jj(kk));
jEND=max(jj(kk));
start=[iSTR jSTR];
count=[iEND-iSTR+1 jEND-jSTR+1];
 


