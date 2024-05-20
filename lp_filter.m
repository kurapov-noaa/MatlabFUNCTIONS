function [tlp,flp]=lp_filter(t,f,Lfilter)

% [tlp,flp]=lp_filter(t,f,Lfilter)
% 
% where t (days) is the time variable
% f is the same length as t
% Use the OSU 40-h half-amp lp filter for any Lfilter (days):
fac=40/24/Lfilter;

nn=size(f);
if length(nn)==2 && nn(2)==1
 % then f is the 1-dim column vector, transpose to row to 
 % make the last dim of array f be equal to the length of t
 f=f';
end

[flp,tlp]=OSUlpFAST(f,t*fac);
tlp=tlp/fac;

