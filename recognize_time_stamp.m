function [date1]=recognize_time_stamp(str)

% recognize time stamp in a string

in1=strfind(str,'-');
if isempty(in1)
 in1=strfind(str,'/');
end

% new: 
inb=strfind(str,' ');

%ins=sort([0 inb in1 length(str)+1]);
ins=[inb in1]; % combine indices of the blancs and -- or //

inSemiCol=strfind(str,':');
if isempty(inSemiCol) || (~isempty(inSemiCol) && diff(inSemiCol)==2 )
 % no time added or 0:0:0
 ins=sort([0 inb in1 length(str)+1]);  
 j1=ins(find(ins==in1(1))-1)+1;
 j2=ins(find(ins==in1(2))+1)-1;   
else
 % time HH:MM:SS is included. First correct to format "date HH:MM:SS"
 % i.e. possibly replace T before HH with a blanc and remove Z after SS if needed 
 str(inSemiCol(1)-3)=' ';
 str=str(1:inSemiCol(2)+2); 
 ins=sort([0 inb in1 inSemiCol length(str)+1]);
 j1=ins(find(ins==in1(1))-1)+1;
 j2=ins(find(ins==inSemiCol(2))+1)-1;
end
 
date1=str(j1:j2);

