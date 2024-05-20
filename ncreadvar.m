function [vo1,vo2,vo3,vo4] = ncreadvar(filename,v1,v2,v3,v4)
%NCREADVAR reading up to four variables from a netcdf file.
%
%  [vo1            ] = ncreadvar(filename,v1         )
%  [vo1,vo2        ] = ncreadvar(filename,v1,v2      )
%  [vo1,vo2,vo3    ] = ncreadvar(filename,v1,v2,v3   )
%  [vo1,vo2,vo3,vo4] = ncreadvar(filename,v1,v2,v3,v4)
%  
%  vout=ncreadvar(filename,'aaa')  Read the variable of aaa with the full
%  range from the file of filename;
%
%  vout=ncreadvar(filename,'aaa(3:100,4:20)')  Read the variable of aaa with 
%  the specified range from the file of filename.
%

%error(nargchk(2,5,nargin))
if nargin ~= nargout+1; disp('nargin should be equal to (nargout+1)'); end

nc=netcdf(filename,'nowrite');
for ii=1:nargin-1
  tmp=strcat(eval(['v',num2str(ii)]));
  if tmp(end)~=')'
    if length(find(tmp=='(' | tmp==':' | tmp==')'))~=0
      disp('There is a format error for the variable to read in');
      disp(['The variable is ',tmp]);
    else
      eval(['vo',num2str(ii),'=nc{''',tmp,'''}(:);']);
    end
  else
    III1=find(tmp=='(');
    III2=find(tmp==')');
    III3=find(tmp==',');
    III4=find(tmp==':');
    tmp2=strcat(tmp(1:III1(1)-1));
    eval(['itmp=ncsize(nc{''',tmp2,'''});']);
    dim_tmp=sum(itmp>1);
    if length(III1)==1 & length(III2)==1 & length(III3)==dim_tmp-1 & ...
       length(III4)==dim_tmp & dim_tmp>0 & III1(1)<III4(1) & ...
       sum(III4(1:end-1)<III3)==dim_tmp-1 & III3(end)<III4(end) & ...
       III4(end)<III2(end)
       eval(['vo',num2str(ii),'=nc{''',tmp2,'''}',tmp(III1(1):III2(end)),';']);
    else
      disp('There is a format error for the variable to read in');
      disp(['Pay attention to the range',tmp]);
    end
  end      
end
nc=close(nc);

%-------------------------------------------------------------------------
