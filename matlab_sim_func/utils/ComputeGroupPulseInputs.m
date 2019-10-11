% Compute Group Pulse Linear Inputs Sources at current_time + step_size
% Inputs: 
%   InputSrc: all input sources in pulse format 
%   current_time: current time instant
%   step_size: 
%   end_time: the end of simulation time
%   TimeStamps: required time instants
% Outputs:
%   inputs: the input vector at time instant current_time + step_size
%   max_step_size: possible maximum step size
%   time_instants: required time instants
%   min_step_size: minimum step size
function [inputs max_step_size time_instants min_step_size] = ComputeGroupPulseInputs(InputSrc, current_time, step_size, end_time, TimeStamps)
    
    NumSrcs = size(InputSrc, 1);
    inputs = zeros(NumSrcs, 1);
    total_max_step = zeros(NumSrcs, 1);
    pre_inputs = zeros(NumSrcs, 1);

    diff_Tol = eps/100;
    
    %anchor the current time in TimeStamps
    for i = 1:length(TimeStamps)
        if (abs(current_time - TimeStamps(i)) <= diff_Tol)
            current_idx = i;
            break;
        end
    end

    max_step_size = step_size;
    for i = 1:NumSrcs
        t = current_time;
        lV = InputSrc(i, 1);
        hV = InputSrc(i, 2);
        tDelay = InputSrc(i, 3);
        tr = InputSrc(i, 4);
        tf = InputSrc(i, 5);
        PW = InputSrc(i, 6);
        Period = InputSrc(i, 7);
        lPW = Period - PW - tf - tr;

        %anchor current_time for InputSrc i
        if (t > tDelay)
            t = t - tDelay;
            numPeriod = ceil(t/Period)-1;
            t = t - numPeriod*Period;
            if (t > tr)
                t = t - tr;
                if (t > PW)
                    t = t - PW;
                    if (t > tf) %PW region at low
                        pre_inputs(i) = lV;
                        t = t - tf;
                        result = lV;
                        tmp = lPW - t;
                        if (tmp <= diff_Tol) %right at pivot point
                            tmp = tr;
                            result = hV;
                        end
                    else %falling region
                        pre_inputs(i) = hV + (lV-hV)/tf*t;
                        tmp = tf - t;
                        result = lV;
                        if (tmp <= diff_Tol) %right at pivot point
                            tmp = lPW;
                            result = lV;
                        end
                    end
                else %PW region at high
                    pre_inputs(i) = hV;
                    tmp = PW - t;
                    result = hV;
                    if (tmp <= diff_Tol) %right at pivot point
                        tmp = tf;                        
                        result = lV;
                    end
                end
            else %rising region
                pre_inputs(i) = lV + (hV-lV)/tr*t;                
                tmp = tr - t;
                result = hV;
                if (tmp <= diff_Tol) %right at pivot point
                    tmp = PW;
                    result = hV;
                end
            end
        else    %delay region
            pre_inputs(i) = lV;
            tmp = tDelay - t;
            result = lV;
            if (tmp <= diff_Tol) %right at pivot point
                tmp = tr;
                result = hV;
            end
        end

        %write the voltage at current_time 
        inputs(i) = result;
        total_max_step(i) = tmp;
        if (tmp < max_step_size)
            max_step_size = tmp;
        end
    end    
    
    %anchor current_time + max_step_size in TimeStamps
    for i = length(TimeStamps):-1:1
        if (abs(current_time + max_step_size - TimeStamps(i)) <= diff_Tol || ...
             current_time + max_step_size > TimeStamps(i))
             target_idx = i;
             max_step_size = TimeStamps(i) - current_time;
             break;
        end
    end
    
    %do the scaling
    inputs = pre_inputs+((inputs-pre_inputs)./total_max_step)*max_step_size;
    %inputs = inputs;

    %anchor current_time at TimeStamps
    idx = 1;
    prev_time = current_time;
    min_step_size = max_step_size;
    for i = current_idx+1:target_idx
        time_instants(idx) = TimeStamps(i);
        if (min_step_size > (TimeStamps(i) - prev_time))
            min_step_size = TimeStamps(i) - prev_time;
        end
        prev_time = TimeStamps(i);
        idx = idx + 1;
    end
end
