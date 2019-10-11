% Compute Piece-wise Linear Inputs Sources at current_time + step_size
% Inputs: 
%   Simulation Parameter Struct
%   current_time: current time instant
%   step_size: target stepping size
% Outputs:
%   inputs: the input vector at time instant current_time + step_size
%   max_step_size: possible maximum step size
function [inputs max_step_size] = ComputePWLInputs(SimParam, current_time, step_size)

    numSrcs = length(SimParam.InputSrcs);
    time_anchor = zeros(1, numSrcs);
    inputs = zeros(numSrcs, 1);
    diffTol = eps/1000;
    
    %anchor current time in each input sources
    for i = 1:numSrcs
        time = SimParam.InputSrcs{i}{1};
        n = length(time);
        for j = 1:n-1
            if ((abs(time(j) - current_time) < diffTol || (current_time - time(j) > 0)) ...
                && time(j+1) - current_time > eps/1000)
                time_anchor(i) = j;
                break;
            end
        end
        %case when current_time is larger than the last time stamp of pwl input
        if (current_time >= time(n))
            time_anchor(i) = n;
        end
    end

    %check the maximum possible step size
    max_step_size = step_size;
    for i = 1:numSrcs
        time = SimParam.InputSrcs{i}{1};
        idx = time_anchor(i);
        %diff of at last time stamp is end_time to current_time
        if (idx == length(time))
            diff = SimParam.end_time - current_time;
        else
            diff = time(idx+1) - current_time;
        end
        %find minimum one 
        if (diff < max_step_size)
            max_step_size = diff;
        end
    end

    %adjust the step size according to maximum possible step size
    if (max_step_size < step_size)
        step_size = max_step_size;
    end

    %project the inputs in current_time + step_size
    for i = 1:numSrcs
        time = SimParam.InputSrcs{i}{1};
        voltage = SimParam.InputSrcs{i}{2};
        idx = time_anchor(i);
        if (idx == length(voltage))
            next_time = SimParam.end_time;
            next_voltage = voltage(idx);
        else
            next_time = time(idx+1);
            next_voltage = voltage(idx+1);
        end
        slope = next_voltage - voltage(idx);
        if (next_time - time(idx) <= diffTol) %actually no diff
            slope = 0;
        else
            slope = slope / (next_time - time(idx));
        end
        project_val = voltage(idx) + slope * (current_time + step_size - time(idx));

        inputs(i) = project_val;
    end

end
