features = [];
load('./pcaResult/meanValues.mat');
load_ground_truth;
variables = who;
for i=1:numel(variables)
    if strncmpi(variables{i}, 'mfcc_', 5)==1
        content = load('./pcaResult/meanValues.mat', variables{i});
        varialbeMatrix = getfield(content, variables{i});
        features = vertcat(features, varialbeMatrix.');
    end
end
clearvars -except features
k = 6;
GMModel = fitgmdist(features,k,'RegularizationValue',0.1);
groups = cluster(GMModel,features);
groupNames = {};
for i=1: numel(groups)
    if(groups(i)==1)
        groupNames{i,1}= 'Classical';
    end
    if(groups(i)==2)
        groupNames{i,1}= 'Electronic';
    end
    if(groups(i)==3)
        groupNames{i,1}= 'Jazz/Blues';
    end
    if(groups(i)==4)
        groupNames{i,1}= 'Metal/Punk';
    end
    if(groups(i)==5)
        groupNames{i,1}= 'Rock/Pop';
    end
    if(groups(i)==6)
        groupNames{i,1}= 'World';
    end
end
gscatter(features(:,1),features(:,2),groupNames,'kmyrgb','......',25);
xlabel('dim1');
ylabel('dim2');