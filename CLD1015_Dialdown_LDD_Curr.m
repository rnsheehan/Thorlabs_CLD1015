function CLD1015_Dialdown_LDD_Curr(visObj)
% Dial down the current on the LDD
% Implicitly assuming that if LDD is off then Ival = 0

status = CLD1015_Qry_LDD_Status(visObj);
Ival = CLD1015_LDD_Qry_Ival(visObj);

if status == 1 && Ival > 0.0
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