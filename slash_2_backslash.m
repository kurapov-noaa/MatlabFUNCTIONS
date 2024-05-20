function [cbackslash]=slash_2_backslash(c)

cbackslash=c;
cbackslash(strfind(c,'/'))='\';
