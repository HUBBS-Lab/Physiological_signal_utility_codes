# =============================================================================
# This code calculates the time-domain and frequency-domain feature
# sets, as well as, mean heart rate (HR) from VerBIO actiwave data for provided
# segment size. 
# Feature extraction steps-
# 1. R-peak detection (BioSPPY)
# 2. NN-interval calculation (pyhrv)
# 3. HRV features from NN-intervals (hrvanalysis)
# =============================================================================

import biosppy
# from biosppy import storage
from biosppy.signals import ecg
import numpy as np
import pyhrv.tools as tools
import hrvanalysis 
import pandas as pd 
import os


def extract_ecg_feature(ecg_data, ecg_time, fs, seg_size):
    """This function takes the ecg file from verbio data and calculates the time 
    domain and frequency domain features for each segment
    
    
    Args:
        ecg_data : numpy array of ecg data
        ecg_time : numpy array of corresponding timestamps
        fs       : Sampling rate of ECG signal (in Hz)
        seg_size : Feature semgment length in seconds. If 0, it calculates feature for whole session.
                   If negative, it will raise an exception

        
    Returns:
       TDF_df : Time domain features dataframe, where each row contains feature for a segment
       FDF_df : Frequency domain features dataframe, where each row contains feature for a segment
    """
    
    timestamp = 0
    start_idx = 0
    row_val = 0
    
    if seg_size > 0:   ### For positive segment size
        timestamp = 0
        start_idx = 0
        row_val = 0
        while timestamp < ecg_time[-1]:
            timestamp = timestamp + seg_size
            
            if timestamp > ecg_time[-1]:
                timestamp = ecg_time[-1]
                
                
            end_idx = np.where(ecg_time<=timestamp)[0][-1] + 1
            
            seg_data = ecg_data[start_idx:end_idx]
            
            signal, rpeaks = biosppy.signals.ecg.ecg(seg_data,sampling_rate=fs, show=False)[1:3]  #### Denoising and R-R peak detection
    
        
            nni = tools.nn_intervals(rpeaks) #### This gives sample index, not timestampl
            
            rr = ecg_time[rpeaks]*1000   ##### sample number to timestamp (ms) conversion
            rri = tools.nn_intervals(rr)


            rri=hrvanalysis.preprocessing.remove_outliers(rr_intervals = rri)

            rri = hrvanalysis.preprocessing.interpolate_nan_values(rr_intervals=rri)
            nn_intervals_list = hrvanalysis.preprocessing.remove_ectopic_beats(rr_intervals=rri, method="malik")
            nni = hrvanalysis.preprocessing.interpolate_nan_values(rr_intervals=nn_intervals_list)

            
            TDF = hrvanalysis.get_time_domain_features(nni)  
            FDF = hrvanalysis.get_frequency_domain_features(nni)
            
            if timestamp == seg_size:
                TDF_df = pd.DataFrame(TDF, index=[row_val])
                FDF_df = pd.DataFrame(FDF, index=[row_val])
            else:
                TDF_df.loc[row_val] = list(TDF.values())
                FDF_df.loc[row_val] = list(FDF.values())
                                        
            
            row_val = row_val+1
            start_idx = end_idx
            
    elif seg_size == 0:
        signal, rpeaks = biosppy.signals.ecg.ecg(ecg_data,sampling_rate=fs, show=False)[1:3]
        nni = tools.nn_intervals(rpeaks) #### This gives sample index, not timestamp
        
        rr = ecg_time[rpeaks]*1000   ##### sample number to timestamp (ms) conversion
        rri = tools.nn_intervals(rr)


        rri=hrvanalysis.preprocessing.remove_outliers(rr_intervals = rri)

        rri = hrvanalysis.preprocessing.interpolate_nan_values(rr_intervals=rri)
        nn_intervals_list = hrvanalysis.preprocessing.remove_ectopic_beats(rr_intervals=rri, method="malik")
        nni = hrvanalysis.preprocessing.interpolate_nan_values(rr_intervals=nn_intervals_list)

            
        TDF = hrvanalysis.get_time_domain_features(nni)
        FDF = hrvanalysis.get_frequency_domain_features(nni)
        
        TDF_df = pd.DataFrame(TDF, index=[0])
        FDF_df = pd.DataFrame(FDF, index=[0])
        
    else:
        raise Exception('Invalid Segment Size')
        
        
    return TDF_df, FDF_df




def mean_hr(hr_data, hr_time, seg_size):
    """This function takes the HR file from verbio data and calculates mean HR for each feature segment
    
    Args:
        hr_data : numpy array of heart rate data
        hr_time : numpy array of corresponding timestamps
        seg_size : Feature semgment length in seconds. If 0, it calculates feature for whole session.
                   If negative, it will raise an exception

        
    Returns:
       hr_df : mean HR dataframe where each row contains mean HR for a segment

    """
    mean_HR = []
    
    if seg_size > 0:    ### For positive segment size
        timestamp = 0
        start_idx = 0
    
        while timestamp < hr_time[-1]:
            timestamp = timestamp + seg_size
            
            if timestamp > hr_time[-1]:
                timestamp = hr_time[-1]
                
                
            end_idx = np.where(hr_time<=timestamp)[0][-1] + 1
            
            seg_data = hr_data[start_idx:end_idx]
            
            mean_HR.append(np.mean(seg_data))
            
            start_idx = end_idx
            
    elif seg_size == 0:   ### For whole session
        mean_HR.append(np.mean(hr_data))
        
    else:
        raise Exception('Invalid Segment Size')
        
   
    meanHR_df = pd.DataFrame(mean_HR, columns = ['mean_hr']) 
    
    
    return meanHR_df



######## Sample Use Cases##########
    

    
data_dir = f'./Sample Data/with_timestamp'
ecg_fid = f'{data_dir}/ECG.xlsx'
hr_fid = f'{data_dir}/HR.xlsx'


ecg_fs = 512     #### Check from actiwave device manual
hr_fs = 1       

seg_size = 30 ### For very small segment size, time dormain and freq domain features might not be available.
        

ecg_df = pd.read_excel(ecg_fid)
ecg_signal = ecg_df['ECG'].to_numpy()

hr_df = pd.read_excel(hr_fid)
hr_signal = hr_df['HR'].to_numpy()

#### This block checks whethere the data has timestamp or not. If there's no timestamp, it manually creates a time array
#### using  sampling rate

try:
    ecg_time = ecg_df['Time (s)'].to_numpy()
    hr_time = hr_df['Time (s)'].to_numpy()
except:
    ecg_time = np.arange(0, len(ecg_signal)/ecg_fs, 1/ecg_fs)   #### fs = 512 Hz
    hr_time = np.arange(0, len(hr_signal)/hr_fs, 1/hr_fs)   #### fs = 1 Hz
        


#### Feature dataframes, which can be saved in excel/csv format
TDF_df, FDF_df = extract_ecg_feature(ecg_signal, ecg_time, ecg_fs, seg_size)
meanHR_df = mean_hr(hr_signal, hr_time, seg_size)
