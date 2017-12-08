files = dir('./tracks/*.wav');
y = datasample(files,100,'Replace', false);
filename = cell(1, length(y));
save('./mfccResult/mfccResults_100.mat');
for k=1:length(y)
    file = strcat('./tracks/',y(k).name);
    [~, name, ~] = fileparts(file);
    [mfcc_result,~] = mfcc_coeffs(file);
    varname = ['mfcc_' name];
    assignin('base', varname, mfcc_result);
    save('./mfccResult/mfccResults_100.mat', varname,'-append');
    clear mfcc_result file name varname
end