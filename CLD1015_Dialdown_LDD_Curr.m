function CLD1015_Dialdown_LDD_Curr(visObj, cldStatus)
% Dial down the current on the LDD
% Implicitly assuming that if LDD is off then Ival = 0

%key_status = CLD1015_Qry_Key_Status(visObj, 0); % key must be open

if cldStatus(1) == 0 && cldStatus(2) == 1 && cldStatus(3) == 1
    %status = CLD1015_Qry_LDD_Status(visObj); % LDD must be switched on
    Ival = CLD1015_LDD_Qry_Ival(visObj); % present LDD output must be non-zero

    if Ival > 0.0
        % Dial the current down from its present value
        depth = 10; count = 0;
        while count < depth
            CLD1015_Set_LDD_Curr(visObj, Ival / 2.0 );
            Ival = CLD1015_LDD_Qry_Ival(visObj);
            count = count + 1; 
        end
        CLD1015_Set_LDD_Curr(visObj, 0.0);
    else
        CLD1015_Set_LDD_Curr(visObj, 0.0);
    end
end

end