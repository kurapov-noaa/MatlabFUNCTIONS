function [Xt,Yt,tt]=traject2D_fast(Xo,Yo,t0,dt,t1,x,y,t,u,v);

% Computes surface particle trajectories using 
% ??th order Runge-Kutta algorithm
%
% USAGE:
%
% [Xt,Yt,tt]=traject2D(Xo,Yo,t0,dt,t1,x,y,t,u,v);
%
% INPUTS:
% Xo, Yo: initial locations of particles (column vectors, Np x 1)
% t0, dt, t1: release time, time step for the traj computation, 
%             and final time. 
% x, y - rectangular (Cartesian) grid coordinates, in which (u,v) are defined
% t: time of snapshots of (u,v), of length Nt
% u,v: velocity at locations (x,y) (Nx x Ny x Nt)
%
% OUTPUTS: Xt, Yt, tt: trajectories (Np x Nt1) and corresponding time (length Nt1)

tt=t0:dt:t1;
ntt=length(tt);
nxo=length(Xo);
Xt=NaN*zeros(nxo,ntt);
Yt=NaN*zeros(nxo,ntt);
Xt(:,1)=Xo;
Yt(:,1)=Yo;

nt=length(t);

% check dt<diff(t):
if any(dt>diff(t))
   error('stop since Lagrangian step dt > Eulerian step');
end

% find the time window for interpolation:
i1=find(t-tt(1)<=0);
i1=i1(end);

[nx,ny]=size(x);
x3D=repmat(x,[1 1 2]);
y3D=repmat(y,[1 1 2]);
t3D=zeros(nx,ny,2);
t3D(:,:,2)=1;

ino=find(~isnan(Xo)); % <- keeps a record of trajectories that did not dissapear

for k=2:ntt
 if (mod(k,10)==0)
  disp(['step ' num2str(k) ' out of ' num2str(ntt)]);
 end 
 if isempty(ino) break; end

 
 % find velocities at tt(k-1)
 to=tt(k-1);
 if to>t(i1+1) % move to the next interpolation time interval if nec.
  i1=i1+1;
 end
 ti=(to-t(i1))/(t(i1+1)-t(i1));
 ti=ti*ones(size(ino));
 U=NaN*zeros(nxo,1);
 V=NaN*zeros(nxo,1);
 U(ino)=interp3(y3D,x3D,t3D,u(:,:,i1:i1+1),Yt(ino,k-1),Xt(ino,k-1),ti)*1.e-3*3600*24;   % km/d
 V(ino)=interp3(y3D,x3D,t3D,v(:,:,i1:i1+1),Yt(ino,k-1),Xt(ino,k-1),ti)*1.e-3*3600*24;
 
 ino=find(~isnan(U) & ~isnan(V) & ~isnan(Xt(:,k-1)));
 if isempty(ino) break; end
 
 % find velocities at tt(k-1)+0.5*dt
 to=tt(k-1)+0.5*dt;
 if to>t(i1+1) % move to the next interpolation time interval if nec.
  i1=i1+1;
 end
 ti=(to-t(i1))/(t(i1+1)-t(i1));
 ti=ti*ones(size(ino));
 
 k1=dt*U(ino);
 l1=dt*V(ino);
 U=NaN*zeros(nxo,1);
 V=NaN*zeros(nxo,1);
 U(ino)=interp3(y3D,x3D,t3D,u(:,:,i1:i1+1),...
           Yt(ino,k-1)+0.5*l1,...
           Xt(ino,k-1)+0.5*k1,...
           ti)*1.e-3*3600*24;
 V(ino)=interp3(y3D,x3D,t3D,v(:,:,i1:i1+1),...
           Yt(ino,k-1)+0.5*l1,...
           Xt(ino,k-1)+0.5*k1,...
           ti)*1.e-3*3600*24;
 ino=find(~isnan(U) & ~isnan(V) & ~isnan(Xt(:,k-1)));
 if isempty(ino) break; end
 k2=dt*U(ino);
 l2=dt*V(ino);
 Xt(ino,k)=Xt(ino,k-1)+k2;
 Yt(ino,k)=Yt(ino,k-1)+l2;
end

