function v = CLD1015_TEC_Qry_Tval(visObj)
% Query the actual current across the laser diode
% return the read value in units of mA

v = str2double (query (visObj, ':SENS2:TEMP:DATA?'));

end