bestAccuracy = 0;
classes = 6;
bestCm = zeros(classes,classes);
bestC = 1;
times = 10;
for loops=1:times
    load('./pcaResult/meanValues.mat');
    load_ground_truth;
    variables = who;
    f = {};
    f.classNames = {'classical','electronic','jazz_blues','metal_punk','rock_pop','world'};
    features = [];
    labels = [];
    variables_90_percent = datasample(variables,584,'Replace', false);
    variables_10_percent = setdiff(variables, variables_90_percent);
    reducer = 0;
    actualResult = [];
    for i=1:numel(variables_90_percent)
        if strncmpi(variables_90_percent{i}, 'mfcc_', 5)==1
            temp = strrep(variables_90_percent{i}, 'mfcc_', '');
            filename = strcat('tracks/', temp);
            filename = strcat(filename, '.mp3');
            songid = findPosition(song, filename);
            typeid = findPosition(f.classNames, type(songid));
            labels = vertcat(labels,typeid);
            content = load('./pcaResult/meanValues.mat', variables_90_percent{i});
            varialbeMatrix = getfield(content, variables_90_percent{i});
            features = vertcat(features, varialbeMatrix.');
        else
            reducer = reducer +1;
        end
    end
    
    allCounts = zeros(1,classes);
    for i=1:numel(variables_10_percent)
        if strncmpi(variables_10_percent{i}, 'mfcc_', 5)==1
            temp = strrep(variables_10_percent{i}, 'mfcc_', '');
            filename = strcat('tracks/', temp);
            filename = strcat(filename, '.mp3');
            songid = findPosition(song, filename);
            typeid = findPosition(f.classNames, type(songid));
            allCounts(typeid) = allCounts(typeid)+1;
            actualResult = vertcat(actualResult,typeid);
        end
    end

    clearvars -except f features labels variables_90_percent variables_10_percent bestAccuracy actualResult bestCm bestC classes bestPrediction times allCounts
    testdata = [];
    for i=1:numel(variables_10_percent)
        if strncmpi(variables_10_percent{i}, 'mfcc_', 5)==1
            content = load('./pcaResult/meanValues.mat', variables_10_percent{i});
            varialbeMatrix = getfield(content, variables_10_percent{i});
            testdata = vertcat(testdata, varialbeMatrix.');
        end
    end
    for nTrees=10:30
        B = TreeBagger(nTrees,features,labels, 'Method', 'classification');
        [prediction,scores,stdevs]= B.predict(testdata);
        prediction = cellfun(@(x) str2double(x),prediction);
        accuracy = 0;
        for i=1:size(prediction,1)
            if(prediction(i,1) == actualResult(i,1))
                accuracy = accuracy +1;
            end
        end
        accuracy = accuracy/size(prediction,1);
        if(accuracy>bestAccuracy)
            bestAccuracy = accuracy;
            %bestScores = scores;
            %bestStdevs = stdevs;
            bestPrediction = prediction;
        end
    end
    
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
