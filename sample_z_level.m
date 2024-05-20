function [T0] = sample_z_level(T,z,z0)

% The 3D T array, of size (nx,ny,nz) is defined at vertical levels z (e.g., z can be defined by
% scoord).
% The output T0, of size (nx,ny) is T sampled at z=z0, where z0 = const
%
% If T is of size (nx,ny,nz,nt), nt>1, then T0 is of size(nx,ny,nt), ie
% z every snapshots uses the same z grid coordinates (e.g., if the
% relatively minor effect of changing SSH on z is neglected)

% find 

n0=length(z0);
[nx,ny,nz]=size(z);
T0=nan*zeros(nx,ny,n0);

for k0=1:n0
 dz=s-z0(k0);
 
end    
    



