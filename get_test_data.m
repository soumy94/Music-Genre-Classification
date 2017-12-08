files = dir('./tracks/*.wav');
y = datasample(files,50,'Replace', false);
variables = who;
existingMusicFiles = {};
testdataFiles = {};
for i=1:length(variables)
    if strncmpi(variables(i), 'mfcc_', 5)==1
        existingMusicFiles = [existingMusicFiles variables(i)];
    end
end
for k=1:length(y)
    file = strcat('./tracks/',y(k).name);
    [~, name, ~] = fileparts(file);
    varname = ['mfcc_' name];
    if (ismember(varname, existingMusicFiles))
    else
        testdataFiles = [testdataFiles file];
    end
end
clearvars -except testdataFiles
save('./testdata/mfccResult/mfccResults_35.mat');
save('./testdata/pcaResult/pcaResults_35.mat');
for k=1: length(testdataFiles)
    file = cell2mat(testdataFiles(k));
    [~, name, ~] = fileparts(file);
    [mfcc_result,~] = mfcc_coeffs(file);
    varname = ['mfcc_' name];
    assignin('base', varname, mfcc_result);
    save('./testdata/mfccResult/mfccResults_35.mat', varname,'-append');
    clear varname
    varname = ['mfcc_' name];
    pcaData = DimensionReduction(mfcc_result, 'pca', 79);
    assignin('base', varname, pcaData);
    save('./testdata/pcaResult/pcaResults_35.mat', varname,'-append');    
end

