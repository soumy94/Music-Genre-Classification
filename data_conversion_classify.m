% Training Data
f = {};
f.classNames = {'classical','electronic','jazz_blues','metal_punk','rock_pop','world'};
f.features = {[],[],[],[],[],[]};
load('/Users/soumy/Documents/highdimensional/pcaResult/pcaResults_100.mat');
load_ground_truth;
variables = who;

for i=1:length(variables)
    if strncmpi(variables(i), 'mfcc_', 5)==1
       
       % find song type, find index in song, and get corresponding index value
       % from type
       temp = strrep(variables(i), 'mfcc_', '');
       filename = strcat('tracks/', temp);
       filename = strcat(filename, '.mp3');
       
       songid = findPosition(song, filename);
       typeid = findPosition(f.classNames, type(songid));
       
       typeMat = cell2mat(f.features(typeid));
       [rows, cols] = size(typeMat);
       
       varialbeMatrix = eval(char(variables(i)));
       typeMat(:, cols+1) = varialbeMatrix(:,1);
       f.features(typeid) = {typeMat};
    end
end

clearvars -except f
% Testing Data
load('Users/soumy/Documents/highdimensional/testdata/pcaResult/pcaResults_35.mat');
variables = who;
testsample = [];
verification = cell(length(variables),2);
for i=1:length(variables)
    if strncmpi(variables(i), 'mfcc_', 5)==1
       varialbeMatrix = eval(char(variables(i)));
       % Classifying
        [~,winnerClass] = classify('knn', f, varialbeMatrix(:,1));
        temp = strrep(variables(i), 'mfcc_', '');
        filename = strcat('tracks/', temp);
        filename = strcat(filename, '.mp3');
        verification{i, 1} = filename;
        verification{i, 2} = winnerClass;
    end
end
testresults = verification.';
result = reshape(testresults(~cellfun(@isempty,testresults)),2, [])';

%Accuracy
counter = 0;
load_ground_truth;
for k=1: length(result)
    rowContent = result(k,:);
    songid = findPosition(song, rowContent{1});
    typeid = findPosition(f.classNames, type(songid));
    if(typeid==rowContent{2})
        counter = counter + 1;
    end
end
accuracy = counter/length(result);
disp(accuracy);