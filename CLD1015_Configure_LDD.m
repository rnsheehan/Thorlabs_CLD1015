function CLD1015_Configure_LDD(visObj, lddlimit)
% Configure the Thorlabs CLD1015 LDD
% visObj is an existing visa object that has been successfully opened
% before calling this function
% lddlimit is the upper current limit for the CLD1015 LDD, units of A
% typical lddlimit = 500e-3
% R. Sheehan 28 - 1 - 2019

% Turn off photodiode functionality 
fprintf (visObj, ':INP1:BIAS:STAT 0;:INP1:BIAS:VOLT:DC 0.0');

% Turn off amplitude modulation capability 
fprintf (visObj, ':SOUR1:AM:STAT:AM 0');

% Switch LDD to constant current mode
fprintf (visObj, ':SOUR1:FUNC:MODE CURR');

% Add code needed to engage LDD
% Specify current limit that can be applied across the diode
% limit value must be given in units of mA :SOUR1:CURR:LIM:AMPL %0.1fE-3
%fprintf (visObj, [':SOUR1:CURR:LIM:AMPL ', num2str(lddlimit)]);
CLD1015_Set_LDD_Curr_Lim(visObj, lddlimit); 

% Set LDD current value to 0.0 mA 
lddcurrent = 0.0; % LDD current ust be expressed in mA
%fprintf (visObj, [':SOUR1:CURR:LEV:AMPL ', num2str(lddcurrent)]);
CLD1015_Set_LDD_Curr(visObj, lddcurrent); 

% Ensure that LDD output is off, it can be turned on again later
fprintf (visObj, ':OUTP1:STAT 0');

end