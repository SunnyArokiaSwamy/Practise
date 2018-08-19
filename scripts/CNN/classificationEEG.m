% Using dataset for CNN only

clc
clear
close all

load('f_S1_Cz.mat')
stackedErrp=[];
stackedNErrp=[];
for i=1:6
    for j=1:10
        data.eeg = S1(i).EEG(j).Cz;
        data.pos = S1(i).EEG(j).position;
        data.typ = S1(i).EEG(j).type;
        [ERP, nERP] = stackERP(data);
        stackedErrp = cat(4,stackedErrp,ERP);
        stackedNErrp = cat(4,stackedNErrp,nERP);
    end
end
Errp = stackedErrp;
n_Errp = stackedNErrp(:,:,:,randperm(size(stackedNErrp,4),size(stackedErrp,4)));


combinedData = cat(4,Errp,n_Errp);
targets = [ones(1,size(Errp,4)), zeros(1,size(n_Errp,4))];
rd = randperm(size(targets,2));

combinedData = combinedData(:,:,:,rd);
targets = categorical(targets(:,rd));

layers = [
    imageInputLayer([1 512 1])
    
    convolution2dLayer(1,30)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(1,'Stride',1)
    
    convolution2dLayer(1,40)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(1,'Stride',1)
    
    convolution2dLayer(1,50)
    batchNormalizationLayer
    reluLayer
    
    convolution2dLayer(1,60)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(1,'Stride',1)
    
    convolution2dLayer(1,70)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(1,'Stride',1)
    
    convolution2dLayer(1,80)
    batchNormalizationLayer
    reluLayer

    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];
options = trainingOptions('sgdm','Plots', 'training-progress');
net = trainNetwork(combinedData, targets, layers, options);

XTest = combinedData;
YTest = targets';
YPred = classify(net, XTest);
accuracy = sum(YTest == YPred)/numel(YTest);









function [ERP, nERP] = stackERP(data)
% This function reads the filtered EEG data &electrode info and gives the 
% separated ERP and Not ERP data Stacked towards three dimension
    E_stPoint=data.pos(find(data.typ==6 | data.typ==9));   
    E_endPoint = E_stPoint+512-1;
    N_stPoint=data.pos(find(data.typ~=6 & data.typ~=9));   
    N_endPoint = N_stPoint+512-1;  
    for i=1:length(E_stPoint)
        ERP(:,:,1,i) = data.eeg(E_stPoint(i):E_endPoint(i));
    end
    for i=1:length(N_stPoint)
        nERP(:,:,1,i) = data.eeg(N_stPoint(i):N_endPoint(i));
    end    
end