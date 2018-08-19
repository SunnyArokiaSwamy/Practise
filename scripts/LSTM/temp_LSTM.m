clc
clear
close all

X = load('..\Dataset\filteredStackedS2.mat');
Y = load('..\Dataset\filteredStackedS1.mat');

electrodes = [47 48];
neg1 = X.data.negEEG;
oth1 = X.data.othEEG;
% Stack for LSTM
k=0;
for i=1:length(neg1)
    for j=1:length(neg1{1,i})
       temp=  neg1{1, i}{j, 1};
       k = k+1;
       Data{k,1}= temp(electrodes,:);
       Targets(k,1)=1;
    end
end
for i=1:length(oth1)
    for j=1:length(oth1{1,i})
       temp=  oth1{1, i}{j, 1};
       k = k+1;
       Data{k,1}= temp(electrodes,:);
       Targets(k,1)=2;
    end
end
%%


targets = categorical(Targets);
inputSize = 2;
numHiddenUnits = 100;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 10;
miniBatchSize = 27;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(Data,targets,layers,options);


