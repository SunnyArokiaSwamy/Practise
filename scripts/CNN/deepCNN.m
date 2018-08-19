clc
clear
close all

X = load('filt_S1.mat');
Y = load('filt_S2.mat');


%%
[stackedErrp_X,stackedNErrp_Y] = EEG2CNN(X.filt_data_train);
stackedNErrp_Y = stackedNErrp_Y(:,:,:,randperm(size(stackedNErrp_Y,4),size(stackedErrp_X,4)));
combData_X = cat(4,stackedErrp_X,stackedNErrp_Y);
targets_X = [ones(1,size(stackedErrp_X,4)) zeros(1,size(stackedNErrp_Y,4))];
rd_X = randperm(size(targets_X,2));
targets_X = categorical(targets_X(1,rd_X));
combData_X = combData_X(:,:,:,rd_X);

layers = [
    imageInputLayer([6 512 1])
    
    convolution2dLayer([6 10],25)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([6 3],'Stride',[1 1])
    
    convolution2dLayer([5 20],50)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([5 3],'Stride',[1 1])
    
    convolution2dLayer([4 30],75)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([4 3],'Stride',[1 1])
    
    convolution2dLayer([3 40],100)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([3 3],'Stride',[1 1])
    
    convolution2dLayer([2 50],125)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([2 3],'Stride',[1 1])
    
    convolution2dLayer([1 60],150)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(100)
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];


options = trainingOptions('sgdm','Plots', 'training-progress','MaxEpochs',20,...
    'MiniBatchSize',128);
net = trainNetwork(combData_X, targets_X, layers, options);

[stackedErrp_Y,stackedNErrp_Y] = EEG2CNN(Y.filt_data_train);
stackedNErrp_Y = stackedNErrp_Y(:,:,:,randperm(size(stackedNErrp_Y,4),size(stackedErrp_Y,4)));
combData_Y = cat(4,stackedErrp_Y,stackedNErrp_Y);
targets_Y = [ones(1,size(stackedErrp_Y,4)) zeros(1,size(stackedNErrp_Y,4))];
rd_Y = randperm(size(targets_Y,2));
targets_Y = categorical(targets_Y(1,rd_Y));
combData_Y = combData_Y(:,:,:,rd_Y);

XTest = combData_Y;
YTest = targets_Y';
YPred = classify(net, XTest);
accuracy = sum(YTest == YPred)/numel(YTest)


%%

function [stackedErrp,stackedNErrp] = EEG2CNN(filt_data_train)
    stackedErrp = [];
    stackedNErrp = [];
    for i=1:size(filt_data_train,2)
        for j=1:size(filt_data_train{1, 1}.trails,2)
            ERP = [];
            nERP = [];
            trail = filt_data_train{1, i}.trails{1, j};
            pos = filt_data_train{1, i}.position{1, j};  
            typ = filt_data_train{1, i}.type{1, j};
            E_stPoint=pos(find(typ==6 | typ==9));   
            E_endPoint = E_stPoint+512-1;
            N_stPoint=pos(find(typ~=6 & typ~=9));   
            N_endPoint = N_stPoint+512-1;  

            for k=1:length(E_stPoint)
                ERP(:,:,:,k) = trail(45:50,E_stPoint(k):E_endPoint(k));
            end % SUNNY CHANGED
            for k=1:length(N_stPoint)
                nERP(:,:,:,k) = trail(45:50,N_stPoint(k):N_endPoint(k));
            end   
            stackedErrp = cat(4,stackedErrp,ERP);
            stackedNErrp = cat(4,stackedNErrp,nERP);
        end
    end
end