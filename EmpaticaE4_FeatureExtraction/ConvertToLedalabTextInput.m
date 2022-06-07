function [] = ConvertToLedalabTextInput(Data,OutputFilename)
fid=fopen(OutputFilename,'w');
% fprintf(fid,'%.6f\t%.3f\t%d\n',Data');
fprintf(fid,'%.6f\t%.3f\n',Data');
fclose(fid);