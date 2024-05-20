function [a]=try_eval(str,N)

 a=eval(str);
 keyboard;

 success=0;
 ntimes=1;
 while success==0 && ntimes <= N   
  try
   disp(str);
   a=eval(str);
   success=1;
   disp(int2str(success));
  catch
   ntimes=ntimes+1; 
   disp('try again...');
  end
 end
 
 if success==0
  error(['bad read: ' str]);   
 end
 
end
