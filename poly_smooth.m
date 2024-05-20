function [as]=poly_smooth(a,n);

% USAGE:
% [as]=poly_smooth(a,n);

% filter:
c=abs(poly(ones(n-1,1)));
n2=(n-1)/2;

as=zeros(size(a));

N=length(a);
for k=1:N
 list=[k-n2:k+n2];
 in=find(list>=1 & list <= N);
 as(k)=sum( c(in).*a(list(in)) )/sum(c(in));
end

