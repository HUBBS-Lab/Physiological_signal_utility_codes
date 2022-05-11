function [scl_arr, scramp_arr, scrfreq_arr] = E4_EDA_feature(eda, fs, seg_size, ledalab_dir)
%This function takes the VerBIO EDA data and calculates EDA features in a
%given non-overlapping segment size after denoising, outlier removal and smoothing.
%
% Args:
%    eda: eda data in Table format. It may or may not have timestamps
%    fs: Sampling rate (in Hz)
%    seg_size: length of non-overlapping segment (in seconds). If you want
%              to calculate for whole eda data, use 0.
%    ledalab_dir: Directory of Ledalab toolbox
% 
% Output:
%    scl_arr: Array of mean SCL for each segment in the whole signal
%    scramp_arr: Array of SCR amplitude for each segment throughout the signal
%    scrfreq_arr: Array of SCR frequency for each segment throughout the signal


%   Time is calculated manually for if the EDA data has no timestamp  
    if eda.Properties.VariableNames{1} == "Time"    %%%% MATLAB recognizes the parenthesis as _ in 'Time (s)'
        time = eda.('Time');
    else
        time = 0:1/fs:(height(eda)-1)/fs;
    end
    
    
    eda_data = eda.('EDA');
    B = filloutliers(eda_data,'linear','movmedian',48);  
    eda_smooth = SmoothData(B,8);  
    
    scl_arr = [];
    scramp_arr = [];
    scrfreq_arr = [];
    current_path = pwd;
    
    if (seg_size == 0)   %%%%%% If EDA features are required for the whole session
        scl = mean(eda_smooth);
        scl_arr = [scl_arr; scl];
        
        
        scrfreq= Ledalab_Freq(eda_smooth, fs, ledalab_dir);
        scrfreq_arr = [scrfreq_arr; scrfreq];
        cd(current_path)  %%% Because Ledalab changes directory for the calculation

        scramp= Ledalab_Amp(eda_smooth, fs, ledalab_dir);
        scramp_arr=[scramp_arr; scramp];
        cd(current_path)  %%% Because Ledalab changes directory for the calculation
        
    elseif (seg_size > 0)     %%%%%% If EDA features are required for some non-overlapping segments over whole session
        start_idx = 1;
        end_idx = 0;
        timestamp = seg_size;

        
        %%%%%% This loop iterates over the timestamp array and each time it
        %%%%%% calculates feature for each segment
        while end_idx<(length(eda_smooth))  
            idx_list = find(time<=timestamp);
            end_idx = idx_list(end);


            scl = mean(eda_smooth(start_idx:end_idx));
            scl_arr=[scl_arr; scl];

            scrfreq= Ledalab_Freq(eda_smooth(start_idx:end_idx), fs, ledalab_dir);
            scrfreq_arr = [scrfreq_arr; scrfreq];
            cd(current_path)  %%% Because Ledalab changes directory for the calculation


            scramp= Ledalab_Amp(eda_smooth(start_idx:end_idx), fs, ledalab_dir);
            scramp_arr=[scramp_arr; scramp];
            cd(current_path)   %%% Because Ledalab changes directory for the calculation
            

            
            start_idx = end_idx + 1;
            timestamp = timestamp + seg_size;

        end
        
        
    else   %%%% If segment size is negative, it is invalid
        disp('Invalid Segment size')
    end
end

