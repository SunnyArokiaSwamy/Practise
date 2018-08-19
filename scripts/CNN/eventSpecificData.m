function separatedData = eventSpecificData(filt_EEG, event, event_type)

k = 1;k2 = 1;

for i=1:length(filt_EEG)
   errp_samples=[]; oth_samples=[];
   
   temp = filt_EEG{i,1};
   position = event.pos{i,1};
   type = event.typ{i,1};
   
   % Check this part
   start_position=position(find(type == 6 | type == 9));
   end_position = start_position+512-1;
   for j=1:length(start_position)
        errp_samples = [errp_samples start_position(j):end_position(j)];
   end   
   oth_samples = 1:size(temp,2);
   oth_samples(errp_samples) = [];
   
   separatedData.erp{i,1} = temp(:,errp_samples);
   separatedData.oth{i,1} = temp(:,oth_samples); 
end