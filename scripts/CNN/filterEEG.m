function filt_data = filterEEG(eeg_data,sampleRate,f_low,f_high,f_order,reref)

%data --> 64 x big number
%re_ref --> true/false (1/0)
%filt_data --> 64 x big number

addpath(genpath('../functions/'));
% EEG = pop_importdata('dataformat','array','nbchan',64,'data',eeg_data,'srate',sampleRate);
% EEG = eeg_checkset( EEG );
% if(reref)
%     EEG = pop_reref( EEG, []);
%     EEG = eeg_checkset( EEG );
% end
% EEG = pop_eegfiltnew(EEG, f_low,f_high,f_order,0,[]);
% EEG = eeg_checkset( EEG );
% filt_data = EEG.data;
filt_data = eeg_data;