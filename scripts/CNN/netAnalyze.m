clc
clear
close all

layers = [
    imageInputLayer([44 522 1])
    
    convolution2dLayer([1 10],25)
    reluLayer
    
    maxPooling2dLayer([44 1],'Stride',[1 1])
    
    convolution2dLayer([1 25],25,'Stride',[1 2])
    reluLayer
    
    %maxPooling2dLayer([44 1],'Stride',[1 1])
%     
%     convolution2dLayer(3,16,'Padding',1)
%     batchNormalizationLayer
%     reluLayer
%     
%     maxPooling2dLayer(2,'Stride',2)
%     
%     convolution2dLayer(3,32,'Padding',1)
%     batchNormalizationLayer
%     reluLayer
    
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

analyzeNetwork(layers)