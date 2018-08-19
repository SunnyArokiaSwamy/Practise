clc
clear
close all

X = load('..\Dataset\filteredStackedS2.mat');
Y = load('..\Dataset\filteredStackedS1.mat');

electrodes = [47 48];
neg1 = X.data.negEEG;
pos1 = X.data.posEEG;
% Stack for LSTM
k=0;
for i=1:length(neg1)
    for j=1:length(neg1{1,i})
       temp=  neg1{1, i}{j, 1};
       k = k+1;
       XTrain{k,1}= temp(electrodes,:);
       YTrain(k,1)=1;
    end
end
for i=1:length(pos1)
    for j=1:length(pos1{1,i})
       temp=  pos1{1, i}{j, 1};
       k = k+1;
       XTrain{k,1}= temp(electrodes,:);
       YTrain(k,1)=2;
    end
end

neg1 = Y.data.negEEG;
pos1 = Y.data.posEEG;
k=0;
for i=1:length(neg1)
    for j=1:length(neg1{1,i})
       temp=  neg1{1, i}{j, 1};
       k = k+1;
       XTest{k,1}= temp(electrodes,:);
       YTest(k,1)=1;
    end
end
for i=1:length(pos1)
    for j=1:length(pos1{1,i})
       temp=  pos1{1, i}{j, 1};
       k = k+1;
       XTest{k,1}= temp(electrodes,:);
       YTest(k,1)=2;
    end
end
%%

YTrain = categorical(YTrain);
YTest = categorical(YTest);

inputSize = 2;
numHiddenUnits = 100;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 3;
miniBatchSize = 27;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'Verbose',1, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,options);

%%

YPred = classify(net,XTest, ...
    'SequenceLength','longest');
acc = sum(YPred == YTest)./numel(YTest)
