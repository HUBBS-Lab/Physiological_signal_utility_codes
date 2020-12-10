This folder contains simple code for extracting features from signals obtained through Empatica E4 sensors. SCL and SCR metrics
are calculated for denoised and smoothed EDA signal using E4_EDA_feature() function. This functions requires Ledalab to be installed 
and its path to be in MATLAB directory. Other signals (e.g. BVP,ACC,IBI,HR, TEMP) are processed using E4_other_feature() function. Simple
mean value is calculated for them. These codes can calculate feature for whole signal (set seg_size = 0) or non-overlapping segments with 
given size (set a positive value for seg_size). A usage example is shown in sample_main.m file. Please read the comments in the three 
mentioned files. Others are utility functions.