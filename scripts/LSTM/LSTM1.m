clc
clear
close all

addpath(genpath('../CNN/'));

loadConstants;

% Sunny Inputs
% subject_numb = [1 2 3 4 5 6];
% sessions = [1 2];

subject_num = [1 3];
event_type = [6,9];
electrodes = [47 48];
E = []; N=[];
session_num = 1;
for i=1:length(subject_num)
    [Raw_EEG, event] = loadDataGivenSessionSubjectNumb(subject_num(i),session_num);
    filt_EEG = loadforFiltering(Raw_EEG,f);% must repair a bit
    separatedData = eventSpecificData(filt_EEG, event,event_type);
    [Errp, normal] = ReshapeData(separatedData,electrodes);  
    E = [E; Errp];
    N = [N; normal];
end
XTrain = [E; N(1:length(E))];
YTrain = [ones(length(E),1); 2*ones(length(E),1)];


E = []; N=[];
session_num = 2;
for i=1:length(subject_num)
    [Raw_EEG, event] = loadDataGivenSessionSubjectNumb(subject_num(i),session_num);
    filt_EEG = loadforFiltering(Raw_EEG,f);% must repair a bit
    separatedData = eventSpecificData(filt_EEG, event,event_type);
    [Errp, normal] = ReshapeData(separatedData,electrodes);
    E = [E; Errp];
    N = [N; normal];
end
XTest = [E; N(1:length(E))];
YTest = [ones(length(E),1); 2*ones(length(E),1)];


% Randomize
Rd1 = randperm(length(XTrain));
Rd2 = randperm(length(XTest));
XTrain = XTrain(Rd1);
YTrain = categorical(YTrain(Rd1));
XTest =  XTest(Rd2);
YTest = categorical(YTest(Rd2));


inputSize = 2;
numHiddenUnits = 100;
numClasses = 2;
layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',100,...
    'Verbose',1, ...
    'Plots','training-progress');
net = trainNetwork(XTrain,YTrain,layers,options);

YPred = classify(net,XTrain);
acc = sum(YPred == YTrain)./numel(YTrain)