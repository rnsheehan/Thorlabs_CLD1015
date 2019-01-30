function CLD1015_Set_LDD_Status(visObj, cldStatus, LDDStatus)
% Turn the output of the LDD On / Off

%key_status = CLD1015_Qry_Key_Status(visObj, 0); 

if cldStatus(1) == 0
    % key is not locked so LDD can be switched on
    %present_status = CLD1015_Qry_LDD_Status(visObj); 

    if cldStatus(2) == 1 && LDDStatus == 0
        % turn the LDD off from on state
        % need to dial-down current if current ~= 0
        CLD1015_Dialdown_LDD_Curr(visObj, cldStatus);
        fprintf (visObj, ':OUTP1:STAT 0');
    elseif cldStatus(2) == 0 && LDDStatus == 1
        % turn laser on from off state
        % reset current value to zero
        CLD1015_Set_LDD_Curr(visObj, cldStatus, 0.0);
        fprintf (visObj, ':OUTP1:STAT 1');
    else
        % don't need to do anything
    end
end

end