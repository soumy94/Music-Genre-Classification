required_files= load('./pcaResult/meanValues.mat');
load_ground_truth;
variables = who;
fields = fieldnames(required_files);
f = {};
f.classNames = {'classical','electronic','jazz_blues','metal_punk','rock_pop','world'};
inputVector = [];
targetVector = zeros(6,729);
reducer = 0;
for i=1:numel(fields)
    if strncmpi(fields{i}, 'mfcc_', 5)==1
        temp = strrep(fields{i}, 'mfcc_', '');
        filename = strcat('tracks/', temp);
        filename = strcat(filename, '.mp3');
        songid = findPosition(song, filename);
        typeid = findPosition(f.classNames, type(songid));
        targetVector(typeid, i-reducer) = 1;
        content = load('./pcaResult/meanValues.mat', fields{i});
        varialbeMatrix = getfield(content, fields{i});
        inputVector = [inputVector varialbeMatrix];
    else
        reducer = reducer+1;
    end
end

clearvars -except f targetVector inputVector
classes = 6;
bestCm = zeros(classes,classes);
bestC = 1;
times = 10;
for k=1:times
    hiddenLayerSize = 10;
    net = fitnet(hiddenLayerSize,'trainlm');
    net.divideParam.trainRatio = 0.8;
    net.divideParam.valRatio = 0.1;
    net.divideParam.testRatio = 0.1;
    [net,tr] = train(net,inputVector,targetVector);
    outputs = net(inputVector);
    errors = gsubtract(outputs,targetVector);
    performance = perform(net,targetVector,outputs);
    [c,cm,ind,per] = confusion(targetVector,outputs);
    counts = [320 115 26 45 101 122];
    for i=1:classes
        for j=1:classes
            cm(i,j) = cm(i,j)/counts(i);
        end
    end
    if c<=bestC
        bestC = c;
        for i=1:classes
            for j=1:classes
                bestCm(i,j) =  round(cm(i,j),4);
            end
        end
    end
end