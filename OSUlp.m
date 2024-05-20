function [uf,tf]=OSUlp(u,t,original);
%
% [uf,tf]=OSUlp(u,t) ...
%			 is a 40 hour lowpass filter documented in
% the CODE-2 data report (gray cover, 8.5"x14", spiral bound, WHOI
% Technical Report 85-35), on page 21,
% The weights are of the form:
%   0.5*(1.+cos(pi*T/61))* (sin(2*pi*T/40))/(2*pi*T/40),
% where T = -60,-59,-58,...,59,60  (121 weights in all).
% Normalize so sum of 121 weights = 1.00
%
% Data should be hourly or else a linear interpolation will be performed
%
   if nargin<3;
     original='n';
   end;
   if nargin<2;
     help OSUlp
     return;
   end;
% Interpolate to hourly data if necessary
   if round(24*(t(4)-t(3))*1000)/1000 ~= 1;
%     display('Data not hourly, linear interpolation used');
     ti=t(1):1/24:t(length(t));
     ui=interp1(t,u,ti,'linear');
   else;
     ti=t;
     ui=u;
   end;
% define weight function
   T=-60:1:60;
   w=zeros(1,121); w(61)=1;
   w(1:60)=0.5*(1.+cos(pi*T(1:60)/61)).* ...
             (sin(2*pi*T(1:60)/40))./(2*pi*T(1:60)/40);
   w(62:121)=0.5*(1.+cos(pi*T(62:121)/61)).* ...
             (sin(2*pi*T(62:121)/40))./(2*pi*T(62:121)/40);
   w=w/sum(w);
% Lowpass first 60 hours
   n=length(ui);
   for i=1:60;
% OLD OSUlp:
%       ww=w(60-i+1:121); ww=ww/sum(ww);
%       uf(i)=sum(ww.*ui(1:i+60+1)); tf(i)=ti(i);
    ww=w(60-i+2:121); ww=ww/sum(ww);
    uf(i)=sum(ww.*ui(1:i+60)); tf(i)=ti(i);
   end;
% Lowpass body of the time series
   for i=61:n-60;
       uf(i)=sum(w.*ui(i-60:i+60)); tf(i)=ti(i);
   end;
% Lowpass last 59 hours
   for i=n-59:n;
       ww=w(1:n-i+61); ww=ww/sum(ww);
       uf(i)=sum(ww.*ui(i-60:n)); tf(i)=ti(i);
   end;

% Interpolate back to original time
  if original=='y';
   if round(24*(t(4)-t(3))*1000)/1000 ~= 1;
     uf=interp1(tf,uf,t,'linear');
     tf=t;
   end;
  end;

