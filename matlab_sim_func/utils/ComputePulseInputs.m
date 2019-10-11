% Compute Pulse Linear Inputs Sources at current_time + step_size
% Inputs: 
%   SimParam: simulation parameter structure
%   current_time: current time instant
%   step_size: 
% Outputs:
%   inputs: the input vector at time instant current_time + step_size
%   max_step_size: possible maximum step size
function [inputs max_step_size] = ComputePulseInputs( SimParam, current_time, step_size)
    
    NumSrcs = size(SimParam.InputSrcs, 1);
    inputs = zeros(NumSrcs, 1);
    total_max_step = zeros(NumSrcs, 1);
    pre_inputs = zeros(NumSrcs, 1);

    end_time = SimParam.end_time;
    
    diff_Tol = eps/100;
    max_step_size = step_size;
    for i = 1:NumSrcs
        t = current_time;
        lV = SimParam.InputSrcs(i, 1);
        hV = SimParam.InputSrcs(i, 2);
        tDelay = SimParam.InputSrcs(i, 3);
        tr = SimParam.InputSrcs(i, 4);
        tf = SimParam.InputSrcs(i, 5);
        PW = SimParam.InputSrcs(i, 6);
        Period = SimParam.InputSrcs(i, 7);
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
    
    if ((current_time + max_step_size) - end_time > diff_Tol)
        max_step_size = end_time - current_time;
    end
    
    %do the scaling
    inputs = pre_inputs+((inputs-pre_inputs)./total_max_step)*max_step_size;
end
