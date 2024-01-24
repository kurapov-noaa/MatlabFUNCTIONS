function [dx_u,dx_v]=rho_uv(dx)
dx_u=0.5*(dx(1:end-1,:,:)+dx(2:end,:,:));
dx_v=0.5*(dx(:,1:end-1,:)+dx(:,2:end,:));