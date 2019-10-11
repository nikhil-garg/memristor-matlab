% Generate Time Stamps for Group Current Sources
% Inputs:
%   SimParam: simulation parameter structure
%   start_time: starting time
% Outputs:
%   TimeStamps: required time instants
function [TimeStamps] = GenerateTimeStampsForGroups(SimParam, start_time)

    current_time = start_time;
    end_time = SimParam.end_time;
    step_size = SimParam.step_size;
    idx = 1;
    TimeStamps(idx) = current_time;
    while (current_time < end_time)

        [dummy max_step_size] = ComputePulseInputs( SimParam, current_time, step_size);
        current_time = current_time + max_step_size;        
        idx = idx + 1;
        TimeStamps(idx) = current_time;
    end
end
