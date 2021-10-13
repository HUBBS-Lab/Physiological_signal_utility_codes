    function [foutput] = FilenameDetectEDA1(path,CandidateCount,E4type)
    if(CandidateCount<10)
        foutput = path+"VetTrain_P00"+CandidateCount+"_Actiwave/"+"VetTrain_P00"+CandidateCount+"_Actiwave_"+E4type+".csv";
    else(CandidateCount>10)
        foutput = path+"VetTrain_P0"+CandidateCount+"_Actiwave/"+"VetTrain_P0"+CandidateCount+"_Actiwave_"+E4type+".csv";   
    end