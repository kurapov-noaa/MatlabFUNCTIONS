function [htxt]=add_text_figure(ha,xf,yf,txt)

% Add text to the figure at the location provided by the
% figure coordinates (xf,yf)
% Added to the axes ha

pos=get(ha,'position');
yp=(yf-pos(2))/pos(4);
xp=(xf-pos(1))/pos(3);
axes(ha);
htxt=text(xp,yp,txt,'units','normalized','interpret','none');
