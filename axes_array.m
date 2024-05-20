
function [ha]=axes_array(mplx,mply,axlx,axly)

% Generates an array of axes in a current figure
%
% USAGE: [ha]=axes_array(mplx,mply,axlx,axly);
%
% mplx,mply: axes array limits on the figure (relative to figure size)
% axlx,axly: limits for each axis (relative to mplx,mply)

npx=length(axlx)/2; % number of columns of subplots 
npy=length(axly)/2; % number of rows of subplots

% rescale axlx, axly to fit mplx and mply
axlx=mplx(1)+(mplx(2)-mplx(1))/(axlx(end)-axlx(1))*axlx;
axly=mply(1)+(mply(2)-mply(1))/(axly(end)-axly(1))*axly;
for i1=1:npx  % column number in the matrix of subplots (from l. to r.) 
for i2=1:npy  % row number in the matrix of subplots (from bottom to top)
    ha(i2,i1)=axes('position',[axlx(2*i1-1) axly(2*i2-1)... 
                   axlx(2*i1)-axlx(2*i1-1) axly(2*i2)-axly(2*i2-1)]);
end 
end

ha=flipud(ha);