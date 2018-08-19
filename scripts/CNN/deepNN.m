% %load('filt_S1.mat');
% [stackedErrp,stackedNErrp] = EEG2CNN(filt_data_train);
% stackedNErrp = stackedNErrp(:,:,:,randperm(size(stackedNErrp,4),size(stackedErrp,4)));
% combData = cat(4,stackedErrp,stackedNErrp);
% targets = [ones(1,size(stackedErrp,4)) zeros(1,size(stackedNErrp,4))];
% rd = randperm(size(targets,2));
% targets = categorical(targets(1,rd));
% combData = combData(48,:,:,rd);

% layers = [ ...
%     imageInputLayer([1 512 1])
%     
%     fullyConnectedLayer(250)
%     reluLayer
% %     
%     fullyConnectedLayer(200)
%     reluLayer
%     
%     fullyConnectedLayer(150)
%     reluLayer
% %     
%     fullyConnectedLayer(100)
%     reluLayer
%     
%     fullyConnectedLayer(50)
%     reluLayer
%     
%     
%     fullyConnectedLayer(2)
%     softmaxLayer
%     classificationLayer];



% options = trainingOptions('adam','Plots', 'training-progress');
% net = trainNetwork(mat2cell(combData,512,1314), targets, layers, options);

% 
% layers = [
%     imageInputLayer([6 512 1],'Name','input')
%     
%     convolution2dLayer(5,16,'Padding','same','Name','conv_1')
%     batchNormalizationLayer('Name','BN_1')
%     reluLayer('Name','relu_1')
%     
%     convolution2dLayer(4,32,'Padding','same','Stride',1,'Name','conv_2')
%     batchNormalizationLayer('Name','BN_2')
%     reluLayer('Name','relu_2')
%     convolution2dLayer(3,32,'Padding','same','Name','conv_3')
%     batchNormalizationLayer('Name','BN_3')
%     reluLayer('Name','relu_3')
%     
%     additionLayer(2,'Name','add')
%     
%     averagePooling2dLayer(2,'Stride',1,'Name','avpool')
%     fullyConnectedLayer(2,'Name','fc')
%     softmaxLayer('Name','softmax')
%     classificationLayer('Name','classOutput')];
% lgraph = layerGraph(layers);
% skipConv = convolution2dLayer(1,32,'Stride',1,'Name','skipConv');
% lgraph = addLayers(lgraph,skipConv);
% lgraph = connectLayers(lgraph,'relu_1','skipConv');
% lgraph = connectLayers(lgraph,'skipConv','add/in2');

layers = [
    imageInputLayer([6 512 1])
    
    convolution2dLayer([6 10],25)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([6 3],'Stride',[1 1])
    
    convolution2dLayer([5 20],50)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([5 3],'Stride',[3 1])
    
    convolution2dLayer([4 30],75)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([4 3],'Stride',[3 1])
    
    convolution2dLayer([3 40],100)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([3 3],'Stride',[3 1])
    
    convolution2dLayer([2 50],125)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([2 3],'Stride',[3 1])
    
    convolution2dLayer([1 60],150)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(100)
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];


options = trainingOptions('adam','Plots', 'training-progress');
net = trainNetwork(combData, targets, lgraph, options);

YPred = classify(net, XTest);
accuracy = sum(YTest == YPred)/numel(YTest)

return



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
                ERP(:,:,:,k) = trail(:,E_stPoint(k):E_endPoint(k));
            end
            for k=1:length(N_stPoint)
                nERP(:,:,:,k) = trail(:,N_stPoint(k):N_endPoint(k));
            end   
            stackedErrp = cat(4,stackedErrp,ERP);
            stackedNErrp = cat(4,stackedNErrp,nERP);
        end
    end
end