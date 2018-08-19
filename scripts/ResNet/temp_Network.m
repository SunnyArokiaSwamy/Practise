layers = [
    imageInputLayer([2 512 1],'Name','input')
    
    convolution2dLayer(1,8,'Name','conv_1')
    batchNormalizationLayer('Name','BN_1')
    reluLayer('Name','relu_1')
    
    maxPooling2dLayer([1 2],'Stride',[1 2],'Name','pool1')
    
    convolution2dLayer(1,8,'Name','conv_2')
    batchNormalizationLayer('Name','BN_2')
    reluLayer('Name','relu_2')
        additionLayer(2,'Name','add')
    maxPooling2dLayer([1 2],'Stride',[1 2],'Name','pool2')

    convolution2dLayer(1,32,'Name','conv_3')
    batchNormalizationLayer('Name','BN_3','Name','pool3')
    reluLayer('Name','relu_3')
    
    fullyConnectedLayer(2,'Name','fc')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classOutput')];
lgraph = layerGraph(layers);
%skipConv = convolution2dLayer(1,16,'Stride',[1 2],'Name','skipConv');
%lgraph = addLayers(lgraph,skipConv);
lgraph = connectLayers(lgraph,'relu_1','add/in2');
%lgraph = connectLayers(lgraph,'skipConv','add/in2');


analyzeNetwork(lgraph)