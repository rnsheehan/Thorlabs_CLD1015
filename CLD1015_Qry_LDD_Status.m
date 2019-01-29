function v = CLD1015_Qry_LDD_Status(visObj)
% Query the status of the LDD
% Is it on / off

v = str2double (query (visObj, ':OUTP1:STAT?'));