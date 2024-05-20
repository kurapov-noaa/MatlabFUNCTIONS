function [h]=time_series_design(ha,ylims,dSTR,dEND)

% output variable h is a structure (handles of the lines and year txt from 
% add_year_lines

axes(ha);
hold on;
xlims=[datenum(dSTR) datenum(dEND)];
set(gca,'ylim',ylims,'xlim',xlims,'layer','top','box','on');
grid on;
h=add_year_lines(gca,'top','k','--',1);

[tcks,labels]=get_ticks_labels(dSTR,dEND,'monthly',1,'mmm');
labels=labels(:,1);
%labels(2:2:end)=' ';
%nlab=size(labels,1);
%labels=[repmat(' ',[nlab 1]) labels];
set(gca,'xtick',tcks,'xticklabel',labels,'box','on','fontsize',8); 
