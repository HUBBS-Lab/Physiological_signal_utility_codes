clear all
close all
clc

data_dir = "./Sample Data/with_timestamp";
ledalab_dir = "E:/Toolboxes/Ledalab/ledalab-349";


%-----------------------------------------------------
% EDA signal: Feature extraction for the whole session
%-----------------------------------------------------

data_id = 'EDA';
fid = data_dir + '/' + data_id + '.xlsx';
data=readtable(fid);
fs = 4;   %%% check Empatica E4 manual/website for signal sampling rate
seg_size = 0;  %%%% seg_size is 0 if feature is calculated for whole session

[scl_arr, scramp_arr, scrfreq_arr] = E4_EDA_feature(data, fs, seg_size, ledalab_dir); %%%% These features can be saved into a csv or excel file



%-----------------------------------------------------
% EDA signal: Feature extraction for 15 second long 
% non-overlapping segments
%-----------------------------------------------------

data_id = 'EDA';
fid = data_dir + '/' + data_id + '.xlsx';
data=readtable(fid);
fs = 4;            %%% check Empatica E4 manual/website for signal sampling rate
seg_size = 15;  %%%% seg_size is 15 in this case

[scl_arr, scramp_arr, scrfreq_arr] = E4_EDA_feature(data, fs, seg_size, ledalab_dir); %%%% These features can be saved into a csv or excel file



%-----------------------------------------------------
% HR signal: Feature extraction for 10 second long 
% non-overlapping segments. In this example, there's no 
% timestamp in HR data
% Similar thing can be done for BVP, ACC, IBI, TEMP.
%-----------------------------------------------------
data_dir = "./Sample Data/without_timestamp";
data_id = 'HR';
fid = data_dir + '/' + data_id + '.xlsx';
data=readtable(fid);
fs = 1;          %%% check Empatica E4 manual/website for signal sampling rate
seg_size = 10;  %%%% seg_size is 10 in this case

HR_arr = E4_other_feature(data, fs, seg_size, data_id); %%%% These features can be saved into a csv or excel file
