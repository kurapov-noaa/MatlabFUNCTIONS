function [status]=fChangeNextStr(fname,str1,newstr,newfile);

% A. Kurapov, 11/03/04: 
% creates "newfile", which is a copy of file "fname" 
% with some lines changed. Specificly, it finds the lines containing
% "str1" and replaces lines following those with "newstr"
% 
% USAGE: [status]=fChangeNextStr(fname,str1,newstr,newfile);
%
% status= Number of lines changed
% If newfile not given, overwrites the file

status=0;
if nargin==3
 newfile=fname;
end

if ~exist(fname,'file')
 error(['file ' fname ' does not exist']);
end
%if exist(newfile,'file')
% error(['cannot overwrite file ' newfile]);
%end

a=textread(fname,'%s','delimiter','\n','whitespace','');
Nlines=length(a);
for k=1:Nlines
 if ~isempty(findstr(a{k},str1))
  a{k+1}=newstr;
 end
end

fid=fopen(newfile,'w');
for k=1:Nlines
 fprintf(fid,'%s\n',a{k});
end
fclose(fid);

%k=0; % <- use this for break in case of run-away
%changeNextLineYES=0;
%while k<1000 
% line=fgetl(fidREAD);
% if isnumeric(line) 
%  break;
% end
%
% if changeNextLineYES
%  clear line;
%  line=newstr; 
%  changeNextLineYES=0;
% else
%  in=findstr(line,str1);
%  if ~isempty(in)
%   changeNextLineYES=1;
%  end  
% end
% fprintf(fidWRITE,'%s\n',line);
% k=k+1;
%end 
%fclose(fidREAD);
%fclose(fidWRITE);

