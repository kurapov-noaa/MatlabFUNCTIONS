function [as]=gauss_smooth(x,a,dlx);

% USAGE:
% [as]=gauss_smooth(a,n);

n=length(a);
a=reshape(a,[n 1]);

[xx,xx1]=meshgrid(x,x);

C=exp(-(xx-xx1).^2/(2*dlx^2));
c=sum(C,2);
as=(C*a)./c;

as=reshape(as,size(a));



