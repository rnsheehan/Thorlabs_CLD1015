function v = CLD1015_LDD_Optical_Sweep(visObj, pmObj, cldStatus, Iinit, Ifinal, Iincre)
% sweep the LDD from Iinit to Ifinal in steps of Iincre
% save the current and voltage data at each step
% R. Sheehan 29 - 1 - 2019

swps = Validate_Sweep_Params(Iinit, Ifinal, Iincre);

if cldStatus(1) == 0 && cldStatus(2) == 1 && cldStatus(3) == 1 && swps(1) == True
    disp('Sweep can proceed')
    % Write code to sweep LDD current, Measure voltage at each
    % sweep step
    CLD1015_Set_LDD_Status(visObj, 1); % ensure that LDD is switched on
    
    Ivals = zeros(swps(2), 1); 
    Vvals = zeros(swps(2), 1); 
    Pvals = zeros(swps(2), 1); 
    
    Iset = min(Iinit, Ifinal); 
    for i = 1:swps(2)
        CLD1015_Set_LDD_Curr(visObj, Iset); % set current value
        Ivals(i) = CLD1015_Qry_Ival(visObj); % read true current across LDD
        Vvals(i) = CLD1015_Qry_Vval(visObj); % read voltage across LDD
        power = PM100D_Read_Power_Average(pmObj, 11); % take an average of a set of powers readings
        %Pvals(i) = power(1); % record power in mW scale
        Pvals(i) = power(3); % record power in dBm scale        
        Iset = Iset + Iincre;
    end
    
    CLD1015_Dialdown_LDD_Curr(visObj); % Dial the current down after the sweep
    CLD1015_Set_LDD_Status(visObj, 0); % turn the LDD off
    
    v = [Ivals, Vvals, Pvals]; 
else
    disp('Sweep cannot proceed');
    disp('Sweep parameters not valid');
    v = [zeros(1,1), zeros(1,1)]; 
end

end