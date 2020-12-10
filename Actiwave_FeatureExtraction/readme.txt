This folder contains simple code for extracting features from signals obtained through Actiwave sensors. Time- and Frequency-domain
features are extracted from ECG, while mean value are calculated for heart rate (HR) signal. These codes can calculate feature for 
whole signal (set seg_size = 0) or non-overlapping segments with given size (set a positive value for seg_size). A usage example is 
shown in the file. Please read the comments in the code. You need to install the following libraries-

BioSPPY: https://biosppy.readthedocs.io/en/stable/
pyhrv: https://pypi.org/project/pyhrv/
hrv-analysis: https://pypi.org/project/hrv-analysis/
