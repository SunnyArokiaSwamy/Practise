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
%     figure(i),subplot(2,1,1), plot(mean(cell2mat(Errp)));
%     figure(i),subplot(2,1,2), plot(mean(cell2mat(normal)));
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



% For CNN
for i=1:length(XTrain)
    temp = XTrain{i, 1};  
    XTra(:,:,:,i) = temp;
end
for i=1:length(XTest)
    temp = XTest{i, 1};  
    XTes(:,:,:,i) = temp;
end


% Randomize
Rd1 = randperm(size(XTra,4));
Rd2 = randperm(size(XTes,4));
XTrain = XTra(:,:,:,Rd1);
YTrain = categorical(YTrain(Rd1));
XTest =  XTes(:,:,:,Rd2);
YTest = categorical(YTest(Rd2));

layers = [
    imageInputLayer([2 512 1],'Name','input')
    
    convolution2dLayer(2,8,'Name','conv_1')
    batchNormalizationLayer('Name','BN_1')
    reluLayer('Name','relu_1')
    
    maxPooling2dLayer([1 2],'Stride',[1 2],'Name','pool1')
    
    convolution2dLayer(1,16,'Name','conv_2')
    batchNormalizationLayer('Name','BN_2')
    reluLayer('Name','relu_2')
    
    maxPooling2dLayer([1 2],'Stride',[1 2],'Name','pool2')
    additionLayer(2,'Name','add')
    convolution2dLayer(1,32,'Name','conv_3')
    batchNormalizationLayer('Name','BN_3','Name','pool3')
    reluLayer('Name','relu_3')
    
    fullyConnectedLayer(2,'Name','fc')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classOutput')];
lgraph = layerGraph(layers);
skipConv = convolution2dLayer(1,32,'Stride',[1 2],'Name','skipConv');
lgraph = addLayers(lgraph,skipConv);
lgraph = connectLayers(lgraph,'relu_1','skipConv');
lgraph = connectLayers(lgraph,'skipConv','add/in2');

options = trainingOptions('sgdm', ...
    'MaxEpochs',4, ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(XTrain,YTrain,lgraph,options);
YPred = classify(net,XTrain);
accuracy = sum(YPred == YTrain)/numel(YTrain)


