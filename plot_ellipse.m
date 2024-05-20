function [] = plot_ellipse(x0,y0,u,v)

if u(1)*v(2)-u(2)*v(1)>0
 clr='r'; % ccw
else
 clr='b'; % cw
end

plot([x0;x0+u],[y0;y0+v],'-','color',clr);
