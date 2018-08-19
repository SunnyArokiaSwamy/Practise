% This program is written for EEG lab purposes. The main objective of this
% code is to take the ERP data and analyse it on eeglab and visual
% inspection. The steps to proceed are we will extract the Cz data first
% and view it

% 1. Extract all the Errp events corresponding to events 6 & 9 and plot it
% one over the other
% 2. Clean the signal by removing artifacts and filtering

clc
clear
close all
Stacked_Cz = zeros(1,1024);
t=0;
for i=1:1    
   str = strcat('Datasets/Subject0',num2str(i),'_s2.mat');
   x = load(str);
   for j=1:size(x.run,2)
       eeg = x.run{1,j}.eeg';
       position = x.run{1,j}.header.EVENT.POS;
       type = x.run{1,j}.header.EVENT.TYP;
       errpPos = position(find(type==6 | type==9));
       
%        errpPos(:,2) = errpPos(:,1)+1023;
%        eeg = eeg(:,errpPos(:,1):errpPos(:,2));
         Czee=eeg(48,:); 
       for ele=1:64
          eeg(ele,:) = detrend(eeg(ele,:))-mean(detrend(eeg(ele,:)));
          eeg(ele,:) = eeg(ele,:)/(max(eeg(ele,:))-min(eeg(ele,:)));
       end
       
       
       Cz = eeg(48,:);
       %Cz = Cz - (sum(eeg)./64);       
       Cz_d = (Cz);
       for k=1:length(errpPos)
          stPoint = errpPos(k);
          endPoint = stPoint+2*512-1;          
          plot(smooth(Cz_d(stPoint:endPoint)),'-r');
          hold on
          Stacked_Cz = Stacked_Cz+Czee(stPoint:endPoint);           
          t = t+1;
       end
   end    
end
plot(Stacked_Cz./t)
% load('Datasets/Subject01_s1.mat')
% eegData = run{1, 1}.eeg';  
% header = run{1, 1}.header;
% 
% data_d = detrend(eegData);
% % Data_fft = fft(Data_with_dc); Data_fft(1) = 0; Data_without_dc = ifft (Data_fft);
% Cz = eegData(48,:);