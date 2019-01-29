function v = CLD1015_Qry_LDD_Curr_Lim(visObj)
% Query the current limit on the LDD

v = str2double (query (visObj, ':SOUR1:CURR:LIM:AMPL?')); 
v = 1000.0 * v; % return current in units of mA

end