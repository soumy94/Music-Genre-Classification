files = dir('./tracks/*.wav');
filename = cell(1, length(files));
%save('mfccResults.mat');
save('./pcaResult/pcaResults.mat');
for k = 1:length(files)
    file = strcat('./tracks/',files(k).name);
    [~, name, ~] = fileparts(file);
    [mfcc_result,~] = mfcc_coeffs(file);
    pcaData = real(DimensionReduction(mfcc_result, 'pca', 79));
    varname = ['mfcc_' name];
    assignin('base', varname, pcaData);
    save('./pcaResult/pcaResults.mat', varname, '-append');
    clear mfcc_result file name varname pcaData
    disp(k);
end

