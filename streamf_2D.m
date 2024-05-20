function [psi]=streamf_2D(z,u,indx);

% function [psi]=streamf_2D(z,u,indx);                    %
%                                                         %
% computes streamfunctions of the 2D                      %
% (vert. vs. cross-shore coordinates) flow                %
% u=u(x,z),                                               %
% z is the 2D array of size nx times N+1 (w levels)       %
% u is the 2D array of size nx times N (at rho levels)    %
% (note, x is not used)                                   %
%                                                         %
% Boundary conditions options:                            %
% indx=1: use psi=0 at the bottom                         %
% indx=2: use psi=0 at the usrface                        %
% indx=3: least-squares (use both surf and bottom BC)     %
%                                                         %
% A. Kurapov, 3/22/2008                                   %               

[nx,ns]=size(z);
psi=zeros(nx,ns);

if     indx==1

% USE BC AT THE BOTTOM:
 for k=2:ns
  psi(:,k)=psi(:,k-1)+(z(:,k)-z(:,k-1)).*u(:,k-1);
 end

elseif indx==2

% USE BC AT THE SURFACE:
 for k=ns:-1:2
  psi(:,k-1)=psi(:,k)-(z(:,k)-z(:,k-1)).*u(:,k-1);
 end

elseif indx==3

% PSI BY LEAST SQUARES:
 sig_b=1e-2;
 sig_s=sig_b;
 sig_U=5e-3;
 c=[sig_b.^2;sig_U.^2*ones(ns-1,1);sig_s.^2];
 invC=diag(1./c);
 L=zeros(ns+1,ns);
 L(1,1)=1;
 L(end,end)=1;
 for k=1:ns-1
  L(k+1,k)=-1;
  L(k+1,k+1)=1;
 end
 U=(z(:,2:end)-z(:,1:end-1)).*u;
 U=[zeros(nx,1) U zeros(nx,1)];
 U=U';
 P=L'*invC*L;
 psi=P\(L'*invC*U);
 psi=psi';

end % cases indx=1,2,3
