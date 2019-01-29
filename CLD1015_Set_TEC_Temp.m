function CLD1015_Set_TEC_Temp(visObj, Tset)
% assign a value for the TEC setpoint
% ideally this value should be within limits specified during configuration
% if Tset is outside limits set during configuration then a default value
% for Tset is assumed
% R. Sheehan 28 - 1 - 2019

Tlimits = CLD1015_TEC_Qry_T_Limits(visObj); 

if Tset >= Tlimits(1) && Tset <= Tlimits(2)
    fprintf (visObj, ['SOURCE2:TEMPERATURE:SPOINT ', num2str(Tset)]);
else
    fprintf (visObj, 'SOURCE2:TEMPERATURE:SPOINT 25');
end
pause(10) % wait 5 seconds to allow TEC to settle

end