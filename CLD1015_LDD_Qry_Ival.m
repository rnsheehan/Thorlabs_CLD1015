function v = CLD1015_LDD_Qry_Ival(visObj)
% Query the actual current across the laser diode
% return the read value in units of mA

v = str2double (query (visObj, ':SENS3:CURR:DC:DATA?'));
v = 1000.0 * v; 

end