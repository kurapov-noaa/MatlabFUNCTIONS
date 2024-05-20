function [hc]=addcolorbar(ha,location,cb_dist,cb_width)

% function [hc]=addcolorbar(ha,location,dist,width)
%
% adds colorbar in axes hc without automatic rescaling the plot axes ha
% places the axes in the corrent figure at the "cb_dist" from the plot as specified:
% the axes width is "cb_width"

axes(ha);

if strcmp(location,'right')
 pc=get(gca,'position');
 pc(1)=pc(1)+pc(3)+cb_dist;
 pc(3)=cb_width;
 
else
 error('unknown colorbar axes location');
end
 
hc=colorbar('location','manual','position',pc);