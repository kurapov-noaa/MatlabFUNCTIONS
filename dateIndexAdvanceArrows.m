function [d]=dateIndexAdvanceArrows(hf,d,step,dSTR,dEND)

% hf: figure handle
% d: current date, date index etc.
% step: step to advance
% dSTR, dEND: date index limit

was_a_key=waitforbuttonpress;
if was_a_key && strcmp(get(hf, 'CurrentKey'), 'rightarrow')
 d=min(d+step,dEND);
elseif was_a_key && strcmp(get(hf, 'CurrentKey'), 'leftarrow')
 d=max(d-step,dSTR);
elseif was_a_key && strcmp(get(hf, 'CurrentKey'), 'escape')
 d=dSTR-1;
end