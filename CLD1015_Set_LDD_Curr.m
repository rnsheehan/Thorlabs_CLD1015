function CLD1015_Set_LDD_Curr(visObj, Iset)
% set the current across the diode
% Ival must be within limits set during configuration
% Ival input in units of mA
% R. Sheehan 28 - 1 - 2019

Ilimit = CLD1015_Qry_LDD_Curr_Lim(visObj); % Query the assigned LDD current limits

 if Iset >= 0.0 && Iset <= Ilimit
     fprintf (visObj, [':SOUR1:CURR:LEV:AMPL ', num2str(Iset/1000.0)]);
 end
 pause(5) % wait 5 seconds to allow LDD to settle
 
end