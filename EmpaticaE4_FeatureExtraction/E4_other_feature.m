function mean_arr = E4_other_feature(data, fs, seg_size, data_id)
%This function takes the E4 sensor data (except EDA) and calculates mean features in a
%given non-overlapping segment size after denoising
% Args:
%    data: E4 data (except EDA) in Table format. It may or may not have timestamps
%    fs: Sampling rate (in Hz)
%    seg_size: length of non-overlapping segment (in seconds). If you want
%              to calculate for whole data, use 0.
%    data_id: Name of the data in excel sheet (column id)
% 
% Output:
%    mean_arr: Array of mean data for each segment in the whole signal


%   Time is calculated manually for if the data has no timestamp  
    if data.Properties.VariableNames{1} == "Time_s_"    %%%% MATLAB recognizes the parenthesis as _ in 'Time (s)'
        time = data.('Time_s_');
    else
        time = 0:1/fs:(height(data)-1)/fs;
    end
    
    if strcmp(data_id, 'ACC')   %%% If the sensor data is from Accelerometer, this codeblock calculates the L2 norm
        x = data.('x');
        y = data.('y');
        z = data.('z');
        e4_data = sqrt(x.^2 + y.^2 + z.^2);
    else
        e4_data = data.(data_id);
    end
    
    mean_arr = [];
    
    if (seg_size == 0)   %%%%%% If mean sensor values are required for the whole session
        mean_val = mean(e4_data);
        mean_arr=[mean_arr; mean_val];
        
    elseif (seg_size > 0) %%%%%% If mean sensor values are required for some non-overlapping segments over whole session
        start_idx = 1;
        end_idx = 0;
        timestamp = seg_size;

        while end_idx<(length(e4_data))
            idx_list = find(time<=timestamp);
            end_idx = idx_list(end);

            mean_val = mean(e4_data(start_idx:end_idx));
            mean_arr=[mean_arr; mean_val];

            start_idx = end_idx + 1;
            timestamp = timestamp + seg_size;
        end
        
    else   %%%% If segment size is negative, it is invalid
        disp('Invalid Segment size')

    end
end

