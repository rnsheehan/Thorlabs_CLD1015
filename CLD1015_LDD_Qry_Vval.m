function v = CLD1015_LDD_Qry_Vval(visObj)
% Query the actual voltage across the laser diode
% return the read value in units of V

v = str2double (query (visObj, ':SENS4:VOLT:DC:DATA?')); 

end