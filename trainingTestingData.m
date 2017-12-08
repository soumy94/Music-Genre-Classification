f = {};
f.classNames = {'classical','electronic','jazz_blues','metal_punk','rock_pop','world'};
f.features = {[],[],[],[],[],[]};
load('./pcaResult/pcaResults.mat');
load_ground_truth;
variables = who;
trainingData = [];
testingData = [];
class_1 = [];
class_2 = [];
class_3 = [];
class_4 = [];
class_5 = [];
class_6 = [];
looper = 1;
final_results = cell(8,2);
for i=1:length(variables)
   if strncmpi(variables{i}, 'mfcc_', 5)==1
        temp = strrep(variables{i}, 'mfcc_', '');
        filename = strcat('tracks/', temp);
        filename = strcat(filename, '.mp3');
        songid = findPosition(song, filename);
        typeid = findPosition(f.classNames, type(songid));
        if(typeid==1)
            class_1 = [class_1;{strcat('mfcc_',temp)}];
        end
        if(typeid==2)
            class_2 = [class_2;{strcat('mfcc_',temp)}];
        end
        if(typeid==3)
            class_3 = [class_3;{strcat('mfcc_',temp)}];
        end
        if(typeid==4)
            class_4 = [class_4;{strcat('mfcc_',temp)}];
        end
        if(typeid==5)
            class_5 = [class_5;{strcat('mfcc_',temp)}];
        end
        if(typeid==6)
            class_6 = [class_6;{strcat('mfcc_',temp)}];
        end
   end
end

percent = 0.8;
variables_90_percent = datasample(class_1,ceil(percent*length(class_1)),'Replace', false);
variables_10_percent = setdiff(class_1, variables_90_percent);
trainingData = vertcat(trainingData,variables_90_percent);
testingData = vertcat(testingData, variables_10_percent);

variables_90_percent = datasample(class_2,ceil(percent*length(class_2)),'Replace', false);
variables_10_percent = setdiff(class_2, variables_90_percent);
trainingData = vertcat(trainingData,variables_90_percent);
testingData = vertcat(testingData, variables_10_percent);

variables_90_percent = datasample(class_3,ceil(percent*length(class_3)),'Replace', false);
variables_10_percent = setdiff(class_3, variables_90_percent);
trainingData = vertcat(trainingData,variables_90_percent);
testingData = vertcat(testingData, variables_10_percent);

variables_90_percent = datasample(class_4,ceil(percent*length(class_4)),'Replace', false);
variables_10_percent = setdiff(class_4, variables_90_percent);
trainingData = vertcat(trainingData,variables_90_percent);
testingData = vertcat(testingData, variables_10_percent);

variables_90_percent = datasample(class_5,ceil(percent*length(class_5)),'Replace', false);
variables_10_percent = setdiff(class_5, variables_90_percent);
trainingData = vertcat(trainingData,variables_90_percent);
testingData = vertcat(testingData, variables_10_percent);

variables_90_percent = datasample(class_6,ceil(percent*length(class_6)),'Replace', false);
variables_10_percent = setdiff(class_6, variables_90_percent);
trainingData = vertcat(trainingData,variables_90_percent);
testingData = vertcat(testingData, variables_10_percent);

clearvars -except f trainingData testingData final_results looper
