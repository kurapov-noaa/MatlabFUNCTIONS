function [h]=add_year_lines(ha,label_location,clr,lnstyle,lnwidth)

% AK, 12/22/2015: add year lines to time series plot in axes ha, return
% handle h
% Assuming time series is plotted using matlab ref time 
%
% USAGE: [h]=add_year_lines(ha,label_location,clr,lnstyle,lnwidth);
%
% ha: axes handle
% label_location: 'top','bottom', number, 'none'. If number, it is the y
%                 location in axis relative coordinates

xlims=get(ha,'xlim');
ylims=get(ha,'ylim');

v1=datevec(xlims(1));
v2=datevec(xlims(2));

years=[v1(1):v2(1)]';
ny=length(years);
vv=[years ones(ny,2) zeros(ny,3)];

x=datenum(vv);
in=find(x>=xlims(1) & x<xlims(2));
x=x(in);
years=years(in);
nx=length(x);

if nargin<3
 clr='r';   
end

if nargin<4
 lnstyle='--';
end

if nargin<5
 lnwidth=2;
end

axes(ha);
[xx,yy]=meshgrid(x,ylims);
h.lineHandle=plot(xx,yy,'linestyle',lnstyle,'color',clr,'linewidth',lnwidth);

xtxt=x+10;
if isnumeric(label_location)
 ytxt=label_location;
elseif ischar(label_location) && strcmp(label_location,'top')
 ytxt=0.9;
elseif ischar(label_location) && strcmp(label_location,'bottom')
 ytxt=0.1;
end
ytxt=ylims(1)+ytxt*diff(ylims);

h.textHandle=text(xtxt,ytxt*ones(nx,1),int2str(years),'color',clr,'fontweight','bold');








