looper = 1;
classes = 6;
final_results = cell(8,2);
f = {};
f.classNames = {'classical','electronic','jazz_blues','metal_punk','rock_pop','world'};
f.features = {[],[],[],[],[],[]};
load('./pcaResult/meanValues.mat');
load_ground_truth;
variables = who;
variables_90_percent = datasample(variables,656,'Replace', false);
variables_10_percent = setdiff(variables, variables_90_percent);
bestCm = zeros(classes,classes);
bestC = 1;

for K_n=1:2:15
    % Training Data
    for i=1:length(variables_90_percent)
        if strncmpi(variables_90_percent{i}, 'mfcc_', 5)==1

           % find song type, find index in song, and get corresponding index value
           % from type
           temp = strrep(variables_90_percent{i}, 'mfcc_', '');
           filename = strcat('tracks/', temp);
           filename = strcat(filename, '.mp3');

           songid = findPosition(song, filename);
           typeid = findPosition(f.classNames, type(songid));

           typeMat = cell2mat(f.features(typeid));
           [rows, cols] = size(typeMat);

           content = load('./pcaResult/meanValues.mat', variables_90_percent{i});
           varialbeMatrix = getfield(content, variables_90_percent{i});
           
           typeMat(:, cols+1) = varialbeMatrix;
           f.features(typeid) = {typeMat};
        end
    end
    
    allCounts = zeros(1,classes);
    actualResult = [];
    for i=1:length(variables_10_percent)
        if strncmpi(variables_10_percent{i}, 'mfcc_', 5)==1

           % find song type, find index in song, and get corresponding index value
           % from type
           temp = strrep(variables_10_percent{i}, 'mfcc_', '');
           filename = strcat('tracks/', temp);
           filename = strcat(filename, '.mp3');

           songid = findPosition(song, filename);
           typeid = findPosition(f.classNames, type(songid));
           allCounts(typeid) = allCounts(typeid)+1;
           actualResult = vertcat(actualResult,typeid);
        end
    end
    
    clearvars -except f variables_10_percent variables_90_percent K_n looper final_results classes allCounts actualResult bestC bestCm 
           
    % Testing Data
    verification = cell(length(variables_10_percent),2);
    for i=1:length(variables_10_percent)
        if strncmpi(variables_10_percent{i}, 'mfcc_', 5)==1
           temp = load('./pcaResult/meanValues.mat', variables_10_percent{i});
           varialbeMatrix = getfield(temp, variables_10_percent{i});
           % Classifying
           [~,winnerClass] = classify('knn', f, varialbeMatrix, K_n);
           temp = strrep(variables_10_percent{i}, 'mfcc_', '');
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
    bestPrediction = [];
    for k=1: length(result)
        rowContent = result(k,:);
        bestPrediction = [bestPrediction rowContent{2}];
        songid = findPosition(song, rowContent{1});
        typeid = findPosition(f.classNames, type(songid));
        if(typeid==rowContent{2})
            counter = counter + 1;
        end
    end
    accuracy = counter/length(result);
    final_results(looper,1) = {K_n};
    final_results(looper,2) = {accuracy};
    looper = looper+1;
    
    bestPrediction = bestPrediction.';
    if(size(actualResult,1)< size(bestPrediction,1))
        targetVector = zeros(classes, size(actualResult,1));
        outputs = zeros(classes, size(actualResult,1));
        
        for i=1:size(actualResult,1)
            typeid = actualResult(i,1);
            targetVector(typeid,i) = 1;
        end
        for i=1:size(actualResult,1)
            typeid = bestPrediction(i,1);
            outputs(typeid,i) = 1;
        end
    else
        targetVector = zeros(classes, size(bestPrediction,1));
        outputs = zeros(classes, size(bestPrediction,1));
        for i=1:size(bestPrediction,1)
            typeid = actualResult(i,1);
            targetVector(typeid,i) = 1;
        end
        for i=1:size(bestPrediction,1)
            typeid = bestPrediction(i,1);
            outputs(typeid,i) = 1;
        end
    end
    
    [c,cm,ind,per] = confusion(targetVector,outputs);
    for i=1:classes
        for j=1:classes
            cm(i,j) = cm(i,j)/allCounts(i);
        end
    end
    if c<bestC
        bestC = c;
        for i=1:classes
            for j=1:classes
                bestCm(i,j) =  round(cm(i,j),4);
            end
        end
    end
end