function v = CLD1015_Qry_Key_Status(visObj, loud)
% Query the status of the CLD1015 Keylock
% output = 1 => keylock is closed => no current to diode possible
% output = 0 => keylock is open => current can flow across diode
% loud == 1 => print message to screen

v = str2double (query (visObj, ':OUTP1:PROT:KEYL:TRIP?'));

if loud == 1
    disp(['Keylock Status: ', num2str(v)]);
    if v == 1
        disp('Keylock is closed.')
    else
        disp('Keylock is open.')
    end
end