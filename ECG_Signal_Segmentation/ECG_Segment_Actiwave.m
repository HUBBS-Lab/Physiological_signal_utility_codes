clc;
clear;

samp_freq=512;

filename = "ExperimentTimesheet_Summer2021.csv";
Candidate = xlsread(filename,'A:A');

Actiwave_start=xlsread(filename,'G:G');
Baseline_beg = xlsread(filename,'K:K');
Baseline_end = xlsread(filename,'L:L');

Relaxation_beg = xlsread(filename,'O:O');
Relaxation_end = xlsread(filename,'P:P');

Interview_beg = xlsread(filename,'S:S');
Interview_end = xlsread(filename,'T:T');

path = "C:\CIBER Lab\VetTrain\Data_Summer 2021\ACTIWAVE\";

for count= 7 %1:length(Candidate)

    %------------------------------------------------------------------------------------------
    %Read ECG file for the candidate
    %------------------------------------------------------------------------------------------
    CandidateCount=Candidate(count);
    disp(CandidateCount)

    f1=FilenameDetect1(path,CandidateCount,"ECG");
    disp(f1)

    ECG = csvread(f1,9,0);
    ECG1=ECG(:,1);
    

    %------------------------------------------------------------------------------------------
    %Read ECG start time
    %------------------------------------------------------------------------------------------
 
    [h1,m1,s1] = hms(datetime(Actiwave_start(count),'ConvertFrom','datenum'));
    e4record = (h1*60*60)+(m1*60)+s1;
    
    %------------------------------------------------------------------------------------------
    %Baseline segment
    %------------------------------------------------------------------------------------------

    [h2,m2,s2] = hms(datetime(Baseline_beg(count),'ConvertFrom','datenum'));
    sec2 = (h2*60*60)+(m2*60)+s2;

    [h3,m3,s3] = hms(datetime(Baseline_end(count),'ConvertFrom','datenum'));
    sec3 = (h3*60*60)+(m3*60)+s3;

%    if sec2<e4record
%        sec2=e4record+1;
%    end
    firstindex = (sec2-e4record)*samp_freq; 
    secondindex = (sec3-e4record)*samp_freq;

    ECGBaseline = ECG1(firstindex:secondindex);
    
    f1=FilenameDetect1(path,CandidateCount,"ECG_Baseline");

    csvwrite(f1,ECGBaseline);


    %------------------------------------------------------------------------------------------
    %Relaxation segment
    %------------------------------------------------------------------------------------------

    [h2,m2,s2] = hms(datetime(Relaxation_beg(count),'ConvertFrom','datenum'));
    sec2 = (h2*60*60)+(m2*60)+s2;

    [h3,m3,s3] = hms(datetime(Relaxation_end(count),'ConvertFrom','datenum'));
    sec3 = (h3*60*60)+(m3*60)+s3;

%    if sec2<e4record
%        sec2=e4record+1;
%    end
    firstindex = (sec2-e4record)*samp_freq; 
    secondindex = (sec3-e4record)*samp_freq;

    ECGRelaxation = ECG1(firstindex:secondindex);
    
    f1=FilenameDetect1(path,CandidateCount,"ECG_Relaxation");

    csvwrite(f1,ECGRelaxation);
   
    %------------------------------------------------------------------------------------------
    %Interview segment
    %------------------------------------------------------------------------------------------

    [h2,m2,s2] = hms(datetime(Interview_beg(count),'ConvertFrom','datenum'));
    sec2 = (h2*60*60)+(m2*60)+s2;

    [h3,m3,s3] = hms(datetime(Interview_end(count),'ConvertFrom','datenum'));
    sec3 = (h3*60*60)+(m3*60)+s3;
    
    firstindex = (sec2-e4record)*samp_freq;
    secondindex = (sec3-e4record)*samp_freq;
    
    ECGInterview = ECG1(firstindex:secondindex);

    f1=FilenameDetect1(path,CandidateCount,"ECG_Interview");

    csvwrite(f1,ECGInterview);
    
end
