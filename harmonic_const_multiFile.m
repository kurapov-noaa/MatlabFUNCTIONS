function [amp,phase,f_ave]=harmonic_const_multiFile(timeSerObject,periodVec)

nc=length(periodVec);
dims=timeSerObject.dims;
N=prod(dims);

% Form vector t:
t=timeSerObject.time; % - assume days
Nt=length(t);

% Form A (cos, -sin coefficients)
omega=2*pi./periodVec;
omega_x_t=reshape(t,[Nt 1])*reshape(omega,[1 nc]); % => size Nt x Nc 
c=cos(omega_x_t);
s=sin(omega_x_t);
A=[c -s];
ApA=A'*A;

B=ApA\(A');

c=zeros(2*nc,N);
f_ave=zeros(N,1);
oNt=1/Nt;
for it=1:Nt
 f=timeSerObject.field(it);
 f=reshape(f,[N 1]);
 f_ave=f_ave+oNt*f;
 c=c+B(:,it)*f';
end

% Correct c to represent the demeaned time series:
b=sum(B,2);
c=c-b*f_ave';

zR=c(1:nc,:);
zI=c(nc+1:end,:);
amp=sqrt(zR.*zR+zI.*zI);
phase_rad=atan2(zI,zR); 

phase=phase_rad*180/pi;

amp=reshape(amp',[dims nc]);
phase=reshape(phase',[dims nc]);

f_ave=reshape(f_ave,dims);

