function CLD1015_Set_LDD_Curr_Lim(visObj, Ilim)
% Assign a value to the max current that the LDD can output
% Ilim input in units of mA

fprintf (visObj, [':SOUR1:CURR:LIM:AMPL ', num2str(Ilim/1000.0)]);

end