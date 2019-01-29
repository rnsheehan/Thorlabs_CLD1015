%   Integrating a CLD10xx Laser Diode Controller in MATLAB using SCPI commands

%   Specify resource name and vendor of driver
%
%   !!  Resource name is: USB0::0x1313::<type id>::<serial number>::0::INSTR
%   !!  Please change the type ID and the serial number corresponding to your device
%   !!
%   !!  Type ID:       0x8047    when firmware update is enabled (Menu > System Settings)
%   !!                 0x804F    when firmware update is disabled (Menu > System Settings)
%   !!  

cld_addr = 'USB0::0x1313::0x804F::M00459138::INSTR';
cld_vendor = 'NI';

%   Open VISA connection and set parameters
global cld;
cld = visa (cld_vendor, cld_addr);
fopen (cld);
set (cld, 'Timeout', 10);
set (cld, 'EOSMode', 'read');

% Add code needed to configure the unit correctly.

% Turn off photodiode functionality 
fprintf (cld, ':INP1:BIAS:STAT 0;:INP1:BIAS:VOLT:DC 0.0');

% Turn off amplitude modulation capability 
fprintf (cld, ':SOUR1:AM:STAT:AM 0');

% Switch LDD to constant current mode
fprintf (cld, ':SOUR1:FUNC:MODE CURR');

% Check Keylock status
% :OUTP1:PROT:KEYL:TRIP?
keylock_stat = str2double (query (cld, ':OUTP1:PROT:KEYL:TRIP?'));
disp(['Keylock Status: ', num2str(keylock_stat)]);
if keylock_stat == 1
    disp('Keylock is closed. Cannot output current.')
else
    disp('Keylock is open. Output current can be set.')
end

% Add code needed to engage LDD
% Specify current limit that can be applied across the diode
% limit value must be given in units of mA :SOUR1:CURR:LIM:AMPL %0.1fE-3
lddlimit = 500e-3; 
fprintf (cld, [':SOUR1:CURR:LIM:AMPL ', num2str(lddlimit)]);

% Set LDD current value to 0.0 mA 
lddcurrent = 0.0e-3; % LDD current ust be expressed in mA
fprintf (cld, [':SOUR1:CURR:LEV:AMPL ', num2str(lddcurrent)]);

% Ensure that LDD output is off, it can be turned on again later
fprintf (cld, ':OUTP1:STAT 0');

% Add code needed to engage TEC
% Switch TEC to temperature control mode with temperature in units of
% Celcius 
fprintf (cld, ':SOUR2:FUNC:MODE TEMP; :UNIT:TEMP C');

% Specify temperature calculation method for TEC
fprintf (cld, ':SENS2:TEMP:THER:METH EXP');

% Specify current limt that TEC can apply 
% TEC current limt is expressed in units of A
teclimit = 1.5; 
fprintf (cld, [':SOUR2:CURR:LIM ', num2str(teclimit)]);

% Specify temperature limit range for diode
tec_high_temp_lim = 35;
tec_low_temp_lim = 15;
fprintf (cld, [':SOUR2:CURR:UPP ', num2str(tec_high_temp_lim)]);
fprintf (cld, [':SOUR2:CURR:LIM ', num2str(tec_low_temp_lim)]);

% The next step is to engage the TEC
% It is not as simple as turning the TEC On / Off as TEC unit may already
% be On. The logic is as follows
% if TEC is ON, leave it on at its displayed temperature
% if TEC is OFF, turn it on to its displayed temperature, leave it
% stabilise, then specify the temperature you would like
% How do you get MATLAB to read info for a machine?
% The command to read the current TEC state is :OUTP2:STAT?
% if :OUTP2:STAT? == On
%   do nothing
%   change setpoint to T = 25 C :SOUR2:TEMP:SPO 25
% else
%   read current TEC temperature :SENS2:TEMP:DATA?
%   set TEC set point to current temperature :SOUR2:TEMP:SPO %0.2f
%   Turn on TEC :OUTP2:STAT 1
%   Allow TEC to stabilise temperature, it would be best if this was a 
%   fixed delay value. Can MATLAB induce a real time delay / pause?
%   Once stable, set new setpoint temperature, usually 25 C
%   :SOUR2:TEMP:SPO 25

% Add code to sweep over LDD current
% Add code to monitor diode temperature

%   Set TEC temperature and enable TEC
temp = 25;
fprintf (cld, ['SOURCE2:TEMPERATURE:SPOINT ', num2str(temp)]);
fprintf (cld, ':OUTPUT2:STATE ON');

%   Check if temperature is stabilized
value = str2double (query (cld, 'SENSE2:TEMPERATURE:DATA?'));
disp('Waiting until temperature is stabilized')
while (abs(temp-value)>0.5)
    value = str2double (query (cld, 'SENSE2:TEMPERATURE:DATA?'));
    disp(['Current TEC temperature: ', num2str(value)]);
    pause(1);
end;

value = str2double (query (cld, 'SENSE2:TEMPERATURE:DATA?'));
disp(['Current TEC temperature: ', num2str(value)]);

%   Set LD current limit in A
%fprintf(cld, 'SOURCE:LIMIT 0.060');
%   Set LD current setpoint in A
%fprintf(cld, 'SOURCE:LEVEL 0.050');
%   Switch on LD current
%fprintf(cld, 'OUTPUT1:STATE ON');

pause(5);

%   Switch off LD current
%fprintf(cld, 'OUTPUT1:STATE OFF');

%   Close VISA connection
disp ('Close VISA connection.');
fclose (cld);
delete (cld);
disp ('Connection closed successfully.');