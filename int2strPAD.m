function nn=int2strPAD(i,n);

% USAGE: nn=int2strPAD(i,n);

nn=int2str(i);
while length(nn)<n
 nn=['0' nn];
end

