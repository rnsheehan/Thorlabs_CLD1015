function CLD1015_Set_LDD_Status(visObj, status)
% Turn the output of the LDD On / Off

present_status = CLD1015_Qry_LDD_Status(visObj); 

if present_status == 1 && status == 0
    % turn the LDD off from on state
    % need to dial-down current if current ~= 0
    CLD1015_Dialdown_LDD_Curr(visObj);
    fprintf (visObj, ':OUTP1:STAT 0');
elseif present_status == 0 && status == 1
    % turn laser on from off state
    % reset current value to zero
    CLD1015_Set_LDD_Curr(visObj, 0.0);
    fprintf (visObj, ':OUTP1:STAT 1');
else
    % don't need to do anything
end

end