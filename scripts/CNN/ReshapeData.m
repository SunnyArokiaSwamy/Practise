function [Errp, normal] = ReshapeData(separatedData,electrodes)
k1 = 1;k2 =1;
for i=1:10
    
    temp1 = separatedData.erp{i, 1}(electrodes,:);
    temp2 = separatedData.oth{i, 1}(electrodes,:);
    
    % Check
    for j=1:512:size(temp1,2)
        Errp{k1,1} = temp1(:,j:j+512-1);
        k1 = k1+1;
    end
    for j=1:512:size(temp2,2)
        normal{k2,1} = temp2(:,j:j+512-1);
        k2 = k2+1;
    end    
end