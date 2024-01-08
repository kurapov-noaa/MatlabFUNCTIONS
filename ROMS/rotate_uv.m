function [u1,v1]=rotate_uv(u,v,alpha)

% u1, v1: vector components in a coordinate system rotated CCW with respect to
% the original orthogonal one where the vecotr field is (u,v). 
% u,v: first two dimensions are the same as angle alpha(rad)

cosa=cos(alpha);
sina=sin(alpha);

s=size(u);

if length(s)>2
 cosa=repmat(cosa,[1 1 s(3:end)]);
 sina=repmat(sina,[1 1 s(3:end)]);
end

u1= u.*cosa+ v.*sina;
v1=-u.*sina+ v.*cosa;


