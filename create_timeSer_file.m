function create_timeSer_file(fnameOUT,vars)

% Defines the time series file fnameOUT (overwrites if needed)
% vars is an array of structure variables such as
%  vars(k).name=varName;
%  vars(k).datatype='single';
%  vars(k).dimensions={'time',Inf};
%  vars(k).attributes{1}={'long_name',varNameLongName};
%  vars(k).attributes{2}={'units',varUnits};

% name and datatype are compalsory, dimensions is optional, and attributes
% are as well optional

if exist(fnameOUT,'file')>0
 delete(fnameOUT);
end

nvar=length(vars);

for k=1:nvar

 if isempty(vars(k).dimensions)
  % scalar: dimensions not provided
  nccreate(fnameOUT,vars(k).name,'datatype',vars(k).datatype);
 else
  % array, dimensions are provided:
  
  nccreate(fnameOUT,vars(k).name,'datatype',vars(k).datatype,...
                    'dimensions',vars(k).dimensions);
 end

 if iscell(vars(k).attributes)
  natt=length(vars(k).attributes);
  for katt=1:natt

   ncwriteatt(fnameOUT,vars(k).name,vars(k).attributes{katt}{1},vars(k).attributes{katt}{2});
  end
 end

end % for k=1:nvars

