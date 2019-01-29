function v = CLD1015_TEC_Qry_T_Limits(visObj)
% Query the upper temperature limit
% Output array in the form [Tlow, Thigh]

Tlow = str2double (query (visObj, ':SOUR2:TEMP:LIM:LOW?'));

Thigh = str2double (query (visObj, ':SOUR2:TEMP:LIM:UPP?'));

v = [Tlow, Thigh]; 

end