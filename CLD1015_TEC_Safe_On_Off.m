function v = CLD1015_TEC_Safe_On_Off(visObj, Tset)
% Check status of temperature controller
% If TEC is ON, leave it ON at present temperature
% If TEC is OFF, switch it ON at present temperature, but change
% temperature to standard value

v = str2double (query (visObj, ':OUTP2:STAT?'));

if v == 1
    % TEC is operational, change temperature to Tset value
    CLD1015_Set_TEC_Temp(visObj, Tset);
else
    % TEC is not operational, must be switched on
    Tpr = CLD1015_TEC_Qry_Temp(visObj); % read present temperature
    
    CLD1015_Set_TEC_Temp(visObj, Tpr);
    
    % switch TEC on at present temperature to avoid driving TEC too hard 
    CLD1015_Set_TEC_Status(visObj, 1);
    
    pause(5) % wait 5 seconds to allow TEC to settle
    
    CLD1015_Set_TEC_Temp(visObj, Tset); % Change temperature to set point    
end

end