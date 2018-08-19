clc
clear
close all
T  = [];
for k=1:6
    str = strcat('..\Dataset\Subject0',num2str(k),'_s2.mat');
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
        filt_data = filterEEG(dat,sampleRate,1,10,1690,0);
        
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
        stk_filt=stkData(st,ed,stk_filt,electrode_pos,filt_data); 
        T = [T; size(dat)];
    end

end



function stk=stkData(st,ed,stk,electrode_pos,dat)
    for j=1:length(st.neg1)
        stk.neg1 = [stk.neg1; dat(electrode_pos,st.neg1(j):ed.neg1(j))];
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