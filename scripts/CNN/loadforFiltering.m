function filt_EEG = loadforFiltering(EEG,f)

for i=1:length(EEG)
    data = EEG{i, 1};
    filt_EEG{i,1} = filterEEG(data,f.sampleRate,f.low,f.high,f.order,f.ref);
end



