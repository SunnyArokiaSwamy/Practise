clc
clear
close all

addpath(genpath('../CNN/'));

loadConstants;

% Sunny Inputs
subject_num = [1 2 3 4 5 6];
% sessions = [1 2];

%subject_num = [1 3];
event_type = [6,9];
electrodes = [47 48];
E = []; N=[];
session_num = 2;
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
session_num = 1;
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
%%
layers = [
    imageInputLayer([2 512 1])
    
    convolution2dLayer(2,8)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 2],'Stride',[1 2])
    
    convolution2dLayer(1,16)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 2],'Stride',[1 2])
    
    convolution2dLayer(1,32)
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MaxEpochs',100, ...
    'Verbose',true, ...
    'Plots','training-progress','ExecutionEnvironment','cpu');
net = trainNetwork(XTrain,YTrain,layers,options);
YPred = classify(net,XTest,'ExecutionEnvironment','cpu');
accuracy = sum(YPred == YTest)/numel(YTest)


