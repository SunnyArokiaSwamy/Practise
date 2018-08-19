clc
clear
close all

loadConstants;

% Sunny Inputs
% subject_numb = [1 2 3 4 5 6];
% sessions = [1 2];

subject_num = 6;
session_num = 1;
event_type = [6,9];
electrodes = [47];

[Raw_EEG, event] = loadDataGivenSessionSubjectNumb(subject_num,session_num);
filt_EEG = loadforFiltering(Raw_EEG,f);% must repair a bit
separatedData = eventSpecificData(filt_EEG, event,event_type);

[Errp, normal] = ReshapeData(separatedData,electrodes);

subplot(1,2,1),plot((1:512)/512,mean(cell2mat(Errp)))
subplot(1,2,2),plot((1:512)/512,mean(cell2mat(normal)))


