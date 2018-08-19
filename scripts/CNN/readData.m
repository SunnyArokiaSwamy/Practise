clc
%clear
close all

addpath(genpath('C:\Users\sbellary\Documents\MATLAB\extern\installables\eeglab_current\eeglab14_1_2b'));
for k=1:6
    str = strcat('C:\Users\sbellary\Documents\MATLAB\extern\Dataset\Subject0',num2str(k),'_s1.mat');
    load(str);
    stk.neg1 = [];stk_filt.neg1 = [];
    stk.neg2 = [];stk_filt.neg2 = [];
    stk.pos1 = [];stk_filt.pos1 = [];
    stk.pos2 = [];stk_filt.pos2 = [];
    for i=1:10
        dat = run{1, i}.eeg';
        label = run{1, i}.header.Label;
        sampleRate = run{1, i}.header.SampleRate;
        sub = run{1, i}.header.Subject;
        sess = run{1, i}.header.Subject;
        pos = run{1, i}.header.EVENT.POS;
        typ = run{1, i}.header.EVENT.TYP;
        time = (0:size(dat,2)-1)/sampleRate;
        
        EEG = pop_importdata('dataformat','array','nbchan',64,'data','dat','srate',sampleRate);
        EEG = eeg_checkset( EEG );
%         EEG = pop_reref( EEG, []);
%         EEG = eeg_checkset( EEG );
        EEG = pop_eegfiltnew(EEG, 1,10,1690,0,[]);
        EEG = eeg_checkset( EEG );
        %     filtDat = EEG.data;
        %     clear EEG
        %     figure, plot(time(1:1000),dat(47,1:1000));
        %     figure, plot(time(1:1000),filtDat(47,1:1000));
        %
        
        st.neg1 = pos(find(typ==6));
        st.neg2 = pos(find(typ==9));
        st.pos1 = pos(find(typ==5));
        st.pos2 = pos(find(typ==10));
        
        ed.neg1 = st.neg1+sampleRate-1;
        ed.neg2 = st.neg2+sampleRate-1;
        ed.pos1 = st.pos1+sampleRate-1;
        ed.pos2 = st.pos2+sampleRate-1;
        
  %       electrode_pos = find(strcmp(label,'Cz')==1);
        electrode_pos = find(strcmp(label,'FCz')==1);
        stk=stkData(st,ed,stk,electrode_pos,dat);
        stk_filt=stkData(st,ed,stk_filt,electrode_pos,EEG.data);
        
        
        
        
        
    end
    % figure;
    % subplot(2,2,1), plot(mean(stk.neg1)), title('Neg1')
    % subplot(2,2,2), plot(mean(stk.neg2)), title('Neg2')
    % subplot(2,2,3), plot(mean(stk.pos1)), title('Pos1')
    % subplot(2,2,4), plot(mean(stk.pos2)), title('Pos2')
    %figure, plot(1:512,mean(stk.neg1)-mean(mean(stk.neg1)),'-r','LineWidth',4)

    figure(5),subplot(2,3,k), plot((0:511)/sampleRate,mean(stk.neg1),'-r','LineWidth',4)
%     figure(1),subplot(2,3,k), plot((0:511)/sampleRate,mean([stk_filt.neg1; stk_filt.neg2]),'-r','LineWidth',4)
    figure(1),subplot(2,3,k), plot((0:511)/sampleRate,mean(stk_filt.neg1),'-r','LineWidth',4)
    
    figure(6),subplot(2,3,k), plot((0:511)/sampleRate,mean(stk.neg1),'-r','LineWidth',4)
    figure(2),subplot(2,3,k), plot((0:511)/sampleRate,mean(stk_filt.neg2),'-r','LineWidth',4)
    
    
    figure(7),subplot(2,3,k), plot((0:511)/sampleRate,mean(stk.neg1),'-r','LineWidth',4)
    figure(3),subplot(2,3,k), plot((0:511)/sampleRate,mean(stk_filt.pos1),'-r','LineWidth',4)
    
    
    figure(8),subplot(2,3,k), plot((0:511)/sampleRate,mean(stk.neg1),'-r','LineWidth',4)
    figure(4),subplot(2,3,k), plot((0:511)/sampleRate,mean(stk_filt.pos2),'-r','LineWidth',4)
    

%     figure(2);
%     subplot(4,3,1), plot((0:511)/sampleRate,mean(stk.neg1),'-r','LineWidth',4)
%     subplot(4,3,4), plot((0:511)/sampleRate,mean(stk_filt.neg1),'-r','LineWidth',4)
% 
%     figure(2);
%     subplot(4,3,1), plot((0:511)/sampleRate,mean(stk.neg1),'-r','LineWidth',4)
%     subplot(4,3,4), plot((0:511)/sampleRate,mean(stk_filt.neg1),'-r','LineWidth',4)
%     
    
%     figure(2);
%     subplot(2,1,1), plot((0:511)/sampleRate,mean(stk.neg2),'-r','LineWidth',4)
%     subplot(2,1,2), plot((0:511)/sampleRate,mean(stk_filt.neg2),'-r','LineWidth',4)
%     
%     figure(3);
%     subplot(2,1,1), plot((0:511)/sampleRate,mean(stk.pos1),'-r','LineWidth',4)
%     subplot(2,1,2), plot((0:511)/sampleRate,mean(stk_filt.pos1),'-r','LineWidth',4)
%     
%     figure(4);
%     subplot(2,1,1), plot((0:511)/sampleRate,mean(stk.pos2),'-r','LineWidth',4)
%     subplot(2,1,2), plot((0:511)/sampleRate,mean(stk_filt.pos2),'-r','LineWidth',4)
end



function stk=stkData(st,ed,stk,electrode_pos,dat)
    for j=1:length(st.neg1)
        stk.neg1 = [stk.neg1; dat(electrode_pos,st.neg1(j):ed.neg1(j))];
        %         plot(1:512,dat(electrode_pos,st.neg1(j):ed.neg1(j)),'--');
        %         hold on
    end
    for j=1:length(st.neg2)
        stk.neg2 = [stk.neg2; dat(electrode_pos,st.neg2(j):ed.neg2(j))];
    end
    for j=1:length(st.pos1)
        stk.pos1 = [stk.pos1; dat(electrode_pos,st.pos1(j):ed.pos1(j))];
    end
    for j=1:length(st.pos2)
        stk.pos2 = [stk.pos2; dat(electrode_pos,st.pos2(j):ed.pos2(j))];
    end
end