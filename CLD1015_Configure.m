function CLD1015_Configure(visObj)
% Configure the Thorlabs CLD1015 with Default Setup
% visObj is an existing visa object that has been successfully opened
% before calling this function
% R. Sheehan 28 - 1 - 2019

% Turn off photodiode functionality 
fprintf (visObj, ':INP1:BIAS:STAT 0;:INP1:BIAS:VOLT:DC 0.0');

% Turn off amplitude modulation capability 
fprintf (visObj, ':SOUR1:AM:STAT:AM 0');

% Switch LDD to constant current mode
fprintf (visObj, ':SOUR1:FUNC:MODE CURR');

% Initialise the LDD
lddlimit = 500; % LDD current limit
CLD1015_Configure_LDD(visObj, lddlimit);

% Initialise the TEC
tec_Ilimit = 1.5; % TEC current limit
tec_high_temp_lim = 35; % TEC high temp limit
tec_low_temp_lim = 15; % TEC low temp limit
Tset = 25; % Desired temp setpoint
CLD1015_Configure_TEC(visObj, tec_Ilimit, tec_high_temp_lim, tec_low_temp_lim, Tset); 

% Check the Key Status
CLD1015_Qry_Key_Status(visObj, 1); 

end