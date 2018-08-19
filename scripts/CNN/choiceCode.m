% This program is used to choose the data point required and train via CNN

clc
clear
close all

% Constants defination
no_of_trails = 10;
train_BOOL = true;
test_BOOL = true;
filt_data_train = [];
filt_data_test = [];

% Classifiers Bool
cnnBOOL = true;
cnnTest = true;
[Electrode_indx,SubTrain_indx,SubTest_indx]=GUI_user_Request;

if(train_BOOL)    % TRAINING data
    data_Train = ReadTheData(SubTrain_indx);
    for sub=1:size(data_Train,2)
        for trail =1:no_of_trails
            eeg = data_Train{1, sub}.run{1, trail}.eeg';     
            % Using EEGLAB
            disp('===============================================================')
            disp('========EEG Preprocessing Started....============')
            EEG.etc.eeglabvers = '14.1.1'; 
            EEG = pop_importdata('dataformat','array','nbchan',0,'data','eeg','srate',512,'pnts',0,'xmin',0);
            EEG.setname='eeg_data';
            EEG = eeg_checkset( EEG );
            EEG=pop_chanedit(EEG, 'lookup','/Users/sunnyarokiaswamybellary/Documents/EEGLAB_Code/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp','load',{'/Users/sunnyarokiaswamybellary/Documents/EEGLAB_Code/ERP_Dataset/Datasets/locs.xyz' 'filetype' 'autodetect'},'transform',{'TMP=X;X=Y;Y=-TMP'},'eval','chans = pop_chancenter( chans, [],48);'); 
            EEG = eeg_checkset( EEG );
%             EEG = pop_reref( EEG, []);
%             EEG = eeg_checkset( EEG );
            EEG = pop_eegfiltnew(EEG, 1,10,1690,1,[]);
            EEG = eeg_checkset( EEG );
%             pop_eegplot( EEG, 1, 1, 1); % To plot the eeg data DEBUG
%             pause
            filt_data_train{1,sub}.trails{1,trail} = EEG.data(Electrode_indx,:);
            filt_data_train{1,sub}.position{1,trail} = data_Train{1, sub}.run{1, trail}.header.EVENT.POS;
            filt_data_train{1,sub}.type{1,trail} = data_Train{1, sub}.run{1, trail}.header.EVENT.TYP;
        end
        disp('========EEG Preprocessing done....============')
        disp('===============================================================')
    end
    clear EEG;
end

if(test_BOOL)     % TESTING data
    data_Test = ReadTheData(SubTest_indx);
    for sub=1:size(data_Test,2)
        for trail =1:no_of_trails
            eeg = data_Test{1, sub}.run{1, trail}.eeg';     
            % Using EEGLAB
            disp('===============================================================')
            disp('========EEG Preprocessing Started....============')
            EEG.etc.eeglabvers = '14.1.1'; 
            EEG = pop_importdata('dataformat','array','nbchan',0,'data','eeg','srate',512,'pnts',0,'xmin',0);
            EEG.setname='eeg_data';
            EEG = eeg_checkset( EEG );
            EEG=pop_chanedit(EEG, 'lookup','/Users/sunnyarokiaswamybellary/Documents/EEGLAB_Code/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp','load',{'/Users/sunnyarokiaswamybellary/Documents/EEGLAB_Code/ERP_Dataset/Datasets/locs.xyz' 'filetype' 'autodetect'},'transform',{'TMP=X;X=Y;Y=-TMP'},'eval','chans = pop_chancenter( chans, [],48);'); 
            EEG = eeg_checkset( EEG );
            EEG = pop_reref( EEG, []);
            EEG = eeg_checkset( EEG );
            EEG = pop_eegfiltnew(EEG, 1,10,1690,0,[]);
            EEG = eeg_checkset( EEG );
%             pop_eegplot( EEG, 1, 1, 1); % To plot the eeg data DEBUG
%             pause
            filt_data_test{1,sub}.trails{1,trail} = EEG.data(Electrode_indx,:);
            filt_data_test{1,sub}.position{1,trail} = data_Test{1, sub}.run{1, trail}.header.EVENT.POS;
            filt_data_test{1,sub}.type{1,trail} = data_Test{1, sub}.run{1, trail}.header.EVENT.TYP;
        end
        disp('========EEG Preprocessing done....============')
        disp('===============================================================')
    end
    clear EEG;
end


if(cnnBOOL)
% Classification Training
[stackedErrp,stackedNErrp] = EEG2CNN(filt_data_train);

stackedNErrp = stackedNErrp(:,:,:,randperm(size(stackedNErrp,4),size(stackedErrp,4)));
combData = cat(4,stackedErrp,stackedNErrp);
targets = [ones(1,size(stackedErrp,4)) zeros(1,size(stackedNErrp,4))];
rd = randperm(size(targets,2));
targets = categorical(targets(1,rd));
combData = combData(:,:,:,rd);


%%
if(0)
layers = [
    imageInputLayer([length(Electrode_indx) 512 1])
    
    convolution2dLayer([1 10],25)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[1 1])
    
    convolution2dLayer([1 20],50)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[3 1])
    
    convolution2dLayer([1 30],75)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[3 1])
    
    convolution2dLayer([1 40],100)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[3 1])
    
    convolution2dLayer([1 50],125)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer([1 3],'Stride',[3 1])
    
    convolution2dLayer([1 60],150)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(100)
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];


options = trainingOptions('sgdm','Plots', 'training-progress');
net = trainNetwork(combData, targets, layers, options);
end

%% Classification Testing

[stackedErrp,stackedNErrp] = EEG2CNN(filt_data_test);

stackedNErrp = stackedNErrp(:,:,:,randperm(size(stackedNErrp,4),size(stackedErrp,4)));
combData = cat(4,stackedErrp,stackedNErrp);
targets = [ones(1,size(stackedErrp,4)) zeros(1,size(stackedNErrp,4))];
rd = randperm(size(targets,2));
targets = categorical(targets(1,rd));
combData = combData(:,:,:,rd);

XTest = combData;
YTest = targets';
% YPred = classify(net, XTest);
% accuracy = sum(YTest == YPred)/numel(YTest)
end
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
                ERP(:,:,1,k) = trail(:,E_stPoint(k):E_endPoint(k));
            end
            for k=1:length(N_stPoint)
                nERP(:,:,1,k) = trail(:,N_stPoint(k):N_endPoint(k));
            end   
            stackedErrp = cat(4,stackedErrp,ERP);
            stackedNErrp = cat(4,stackedNErrp,nERP);
        end
    end
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
        elseif subject(i) ==5
            sub = 3;
            ses = 1;
        elseif subject(i) ==6
            sub = 3;
            ses = 2;
        elseif subject(i) ==7
            sub = 4;
            ses = 1;
        elseif subject(i) ==8
            sub = 4;
            ses = 2;
        elseif subject(i) ==9
            sub = 5;
            ses = 1;
        elseif subject(i) ==10
            sub = 5;
            ses = 2;
        elseif subject(i) ==11
            sub = 6;
            ses = 1;
        elseif subject(i) ==12
            sub = 6;
            ses = 2;
        else
            return
        end
        
        str = strcat('/Users/sunnyarokiaswamybellary/Documents/EEGLAB_Code/ERP_Dataset/Datasets/Original/Subject0',num2str(sub),'_s',num2str(ses),'.mat');
        X{i} = load(str);      
    end  
end

function [Electrode_indx,SubTrain_indx,SubTest_indx]=GUI_user_Request
    
    %%%%%%%% Choose the Training Data set
    disp('===============================================================')
    disp('Choosing the Training Data sets')
    disp('===============================================================')
    list = {'Subject_1 S1','Subject_1 S2','Subject_2 S1','Subject_2 S2',...
        'Subject_3 S1','Subject_3 S2','Subject_4 S1','Subject_4 S2',...
        'Subject_5 S1','Subject_5 S2','Subject_6 S1','Subject_6 S2'};
    [SubTrain_indx,tf] = listdlg('PromptString','Select Training Dataset:','ListString',list);
    if(tf)
        for i=1:length(SubTrain_indx)
            switch SubTrain_indx(i)
                case 1
                    disp('Subject 1 session 1 selected as Training DS')
                case 2
                    disp('Subject 1 session 2 selected as Training DS')
                case 3
                    disp('Subject 2 session 1 selected as Training DS')
                case 4
                    disp('Subject 2 session 2 selected as Training DS')
                case 5
                    disp('Subject 3 session 1 selected as Training DS')
                case 6
                    disp('Subject 3 session 2 selected as Training DS')
                case 7
                    disp('Subject 4 session 1 selected as Training DS')
                case 8
                    disp('Subject 4 session 2 selected as Training DS')
                case 9
                    disp('Subject 5 session 1 selected as Training DS')
                case 10
                    disp('Subject 5 session 2 selected as Training DS')
                case 11
                    disp('Subject 6 session 1 selected as Training DS')
                case 12
                    disp('Subject 6 session 2 selected as Training DS')
                otherwise
                    disp('None of the subjects selected as Training DS')
            end
        end
    else
        disp('Should Select at least one Training Dataset')
    end
    %%%%%%%%% Choose the Testing Data set
    disp('===============================================================')
    disp('Choosing the Testing Data sets')
    disp('===============================================================')
    list = {'Subject_1 S1','Subject_1 S2','Subject_2 S1','Subject_2 S2',...
        'Subject_3 S1','Subject_3 S2','Subject_4 S1','Subject_4 S2',...
        'Subject_5 S1','Subject_5 S2','Subject_6 S1','Subject_6 S2'};
    [SubTest_indx,tf] = listdlg('PromptString','Select Testing Dataset:','ListString',list);
    if(tf)
        for i=1:length(SubTest_indx)
            switch SubTest_indx(i)
                case 1
                    disp('Subject 1 session 1 selected as Training DS')
                case 2
                    disp('Subject 1 session 2 selected as Training DS')
                case 3
                    disp('Subject 2 session 1 selected as Training DS')
                case 4
                    disp('Subject 2 session 2 selected as Training DS')
                case 5
                    disp('Subject 3 session 1 selected as Training DS')
                case 6
                    disp('Subject 3 session 2 selected as Training DS')
                case 7
                    disp('Subject 4 session 1 selected as Training DS')
                case 8
                    disp('Subject 4 session 2 selected as Training DS')
                case 9
                    disp('Subject 5 session 1 selected as Training DS')
                case 10
                    disp('Subject 5 session 2 selected as Training DS')
                case 11
                    disp('Subject 6 session 1 selected as Training DS')
                case 12
                    disp('Subject 6 session 2 selected as Training DS')
                otherwise
                    disp('None of the subjects selected as Testing DS')
            end
         end
    else
        disp('Should Select at least one Testing Dataset')
    end
    % Choose the electrodes
    %figure('Position','right')
    hAxes = gca;
    hImage = imshow( 'electrodePositions.png', 'Parent', hAxes );
    title( hAxes, '64 Electrodes Standard 10/20 International System' );
    disp('===============================================================')
    disp('Choosing the electode')
    disp('===============================================================')
    list = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1',...
        'C1','C3','C5','T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7',...
        'P9','PO7','PO3','O1','Iz','Oz','POz','Pz','CPz','Fpz','Fp2','AF8',...
        'AF4','AFz','Fz','F2','F4','F6','F8','FT8','FC6','FC4','FC2','FCz',...
        'Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
        'P8','P10','PO8','PO4','O2'};
    [Electrode_indx,tf] = listdlg('PromptString','Select Electrode Position:'...
        ,'ListString',list);
    if(tf)
        for i=1:length(Electrode_indx)
            switch Electrode_indx(i)
                case 1
                    disp('Fp1 selected')
                case 2
                    disp('AF7 selected')
                case 3
                    disp('AF3 selected')
                case 4
                    disp('F1  selected')
                case 5
                    disp('F3  selected')
                case 6
                    disp('F5  selected')
                case 7
                    disp('F7  selected')
                case 8
                    disp('FT7 selected')
                case 9
                    disp('FC5 selected')
                case 10
                    disp('FC3 selected')
                case 11
                    disp('FC1 selected')
                case 12
                    disp('C1  selected')
                case 13
                    disp('C3  selected')
                case 14
                    disp('C5  selected')
                case 15
                    disp('T7  selected')
                case 16
                    disp('TP7 selected')
                case 17
                    disp('CP5 selected')
                case 18
                    disp('CP3 selected')
                case 19
                    disp('CP1 selected')
                case 20
                    disp('P1  selected')
                case 21
                    disp('P3  selected')
                case 22
                    disp('P5  selected')
                case 23
                    disp('P7  selected')
                case 24
                    disp('P9  selected')
                case 25
                    disp('PO7 selected')
                case 26
                    disp('PO3 selected')
                case 27
                    disp('O1  selected')
                case 28
                    disp('Iz  selected')
                case 29
                    disp('Oz  selected')
                case 30
                    disp('POz selected')
                case 31
                    disp('Pz  selected')
                case 32
                    disp('CPz selected')
                case 33
                    disp('Fpz selected')
                case 34
                    disp('Fp2 selected')
                case 35
                    disp('AF8 selected')
                case 36
                    disp('AF4 selected')
                case 37
                    disp('AFz selected')
                case 38
                    disp('Fz  selected')
                case 39
                    disp('F2  selected')
                case 40
                    disp('F4  selected')
                case 41
                    disp('F6  selected')
                case 42
                    disp('F8  selected')
                case 43
                    disp('FT8 selected')
                case 44
                    disp('FC6 selected')
                case 45
                    disp('FC4 selected')
                case 46
                    disp('FC2 selected')
                case 47
                    disp('FCz selected')
                case 48
                    disp('Cz  selected')
                case 49
                    disp('C2  selected')
                case 50
                    disp('C4  selected')
                case 51
                    disp('C6  selected')
                case 52
                    disp('T8  selected')
                case 53
                    disp('TP8 selected')
                case 54
                    disp('CP6 selected')
                case 55
                    disp('CP4 selected')
                case 56
                    disp('CP2 selected')
                case 57
                    disp('P2  selected')
                case 58
                    disp('P4  selected')
                case 59
                    disp('P6  selected')
                case 60
                    disp('P8  selected')
                case 61
                    disp('P10 selected')
                case 62
                    disp('PO8 selected')
                case 63
                    disp('PO4 selected')
                case 64
                    disp('O2  selected')
                otherwise
                    disp('None of the electrode selected')
            end
        end   
    else
       disp('Should Select at least one Electrode') 
    end
    close Figure 1    
end
