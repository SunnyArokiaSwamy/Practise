% EEG LAB Code


for sub=1:size(data,2)
    for trail =1:no_of_trails
        eeg = data{1, sub}.run{1, trail}.eeg';     
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
        %pop_eegplot( EEG, 1, 1, 1); % To plot the eeg data DEBUG
        filt_data{1,sub}.trails{1,trail} = EEG.data(Electrode_indx,:);
        filt_data{1,sub}.position{1,trail} = data{1, sub}.run{1, trail}.header.EVENT.POS;
        filt_data{1,sub}.type{1,trail} = data{1, sub}.run{1, trail}.header.EVENT.TYP;
    end
    disp('========EEG Preprocessing done....============')
    disp('===============================================================')
end
