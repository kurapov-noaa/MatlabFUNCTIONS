function [pos_new]=adjust_axes_position(ha,xlims,ylims,fpos)

% AK, 4/2/2015: adjust the position of the axes to improve the aspect ratio
% in geographical coordinates. 
% xlims,ylims: limits in geographical coordinates

pos=get(ha,'position');

theta0=mean(ylims);

axes_ratio_now=pos(3)*fpos(3)/(pos(4)*fpos(4));
axes_ratio_need=(xlims(2)-xlims(1))*cos(theta0*pi/180)/(ylims(2)-ylims(1));

% proposal: adjust pos(3) or pos(4) to make
% axes_ratio_need=pos(3)*fpos(3)/(pos(4)*fpos(4));

pos_new=pos;
if axes_ratio_need>axes_ratio_now
 % then adjust axes heihgt, pos(4)

 pos_new(4)=pos(3)*fpos(3)/(axes_ratio_need*fpos(4));
 
else
 % adjoint axes width, pos(3)
 pos_new(3)=axes_ratio_need*pos(4)*fpos(4)/fpos(3);
end
set(ha,'position',pos_new);
