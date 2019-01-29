function CLD1015_Set_TEC_Status(visObj, status)
% specify the status of the CLD1015 TEC
% status == 1 => TEC should turn on
% status == 0 => TEC should turn off
% R. Sheehan 28 - 1 - 2019

if status == 1
    fprintf (visObj, ':OUTPUT2:STATE ON');
else
    fprintf (visObj, ':OUTPUT2:STATE OFF');
end

end