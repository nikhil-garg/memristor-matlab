% Load inputs file
% Inputs:
% Outputs:
function [B InputSrcs] = LoadInputFile(filename, max_node_num)
    
    fprintf('loading PWL input file %s\n', filename);
    
    fid = fopen(filename, 'r');
    InputSrcs = {};

    numSrcs = 0;
    %get rid of comments
    while 1
        line = fgetl(fid);
        if (~ischar(line))
            error('incorrect input format\n');
        end

        %ignore comments
        if (isempty(line) == 0)
            ch1 = line(1);
            if (strcmp(ch1, '#'))
                continue;
            else
                break;
            end
        end
    end
	
    %read sources
    if (numSrcs == 0)
        numSrcs = sscanf(line, '%d');
        if (numSrcs == 0)
            error('incorrect input format');
        end
        B = sparse(max_node_num, numSrcs);
        %read each input sources
        i = 1;
        while 1
            line = fgetl(fid);
            
            %end of file
            if (~ischar(line))
                break;
            end
            
            %ignore comments
            ch1 = line(1);
            if (strcmp(ch1, '#'))
                continue;
            end
            node = sscanf(line, '%d %d');
            if (length(node) ~= 2)
                error('incorrect input format');
            end

            %read the pair
	    if (node(1) ~= 0)
		B(node(1), i) = -1; 
	    end
	    if (node(2) ~= 0)
		B(node(2), i) = 1;
	    end
	    idx = 1;
            time = []; voltage = [];
            while 1
                line = fgetl(fid);

                %ignore comments
                ch1 = line(1);
                if (strcmp(ch1, '#'))
                    continue;
                end

                temp = sscanf(line, '%f');
                if (length(temp) ~= 2) %end of current input source
                    break;
                end
                time(idx) = temp(1);
                voltage(idx) = temp(2);
                idx = idx + 1;
            end
            InputSrcs{i}{1} = time;
            InputSrcs{i}{2} = voltage;
            i = i + 1;
        end
    end

end
