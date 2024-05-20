function []=cbarcontour(ha,cons,cxs)

% Plotting a colorbar using contours
% USAGE
% >> cbarcontour(ha,cons,cxs);
% 
% where ha is the axis handle, and cons is the vector contour lines

axes(ha);
pos=get(ha,'position');

if pos(3)>pos(4)
 % HORIZONTAL AXES
 [xc,yc]=meshgrid(cons,[0 1]);
 [cc,hh]=contourf(xc,yc,xc,cons);
 set(hh,'edgecolor','none');
 set(ha,'layer','top','box','on','ytick',[]); 
 set(gca,'xlim',cxs);
else
 % VERTICAL AXES
 [xc,yc]=meshgrid([0 1],cons);
 [cc,hh]=contourf(xc,yc,yc,cons);
 set(hh,'edgecolor','none');
 set(ha,'layer','top','box','on','xtick',[]); 
 set(gca,'ylim',cxs);
end
caxis(cxs);