clc
clear
close all

load('S1S2.mat')
Electrode_indx = 46:51;
% Classification Training
[stackedErrp,stackedNErrp] = EEG2CNN(filt_data_train);

stackedNErrp = stackedNErrp(:,:,:,randperm(size(stackedNErrp,4),size(stackedErrp,4)));
combData = cat(4,stackedErrp,stackedNErrp);
targets = [ones(1,size(stackedErrp,4)) zeros(1,size(stackedNErrp,4))];
rd = randperm(size(targets,2));
targets = categorical(targets(1,rd));
combData = combData(:,:,:,rd);


layers = [
    imageInputLayer([length(Electrode_indx) 512 1])
    
    convolution2dLayer([1 10],25)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[1 1])
    
    convolution2dLayer([3 25],50)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[3 1])
    
    convolution2dLayer([1 50],200)
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

% analyzeNetwork(layers)
% return
options = trainingOptions('sgdm','Plots', 'training-progress');
net = trainNetwork(combData, targets, layers, options);












function [stackedErrp,stackedNErrp] = EEG2CNN(filt_data_train)
    stackedErrp = [];
    stackedNErrp = [];
    add_idx = 1;
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
%                 Add(add_idx,:) = trail(1,E_stPoint(k):E_endPoint(k));
%                 Add1(add_idx,:) = trail(2,E_stPoint(k):E_endPoint(k));
%                 Add2(add_idx,:) = trail(3,E_stPoint(k):E_endPoint(k));
%                 Add3(add_idx,:) = trail(4,E_stPoint(k):E_endPoint(k));
%                 Add4(add_idx,:) = trail(5,E_stPoint(k):E_endPoint(k));
%                 Add5(add_idx,:) = trail(6,E_stPoint(k):E_endPoint(k));
%                 add_idx = add_idx+1;
            end
            for k=1:length(N_stPoint)
                nERP(:,:,:,k) = trail(:,N_stPoint(k):N_endPoint(k));
            end   
            stackedErrp = cat(4,stackedErrp,ERP);
            stackedNErrp = cat(4,stackedNErrp,nERP);
        end
    end
%     subplot(2,3,1), plot(mean(Add)),title('FC2')
%     subplot(2,3,2), plot(mean(Add1)),title('FCz')
%     subplot(2,3,3), plot(mean(Add2)),title('Cz')
%     subplot(2,3,4), plot(mean(Add3)),title('C2')
%     subplot(2,3,5), plot(mean(Add4)),title('C4')
%     subplot(2,3,6), plot(mean(Add5)),title('C6')
end

function NN_PCA_ClassiTool(filt_data_train,filt_data_test)

end

function X = ReadTheData(subject)
    for i=1:length(subject)
        if subject(i) ==1
            sub = 1;
            ses = 1;
        elseif subject(i) ==2
            sub = 1;
            ses = 2;
        elseif subject(i) ==3
            sub = 2;
            ses = 1;
        elseif subject(i) ==4
            sub = 2;
            ses = 2;
        else
            return
        end
        
        str = strcat('/Users/sunnyarokiaswamybellary/Documents/EEGLAB_Code/ERP_Dataset/Datasets/Original/Subject0',num2str(sub),'_s',num2str(ses),'.mat');
        X{i} = load(str);      
    end  
end
