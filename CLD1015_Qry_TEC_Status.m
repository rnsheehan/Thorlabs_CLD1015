function v = CLD1015_Qry_TEC_Status(visObj)
% Query the status of the CLD1015 TEC unit
% R. Sheehan 30 - 1 - 2019

v = str2double (query (visObj, ':OUTPUT2:STATE?'));

end