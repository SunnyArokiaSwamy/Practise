function [Xtrain,Ytrain,Xtest,Ytest]=reorder(TrainData,TestData,categories,electrode_numb,equal)

kp=0;kn=0;ko=0;
for i=1:length(TrainData.Pe)
    for j=1:length(TrainData.Pe{1, i})
        tmp = TrainData.Pe{1, i}{j, 1};
        kp=kp+1;
        Trn_P_pot(:,:,1,kp) = tmp(electrode_numb,:);
    end
end
for i=1:length(TrainData.Ne)
    for j=1:length(TrainData.Ne{1, i})
        tmp = TrainData.Ne{1, i}{j, 1};
        kn=kn+1;
        Trn_N_pot(:,:,1,kn) = tmp(electrode_numb,:);
    end
end
for i=1:length(TrainData.Other)
    for j=1:length(TrainData.Other{1, i})
        tmp = TrainData.Other{1, i}{j, 1};
        ko=ko+1;
        Trn_O_pot(:,:,1,ko) = tmp(electrode_numb,:);
    end
end

kp=0;kn=0;ko=0;
for i=1:length(TestData.Pe)
    for j=1:length(TestData.Pe{1, i})
        tmp = TestData.Pe{1, i}{j, 1};
        kp=kp+1;
        Tst_P_pot(:,:,1,kp) = tmp(electrode_numb,:);
    end
end
for i=1:length(TestData.Ne)
    for j=1:length(TestData.Ne{1, i})
        tmp = TestData.Ne{1, i}{j, 1};
        kn=kn+1;
        Tst_N_pot(:,:,1,kn) = tmp(electrode_numb,:);
    end
end
for i=1:length(TestData.Other)
    for j=1:length(TestData.Other{1, i})
        tmp = TestData.Other{1, i}{j, 1};
        ko=ko+1;
        Tst_O_pot(:,:,1,ko) = tmp(electrode_numb,:);
    end
end

if categories==3
    Ytrain = [ones(size(Trn_N_pot,4),1);2*ones(size(Trn_P_pot,4),1);...
        3*ones(size(Trn_O_pot,4),1)];
    Ytest = [ones(size(Tst_N_pot,4),1);2*ones(size(Tst_P_pot,4),1);...
        3*ones(size(Tst_O_pot,4),1)];
    Xtrain = cat(4,Trn_N_pot,Trn_P_pot,Trn_O_pot);
    Xtest = cat(4,Tst_N_pot,Tst_P_pot,Tst_O_pot);
else
    Ytrain = [ones(size(Trn_N_pot,4),1);ones(size(Trn_P_pot,4),1);...
        2*ones(size(Trn_O_pot,4),1)];
    Ytest = [ones(size(Tst_N_pot,4),1);ones(size(Tst_P_pot,4),1);...
        2*ones(size(Tst_O_pot,4),1)];
    Xtrain = cat(4,Trn_N_pot,Trn_P_pot,Trn_O_pot);
    Xtest = cat(4,Tst_N_pot,Tst_P_pot,Tst_O_pot);
end

end


