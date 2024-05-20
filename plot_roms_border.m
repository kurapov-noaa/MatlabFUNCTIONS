function [pl]=plot_roms_border(ha,lon,lat,clr,LineWidth)

axes(ha);
hold on;
pl(1)=plot(lon(:,1),lat(:,1),'k-');
pl(2)=plot(lon(:,end),lat(:,end),'k-');
pl(3)=plot(lon(1,:),lat(1,:),'k-');
pl(4)=plot(lon(end,:),lat(end,:),'k-');

set(pl,'color',clr,'linewidth',LineWidth);
