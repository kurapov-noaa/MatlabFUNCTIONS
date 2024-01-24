function s0=s_at_z0(z,z0)

% INPUTS: 
% z:  z-coordinates, a 3D array, of size nx,ny,nz
% z0: z=const levels (a 1D array), of length n
%
% OUTPUT: an array of vertical partial indices where z=z0, of size nx,ny,n

[nx,ny,nz]=size(z);
n=length(z0);

% 1d representation of 3d indices: 
[j2d,i2d]=meshgrid(1:ny,1:nx);
jvec=reshape(j2d,[nx*ny 1]);
ivec=reshape(i2d,[nx*ny 1]);

s0=nan*zeros(nx,ny,n);
for k=1:n
 %- the 3d array of vertical indices:
 s3d=repmat(reshape([1:nz]',[1 1 nz]),[nx,ny,1]);
 
 %- mark incides above the given depth as nan
 s3d(z>z0(k))=nan; 
 
 % - find shallowest indices that are still numbers (at each vertical
 % column this will be the lower index for linear interpolation)
 % note: where some values in a column are numbers, msk == s1, 
 % in columns where all the s3d values are nan (ie where the deepest z <=
 % z0(k)), msk == nan and s1 == 1.   
 [msk,s1]=max(s3d,[],3);
 
 %- redefine msk as (1 or nan)
 msk(~isnan(msk))=1;     
  
%  % interpolation between two layers: s=s1+(s2-s1)*(z-z1)/(z2-z1);
%  % - note: s2-s1=1
%  for j1=1:ny
%   for i1=1:nx
%    z1=z(i1,j1,s1(i1,j1));
%    z2=z(i1,j1,s1(i1,j1)+1);
%    s0(i1,j1,k)=s1(i1,j1)+(z0(k)-z1)/(z2-z1);
%   end
%  end
%  s0(:,:,k)=s0(:,:,k)*msk;

 % try the same thing, without a double loop:
 svec1=reshape(s1,[nx*ny 1]);
 ind1=sub2ind([nx,ny,nz],ivec,jvec,svec1);
 svec2=reshape(s1+1,[nx*ny 1]);
 ind2=sub2ind([nx,ny,nz],ivec,jvec,svec2);
 s00=svec1+(z0(k)-z(ind1))./(z(ind2)-z(ind1));
 s0(:,:,k)=reshape(s00,[nx ny]).*msk;
end