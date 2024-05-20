function [status]=fChangeThisStr(fname,str1,newstr,newfile);

% A. Kurapov, 11/03/04: 
% creates "newfile", which is a copy of file "fname" 
% with one line changed. Specificly, it finds the line containing
% "str1" and replaces it with a line "newstr"
% 
% USAGE: [status]=fChangeThisStr(fname,str1,newstr,newfile);
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

a=textread(fname,'%s','delimiter','\n','whitespace','');
Nlines=length(a);
for k=1:Nlines
 if ~isempty(findstr(a{k},str1))
  a{k}=newstr;
 end
end

fid=fopen(newfile,'w');
for k=1:Nlines
 fprintf(fid,'%s\n',a{k});
end
fclose(fid);


