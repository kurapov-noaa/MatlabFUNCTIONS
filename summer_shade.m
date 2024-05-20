function summer_shade(ha,ylims,years,clr)
 axes(ha);
 hold on;

 for yr=years
  t1=datenum(['01-Jun-' int2str(yr)]);
  t2=datenum(['01-Sep-' int2str(yr)]);
  xp=[t1 t2 t2 t1 t1];
  yp=[ylims(1) ylims(1) ylims(2) ylims(2) ylims(1)];
  pp=patch(xp,yp,clr,'lineStyle','none');
 end

end
