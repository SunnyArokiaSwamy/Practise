clc
clear
% close all
load_dataset = 1;


if(load_dataset)
    for k=1:6
        str = strcat('..\Dataset\Subject0',num2str(k),'_s2.mat');
        [TrainData.Pe,TrainData.Ne,TrainData.Other]=noName(str);
        
        str = strcat('..\Dataset\Subject0',num2str(k),'_s1.mat');
        [TestData.Pe,TestData.Ne,TestData.Other]=noName(str);
        
    end
else
    X = load('..\Dataset\filteredStackedS2.mat');
    %TrainData.Pe = X.data.posEEG;
    TrainData.Ne = X.data.negEEG;
    TrainData.Other = X.data.othEEG;
    Y = load('..\Dataset\filteredStackedS1.mat');
    %TestData.Pe = Y.data.posEEG;
    TestData.Ne = Y.data.negEEG;
    TestData.Other = Y.data.othEEG;
end

electrode_numb = [11 12 19 32 46 47 48 49 56];
categories = 3;

stp = [];
% for j=1:length(TrainData.Ne)
    for i=1:length(TrainData.Ne)
       temp = TrainData.Ne{i,1};
       stp = [stp; temp(48,:)]; 
    end
% end
figure,plot(mean(stp))



return
[Xtrain,Ytrain,Xtest,Ytest]=reorder(TrainData,TestData,categories,electrode_numb);
[Xtrain,Ytrain,Xtest,Ytest] = prepareforCNN(Xtrain,Ytrain,Xtest,Ytest);
%[Xtrain,Ytrain,Xtest,Ytest] =prepareforCNN(Xtrain,Ytrain,Xtest,Ytest);
%%
Ytrain = categorical(Ytrain);
Ytest = categorical(Ytest);

layers = [
    imageInputLayer([9 512 1])
    
    convolution2dLayer([1 10],20)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[1 1])
    
    convolution2dLayer([1 10],40)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[1 1])
    
    convolution2dLayer([1 10],60)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(100)
    softmaxLayer
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm','Plots', 'training-progress','MaxEpochs',200,...
    'MiniBatchSize',128,'ExecutionEnvironment','cpu');
net = trainNetwork(Xtrain, Ytrain, layers, options);
YPred = classify(net, Xtest);
accuracy = sum(Ytest == YPred)/numel(Ytest)
