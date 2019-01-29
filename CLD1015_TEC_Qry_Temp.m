function v = CLD1015_TEC_Qry_Temp(visObj)
% Query the present temperature of the CLD1015 TEC
% R. Sheehan 28 - 1 - 2019

v = str2double (query (visObj, ':SENS2:TEMP:DATA?'));

end
