function [Pe,Ne,oth]=noName(str)
load(str);
cell_Ne=0;cell_Pe=0;
for i=1:10
    dat = run{1, i}.eeg';
    label = run{1, i}.header.Label;
    sampleRate = run{1, i}.header.SampleRate;
    sub = run{1, i}.header.Subject;
    sess = run{1, i}.header.Session;
    pos = run{1, i}.header.EVENT.POS;
    typ = run{1, i}.header.EVENT.TYP;
    time = (0:size(dat,2)-1)/sampleRate;
    filt_data = filterEEG(dat,sampleRate,1,10,1690,0);
    
    st.neg=pos(find(typ==6 | typ==9));
    st.pos=pos(find(typ==5 | typ==10));
    ed.neg=st.neg+sampleRate-1;
    ed.pos=st.pos+sampleRate-1;
    Ne_idx = [];Pe_idx = [];
    for j=1:length(st.neg)
        cell_Ne = cell_Ne+1;
        Ne{cell_Ne,1} = filt_data(:,st.neg(j):ed.neg(j));
        Ne_idx = [Ne_idx st.neg(j):ed.neg(j)];
    end
    for j=1:length(st.pos)
        cell_Pe = cell_Pe+1;
        Pe{cell_Pe,1} = filt_data(:,st.pos(j):ed.pos(j));
        Pe_idx = [Pe_idx st.pos(j):ed.pos(j)];
    end
    other_idx = 1:size(dat,2);
    good_idx = [Pe_idx Ne_idx];
    other_idx(good_idx) = [];
    other_data{i} = filt_data(:,other_idx);
end
k = 0;
for i=1:length(other_data)
    temp1 = other_data{1,i};
    for j=1:512:size(temp1,2)
        k = k+1;
        oth{k,1} = temp1(:,j:j+511);
    end
end