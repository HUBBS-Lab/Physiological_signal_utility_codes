function [NormalizedData MeanValue NormValue] = NormalizeZeroMeanOneStd(Data)
% [NormalizedData] = NormalizeZeroMeanOneStd(Data)
% normalizes vector or columns of matrix to have zero mean and unity
% standard deviation
% Data              : input data (vector or matrix)
% NormalizedData    : normalized data
% MeanValue         : mean value
% NormValue         : data norm


    if iscell(Data)
        NormalizedData = cell(1,length(Data));
        MeanValue = zeros(length(Data),size(Data{1},2));
        NormValue = zeros(length(Data),size(Data{1},2));
        for k=1:length(Data)
            [NormalizedData{k} MeanValue(k,:) NormValue(k,:)] = NormalizeZeroMeanOneStdInner(Data{k});
            %[NormalizedData1 MeanValue1 NormValue1] = NormalizeZeroMeanOneStdInner(Data{k});
        end
    else
        [NormalizedData MeanValue NormValue] = NormalizeZeroMeanOneStdInner(Data);
    end


function [NormalizedData MeanValue NormValue] = NormalizeZeroMeanOneStdInner(Data)
MeanValue = nanmean(Data);

if size(Data,1)>1 && size(Data,2)>1
    NormalizedData=Data-repmat(MeanValue,[size(Data,1) 1]);
    NormValue = sqrt(nansum(abs(NormalizedData).^2)/size(Data,1));
    NormalizedData=NormalizedData./repmat(NormValue,[size(NormalizedData,1) 1]);
else
    NormalizedData=Data-MeanValue;
    NormValue = sqrt(nansum(abs(NormalizedData).^2)/length(Data));
    NormalizedData=NormalizedData./NormValue;
end
end

end