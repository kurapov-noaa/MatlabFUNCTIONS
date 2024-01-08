function [ur,vr]=uv_rho(u,v)

% u, v may be a multidim array (ndims >=2)
% assume that roms 1st direction is index 1 and
%                  2nd direction is index 2

uSize=size(u);
vSize=size(v);

% Check dimension consistency:
if uSize(1)+1 ~= vSize(1)
 error('in uvrho, first dimensions of u and v arrays are inconsistent'); 
end

if vSize(2)+1 ~= uSize(2)
 error('in uvrho, second dimensions of u and v arrays are inconsistent'); 
end

rSize=uSize;
rSize(1)=rSize(1)+1;

ur=nan*zeros(rSize);
vr=nan*zeros(rSize);

% interior rho points:
ii=2:rSize(1)-1;
jj=2:rSize(2)-1;

ur(ii,jj,:)=0.5*(u(ii-1,jj,:)+u(ii,jj,:));
vr(ii,jj,:)=0.5*(v(ii,jj-1,:)+v(ii,jj,:));




