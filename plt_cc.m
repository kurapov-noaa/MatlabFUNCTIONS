function hh=plt_cc(ha,cc)

 axes(ha);
 ncc=size(cc,2);
 k=1;

 while k<=ncc
  n=cc(2,k);
  cc(:,k)=nan;
  k=k+n+1;
 end

 hh=plot(cc(1,:),cc(2,:),'k-');
end

