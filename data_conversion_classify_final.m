final_results = cell(15,2);
for K_n=1:2:15
    all_acc = 0;
    for loop=1:5
        % Training Data
        f = {};
        f.classNames = {'classical','electronic','jazz_blues','metal_punk','rock_pop','world'};
        f.features = {[],[],[],[],[],[]};
        load('./pcaResult/pcaResults.mat');
        load_ground_truth;
        variables = who;
        variables_90_percent = datasample(variables,656,'Replace', false);
        variables_10_percent = setdiff(variables, variables_90_percent);
        for i=1:length(variables_90_percent)
            if strncmpi(variables_90_percent(i), 'mfcc_', 5)==1

               % find song type, find index in song, and get corresponding index value
               % from type
               temp = strrep(variables_90_percent(i), 'mfcc_', '');
               filename = strcat('tracks/', temp);
               filename = strcat(filename, '.mp3');

               songid = findPosition(song, filename);
               typeid = findPosition(f.classNames, type(songid));

               typeMat = cell2mat(f.features(typeid));
               [rows, cols] = size(typeMat);

               varialbeMatrix = eval(char(variables_90_percent(i)));
               typeMat(:, cols+1) = mean(varialbeMatrix,2);
               f.features(typeid) = {typeMat};
            end
        end

        clearvars -except f variables_10_percent K_n all_acc loop final_results
        % Testing Data
        %load('Users/soumy/Documents/highdimensional/testdata/pcaResult/pcaResults_35.mat');
        %variables = who;
        testsample = [];
        verification = cell(length(variables_10_percent),2);
        for i=1:length(variables_10_percent)
            if strncmpi(variables_10_percent{i}, 'mfcc_', 5)==1
               temp = load('./pcaResult/pcaResults.mat', variables_10_percent{i});
               varialbeMatrix = getfield(temp, variables_10_percent{i});
               % Classifying
               [~,winnerClass] = classify('knn', f, mean(varialbeMatrix,2), K_n);
               temp = strrep(variables_10_percent(i), 'mfcc_', '');
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
        all_acc = all_acc + accuracy;
    end
    average_acc = all_acc/5;
    final_results(K_n,1) = {K_n};
    final_results(K_n,2) = {average_acc};
end
