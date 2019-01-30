function v = CLD1015_Status(visObj)
% return a vector with the key status, LDD status and TEC status
% R. Sheehan 30 - 1 - 2019

key_status = CLD1015_Qry_Key_Status(visObj, 0); % key must be open

ldd_status = CLD1015_Qry_LDD_Status(visObj); % LDD status

tec_status = CLD1015_Qry_TEC_Status(visObj); % TEC status

v = [key_status, ldd_status, tec_status]; 

end