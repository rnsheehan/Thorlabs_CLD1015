function CLD1015_Configure_TEC(visObj, teclimit, tec_high_temp_lim, tec_low_temp_lim, Tset)
% Configure the Thorlabs CLD1015 TEC
% visObj is an existing visa object that has been successfully opened
% before calling this function
% teclimit is the upper current limit for the CLD1015 TEC, units of A
% typical teclimit = 1.5; 
% tec_high_temp_lim is the upper temp. limit for the TEC
% tec_low_temp_lim is the lower temp. limit for the TEC
% R. Sheehan 28 - 1 - 2019

% Add code needed to engage TEC
% Switch TEC to temperature control mode with temperature in units of
% Celcius 
fprintf (visObj, ':SOUR2:FUNC:MODE TEMP; :UNIT:TEMP C');

% Specify temperature calculation method for TEC
fprintf (visObj, ':SENS2:TEMP:THER:METH EXP');

% Specify current limt that TEC can apply 
% TEC current limt is expressed in units of A
%teclimit = 1.5; 
fprintf (visObj, [':SOUR2:CURR:LIM ', num2str(teclimit)]);

% Specify temperature limit range for diode
upper_lim = max(tec_high_temp_lim, tec_low_temp_lim); 
lower_lim = min(tec_high_temp_lim, tec_low_temp_lim); 
fprintf (visObj, [':SOUR2:TEMP:LIM:UPP ', num2str(upper_lim)]);
fprintf (visObj, [':SOUR2:TEMP:LIM:LOW ', num2str(lower_lim)]);

% Check status of temperature controller
% Turn the TEC ON safely
CLD1015_TEC_Safe_On_Off(visObj, Tset); 

end