function [OutputSignal] = SmoothData(InputSignal,WindowLength)

InputSignal = reshape(InputSignal,[length(InputSignal) 1]);

OutputSignal1=conv(InputSignal,blackman(WindowLength),'valid');
%OutputSignal=conv(InputSignal,hanning(WindowLength),'same');
[OutputSignal1]=NormalizeZeroMeanOneStd(OutputSignal1);
OutputSignal1=ScaleAndShiftData(OutputSignal1,mean(InputSignal),std(InputSignal));

Part1=ceil(WindowLength/2);
Vq1 = interp1([1 Part1+1:Part1+length(OutputSignal1)]',[InputSignal(1);OutputSignal1],[2:Part1]');
Vq2 = interp1([1:Part1+length(OutputSignal1) length(InputSignal)]',[InputSignal(1);Vq1;OutputSignal1;InputSignal(end)],[Part1+length(OutputSignal1)+1:length(InputSignal)-1]');
OutputSignal = [InputSignal(1);Vq1;OutputSignal1;Vq2;InputSignal(end)];

% if sum(OutputSignal<0)>0
%     OutputSignal = OutputSignal+abs(min(OutputSignal));
% end
