clc
clear
close all

X = load('..\Dataset\filteredStackedS2.mat');
Y = load('..\Dataset\filteredStackedS1.mat');

electrodes = [11 12 19 32 46 47 48 49 56];
neg1 = X.data.negEEG;
oth1 = X.data.othEEG;
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
for i=1:length(oth1)
    for j=1:length(neg1{1,i})
       temp=  oth1{1, i}{j, 1};
       k = k+1;
       XTrain{k,1}= temp(electrodes,:);
       YTrain(k,1)=0;
    end
end

neg1 = Y.data.negEEG;
oth1 = Y.data.othEEG;
k=0;
for i=1:length(neg1)
    for j=1:length(neg1{1,i})
       temp=  neg1{1, i}{j, 1};
       k = k+1;
       XTest{k,1}= temp(electrodes,:);
       YTest(k,1)=1;
    end
end
for i=1:length(oth1)
    for j=1:length(neg1{1,i})
       temp=  oth1{1, i}{j, 1};
       k = k+1;
       XTest{k,1}= temp(electrodes,:);
       YTest(k,1)=0;
    end
end
%%
Rd_Train = randperm(size(YTrain,1));
Rd_Test = randperm(size(YTest,1));

for i=1:length(Rd_Train)
    XTra{i,1} = XTrain{Rd_Train(i),1}; 
end
for i=1:length(Rd_Test)
    XTes{i,1} = XTest{Rd_Test(i),1}; 
end

YTrain = categorical(YTrain(Rd_Train));
YTest = categorical(YTest(Rd_Test));
%%
inputSize = 9;
numHiddenUnits = 500;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 3;
miniBatchSize = 27;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'InitialLearnRate',0.0001,...
    'Verbose',1, ...
    'Plots','training-progress');

net = trainNetwork(XTra,YTrain,layers,options);



YPred = classify(net,XTes, ...
    'SequenceLength','longest','Ex);
acc = sum(YPred == YTest)./numel(YTest)
