function [h]=legendAK(objs,strings,pos,ll);

% USAGE:
% [h]=legendAK(objs,strings,pos,ll);
% Legend for objs in 2 columns
% objs - vector of objects
% strings - cell object, each element is a string
% pos  - axes position (with resp. to the figure)
% ll - line length  
 
[no,mo]=size(objs);
if min ([no mo]) > 1 error('In legendAK: objs is not a vector'); end
nlines=max([no mo]);
nstrings=length(strings);
if nlines~=nstrings 
 error('In legendAK: No of objects ~= No of strings');
end

n1=ceil(nlines/2); % <- No of lines in 1st col
y1=[0.5:1:n1-0.5]'/n1; y1=flipud(y1); % <- y-locations of lines

h=axes('position',pos,'ButtonDownFcn','moveaxis',...
       'xlim',[0 1],'ylim',[0 1],...
       'visible','off');
hold on;
lleg=zeros(nlines);
lleg=zeros(nlines);

% column 1
for k=1:n1
 lleg(k)=plot([0.02 0.02+ll],[y1(k) y1(k)],...
              'linestyle',get(objs(k),'linestyle'),...
              'linewidth',get(objs(k),'linewidth'),...
              'marker',get(objs(k),'marker'),...
              'markeredgecolor',get(objs(k),'markeredgecolor'),...
              'markerfacecolor',get(objs(k),'markerfacecolor'),...
              'markersize',get(objs(k),'markersize'),...
              'color',get(objs(k),'color'));
 text(0.05+ll,y1(k),strings{k},'verticalalignment','middle');
end

% column 1
for k=n1+1:nlines
 lleg(k)=plot([0.52 0.52+ll],[y1(k-n1) y1(k-n1)],...
              'linestyle',get(objs(k),'linestyle'),...
              'linewidth',get(objs(k),'linewidth'),...
              'marker',get(objs(k),'marker'),...
              'markeredgecolor',get(objs(k),'markeredgecolor'),...
              'markerfacecolor',get(objs(k),'markerfacecolor'),...
              'markersize',get(objs(k),'markersize'),...
              'color',get(objs(k),'color'));
 text(0.55+ll,y1(k-n1),strings{k},'verticalalignment','middle');
end

