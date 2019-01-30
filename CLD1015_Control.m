% Script for interfacing to Thorlabs CLD1015
% Set the temperature of the device
% Set the current flowing through the diode
% R. Sheehan 28 - 1 - 2019

 addpath(genpath('c:/Users/Robert/Programming/MATLAB/Common/'))

%   Specify resource name and vendor of driver
cld_addr = 'USB0::0x1313::0x804F::M00459138::INSTR';
cld_vendor = 'NI';

% Open VISA connection and set parameters for CLD1015
visObj = visa (cld_vendor, cld_addr);
fopen (visObj);
set (visObj, 'Timeout', 10);
set (visObj, 'EOSMode', 'read');

% Configure the LDD and TEC, TEC operational on routine complete
CLD1015_Configure(visObj);

% Decide whether or not to include Thorlabs power meter
include_power_meter = True;

if include_power_meter
    % Open VISA connection and set parameters for PM100D
    pm_addr = 'USB0::0x1313::0x8078::P0010046::INSTR';
    pm_vendor = 'NI';

    pmObj = visa (pm_vendor, pm_addr);
    fopen (pmObj);
    set (pmObj, 'Timeout', 10);
    set (pmObj, 'EOSMode', 'read');
end

% Simple menu allows you to operate the CLD1015 continuously
% Define options for menu
start = 'Options:\n';
option1 = 'Set Temperature Input = 1\n'; % Change temperature
option6 = 'Turn LDD On Input = 2\n'; 
option7 = 'Turn LDD Off Input = 3\n';
option2 = 'Set LDD current Input = 4\n'; % Change current, Keylock must be open
option3 = 'ReSet LDD current to zero Input = 5\n'; % Reset current, Keylock must be open
option5 = 'Perform Current Sweep Input = 6\n'; % Power Sweep, Keylock must be open
option8 = 'Perform Optical Power Sweep Input = 7\n'; % Power Sweep, Keylock must be open
option4 = 'End program Input = -1\n';
message = 'Input: ';
newline = '\n';
prompt = strcat(newline, start, option1, option6, option7, option2, option3, option5, option8, option4, newline, message);

% Read some numbers from the device to use during continuous operation
Tlimits = CLD1015_TEC_Qry_T_Limits(visObj); % read T bounds
Ilimit = CLD1015_Qry_LDD_Curr_Lim(visObj); % read I upper bound

cldStatus = CLD1015_Status(visObj); % record the status of the key, LDD, TEC

% Start continuous operation
do = true;
while do
    action = input(prompt);
    if action == -1
        disp('End Program');
        do = false;
    elseif action == 1
        disp('Change temperature to some value within specified Bounds')
        disp(['Low Temperature Bound: ', num2str(Tlimits(1))]);
        disp(['High Temperature Bound: ', num2str(Tlimits(2))]);
        Tset = input('Desired Temperature Value: ');
        CLD1015_Set_TEC_Temp(visObj, Tset)
        disp(['New temperature value: ', num2str(CLD1015_TEC_Qry_Tval(visObj))]);
    elseif action==2
        disp('Switch LDD On')
        CLD1015_Set_LDD_Status(visObj, 1);
        cldStatus = CLD1015_Status(visObj); % update the LDD status
    elseif action == 3
        disp('Switch LDD Off')
        CLD1015_Set_LDD_Status(visObj, 0);
        cldStatus = CLD1015_Status(visObj); % update the LDD status
    elseif action == 4
        disp('Change LDD current to some value within specified Bounds')
        disp('Low Current Bound: 0.0');
        disp(['High Current Bound: ', num2str(Ilimit)]);
        Iset = input('Desired Current Value: ');
        CLD1015_Set_LDD_Curr(visObj, cldStatus, Iset); 
        disp(['New Current Value: ', num2str(CLD1015_LDD_Qry_Ival(visObj))]);
        disp(['New Voltage Value: ', num2str(CLD1015_LDD_Qry_Vval(visObj))]);
    elseif action == 5
        disp('Reset LDD Current to Zero');
        CLD1015_Dialdown_LDD_Curr(visObj, cldStatus); 
    elseif action == 6
        disp('Power Sweep\n');
        Is = input('Input Current Start: ');
        If = input('Input Current End: ');
        Iinc= input('Input Current increment: ');
        % sweep the IV data
        swp_data = CLD1015_LDD_Sweep(visObj, cldStatus, Is, If, Iinc);
        if size(swp_data(1)) > 1 && size(swp_data(2)) > 1
            % make a plot of the IV data
            figure
            plot(swp_data(1), swp_data(2), 'g--o')
            xlabel('Current (mA)')
            ylabel('Voltage (V)')
        end
    elseif action == 7
        if include_power_meter
            % sweep can proceed
            disp('Power Sweep\n');
            Is = input('Input Current Start: ');
            If = input('Input Current End: ');
            Iinc= input('Input Current increment: ');
        else
            disp('Optical power sweep cannot proceed')
            disp('Thorlabs PM100D has not been initialised')
        end
    else
        action = input(prompt); % Takes you back to start of menu
    end
end

% Dial current back to zero mA
% Switch off LDD before closing
% Default should be that TEC is left operational all the time 
CLD1015_Set_LDD_Status(visObj, 0); 

%   Close VISA connection
disp ('Close VISA connection.');
fclose (visObj);
delete (visObj);
disp ('Connection closed successfully.');