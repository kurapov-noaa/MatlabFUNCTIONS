function [it]=useKeyToAdvanceIndex(fhandle,it,itMin,itMax)

was_a_key=waitforbuttonpress;
if was_a_key && strcmp(get(fhandle, 'CurrentKey'), 'rightarrow')
 it=min(it+1,itMax);
elseif was_a_key && strcmp(get(fhandle, 'CurrentKey'), 'leftarrow')
 it=max(it-1,itMin);
elseif was_a_key && strcmp(get(fhandle, 'CurrentKey'), 'escape')
 it=itMin-1;
end
