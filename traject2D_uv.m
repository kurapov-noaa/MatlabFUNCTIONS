function [Xt,Yt,tt]=traject2D_uv(Xo,Yo,t0,dt,t1,t,x_u,y_u,u,x_v,y_v,v)

% Computes surface particle trajectories using 
% the 4th order Runge-Kutta algorithm
%
% u and v on a staggered grid
%
% USAGE:
%
% [Xt,Yt,tt]=traject2D(Xo,Yo,t0,dt,t1,t,x_u,y_u,u,x_v,y_v,v);
%
% INPUTS:
% Xo, Yo: initial locations of particles (column vectors, Np x 1)
% t0, dt, t1: release time, time step for the traj computation, 
%             and final time. 
% x_u, y_u - rectangular (Cartesian) grid coordinates, in which u is defined
% x_v, y_v - rectangular (Cartesian) grid coordinates, in which v is defined
% t: time of snapshots of (u,v), of length Nt
% u,v: velocity at locations (x,y) (... x ... x Nt)
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
i1=find(t<=tt(1));
i1=i1(end);

[xi_u,eta_u]=size(x_u);
[xi_v,eta_v]=size(x_v);
x_u_3D=repmat(x_u,[1 1 2]);
y_u_3D=repmat(y_u,[1 1 2]);
x_v_3D=repmat(x_v,[1 1 2]);
y_v_3D=repmat(y_v,[1 1 2]);

t_u_3D=zeros(xi_u,eta_u,2);
t_v_3D=zeros(xi_v,eta_v,2);
t_u_3D(:,:,2)=1;
t_v_3D(:,:,2)=1;


for k=2:ntt

 if (mod(k,1)==0)
  disp(['step ' num2str(k) ' out of ' num2str(ntt)]);
 end 
 
 % k1, l1 (@ t=to)
 to=tt(k-1);
 if to>t(i1+1) % move to the next interpolation time interval if nec.
  i1=i1+1;
 end
 ti=(to-t(i1))/(t(i1+1)-t(i1));

 U=NaN*ones(nxo,1);
 V=NaN*ones(nxo,1);

 ino=find(~isnan(Xt(:,k-1)) & ~isnan(Yt(:,k-1)));
 if isempty(ino)
  k
  ino
  return;
 end

 ti=ti*ones(size(ino));
 
 U(ino)=interp3(y_u_3D,x_u_3D,t_u_3D,u(:,:,i1:i1+1),Yt(ino,k-1),Xt(ino,k-1),ti);
 V(ino)=interp3(y_v_3D,x_v_3D,t_v_3D,v(:,:,i1:i1+1),Yt(ino,k-1),Xt(ino,k-1),ti);
 
 k1=dt*U;
 l1=dt*V;
 
 % k2, l2 (@ t=t(k-1)+0.5*dt)
 to=tt(k-1)+0.5*dt;
 if to>t(i1+1) % move to the next interpolation time interval if nec.
  i1=i1+1;
 end

 ti=(to-t(i1))/(t(i1+1)-t(i1));

 U=NaN*ones(nxo,1);
 V=NaN*ones(nxo,1);

 ino=find(~isnan(Xt(:,k-1)+0.5*k1) & ~isnan(Yt(:,k-1)+0.5*l1));
 if isempty(ino), return; end
 ti=ti*ones(size(ino));

 U(ino)=interp3(y_u_3D,x_u_3D,t_u_3D,u(:,:,i1:i1+1),...
           Yt(ino,k-1)+0.5*l1(ino),...
           Xt(ino,k-1)+0.5*k1(ino),ti);
 V(ino)=interp3(y_v_3D,x_v_3D,t_v_3D,v(:,:,i1:i1+1),...
           Yt(ino,k-1)+0.5*l1(ino),...
           Xt(ino,k-1)+0.5*k1(ino),...
           ti);

 k2=dt*U;
 l2=dt*V;

 % k3, l3 (@ t=t(k-1)+0.5*dt)
 to=tt(k-1)+0.5*dt;
 if to>t(i1+1) % move to the next interpolation time interval if nec.
  i1=i1+1;
 end
 ti=(to-t(i1))/(t(i1+1)-t(i1));

 U=NaN*ones(nxo,1);
 V=NaN*ones(nxo,1);

 ino=find(~isnan(Xt(:,k-1)+0.5*k2) & ~isnan(Yt(:,k-1)+0.5*l2));

 if isempty(ino), return; end
% keyboard;
 ti=ti*ones(size(ino));

 U(ino)=interp3(y_u_3D,x_u_3D,t_u_3D,u(:,:,i1:i1+1),...
           Yt(ino,k-1)+0.5*l2(ino),...
           Xt(ino,k-1)+0.5*k2(ino),ti);
 V(ino)=interp3(y_v_3D,x_v_3D,t_v_3D,v(:,:,i1:i1+1),...
           Yt(ino,k-1)+0.5*l2(ino),...
           Xt(ino,k-1)+0.5*k2(ino),...
           ti);

 k3=dt*U;
 l3=dt*V;

 % k4, l4 (@ t=t(k-1)+dt)
 to=tt(k-1)+dt;
 if to>t(i1+1) % move to the next interpolation time interval if nec.
  i1=i1+1;
 end

 ti=(to-t(i1))/(t(i1+1)-t(i1));
 
 U=NaN*ones(nxo,1);
 V=NaN*ones(nxo,1);

 ino=find(~isnan(Xt(:,k-1)+k3) & ~isnan(Yt(:,k-1)+l3));
 if isempty(ino), return; end
 ti=ti*ones(size(ino));
 
 U(ino)=interp3(y_u_3D,x_u_3D,t_u_3D,u(:,:,i1:i1+1),...
           Yt(ino,k-1)+l3(ino),...
           Xt(ino,k-1)+k3(ino),ti);
 V(ino)=interp3(y_v_3D,x_v_3D,t_v_3D,v(:,:,i1:i1+1),...
           Yt(ino,k-1)+l3(ino),...
           Xt(ino,k-1)+k3(ino),...
           ti);

 k4=dt*U;
 l4=dt*V;

 Xt(:,k)=Xt(:,k-1)+(1/6)*(k1+2*k2+2*k3+k4);
 Yt(:,k)=Yt(:,k-1)+(1/6)*(l1+2*l2+2*l3+l4);
 
end

