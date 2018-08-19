function [EEG, event] = loadDataGivenSessionSubjectNumb(subject_num,session_num)

% This function takes subject number and session number as input and gives
% its corresponding EEG data, type of event and sample location of the
% event

%%%%% INPUTS
% subject_num --> 1 to 6
% session_num --> 1 to 2

%%%%% OUTPUTS
% EEG --> struct of numb of trails (ex: 10) by 1 and data stored as number
% of electrodes by samples (ex: 64x91604)
% event.pos --> struct of numb of trails (ex: 10) by 1 and position of the event
% occured sample is provided
% event.typ --> struct of numb of trails (ex: 10) by 1 and type of the event
% occured at the sample point

if subject_num>6 | subject_num<1
    error('Invalid Subject Number... It should be an integer between 1 & 6');
end

if session_num>2 | session_num<1
    error('Invalid Session Number... It should be either 1 or 2');
end

str = strcat('../../datasets/Subject0',num2str(subject_num),'_s',num2str(session_num));
X = load(str);

for i=1:length(X.run)
    EEG{i,1} = X.run{1, i}.eeg';
    event.pos{i,1} = X.run{1, i}.header.EVENT.POS;
    event.typ{i,1} = X.run{1, i}.header.EVENT.TYP;
    event.label{i,1} = X.run{1, i}.header.Label;
end
