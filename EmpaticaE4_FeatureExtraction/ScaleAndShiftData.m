function [ScaledShiftedData] = ScaleAndShiftData(Data,MeanShift,ScaleFactor)
% [ScaledShiftedData] = ScaleAndShiftData(Data,MeanShift,ScaleFactor)
% scales and shifts vector or columns of matrix to have the desired mean
% and standard deviation
% Data                  : input data (vector or matrix)
% MeanShift             : desired shift
% ScaleFactor           : desired scale factor
% ScaledShiftedData     : scaled and shifted data

if size(Data,1)>1 && size(Data,2)>1
    ScaledShiftedData=Data.*repmat(ScaleFactor,[size(Data,1) 1]);
    ScaledShiftedData=ScaledShiftedData+repmat(MeanShift,[size(ScaledShiftedData,1) 1]);
else
    ScaledShiftedData = Data*ScaleFactor;
    ScaledShiftedData = ScaledShiftedData+MeanShift;
end