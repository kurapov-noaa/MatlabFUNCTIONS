function [phi]=apply_harmonic(B,u);

% USAGE: [phi]=apply_harmonic(B,u);
%
% - INPUT:  u is the time series array (the last dim is of size nt)
% -         B is the previously computed linear fit matrix (2 x nt)
% - OUTPUT: phi is the array of harmonic coefficients

nn=size(u);
nb=size(B);

if nn(end)~=nb(2)
 error(' ERR in apply_harmonics: nn(end)~=nb(2)');
end
nt=nn(end);

a=reshape(u,[prod(nn(1:end-1)) nt]);
phi=B*a';
phi=reshape(phi',[nn(1:end-1) 2]);
