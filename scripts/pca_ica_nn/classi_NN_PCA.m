% Using dataset for NN & PCA & ICA

clc
clear
close all

ica = 1;
if (~ica)
    load('f_S2_Cz.mat')
    stackedErrp=[];
    stackedNErrp=[];
    for i=1:6
        for j=1:10
            data.eeg = S2(i).EEG(j).Cz;
            data.pos = S2(i).EEG(j).position;
            data.typ = S2(i).EEG(j).type;
            [ERP, nERP] = Linear_stackERP(data);
            stackedErrp = [stackedErrp ERP];
            stackedNErrp = [stackedNErrp nERP];
        end
    end
    Errp = stackedErrp;
    n_Errp = stackedNErrp(:,randperm(size(stackedNErrp,2),size(stackedErrp,2)));
    Cmb_data = [Errp n_Errp];
    targets = [ones(1,size(Errp,2)) zeros(1,size(n_Errp,2));...
        zeros(1,size(Errp,2)) ones(1,size(n_Errp,2))];

    rd = randperm(size(targets,2));

    Cmb_data = Cmb_data(:,rd);
    targets = targets(:,rd);

    class_Data = [Cmb_data; targets(1,:)];
end





load('f_S2_Cz.mat')
stackedErrp=[];
stackedNErrp=[];
for i=1:6
    for j=1:10
        data.eeg = S2(i).EEG(j).Cz;
        data.pos = S2(i).EEG(j).position;
        data.typ = S2(i).EEG(j).type;
        [ERP, nERP] = Linear_stackERP(data);
        stackedErrp = [stackedErrp ERP];
        stackedNErrp = [stackedNErrp nERP];
    end
end
Errp = stackedErrp;
n_Errp = stackedNErrp(:,randperm(size(stackedNErrp,2),size(stackedErrp,2)));

Z1 = Errp;
[Zw1, T] = whitenRows(Z1); % Whitening rows
r = 128;
[Zpca1, U, mu, eigVecs] = PCA(Zw1,r); %PCA
[Zica1, W, T, mu] = kICA(Zpca1,r); %ICA


Z2 = n_Errp;
[Zw2, T] = whitenRows(Z2); % Whitening rows
r = 128;
[Zpca2, U, mu, eigVecs] = PCA(Zw2,r); %PCA
[Zica2, W, T, mu] = kICA(Zpca2,r); %ICA

DataTrain = [Zica1 Zica2];
targets = [ones(1,size(Zica1,2)) zeros(1,size(Zica2,2));...
     zeros(1,size(Zica1,2)) ones(1,size(Zica2,2))];

rd = randperm(size(targets,2));

Cmb_data = DataTrain(:,rd);
targets = targets(:,rd);

class_Data = [Cmb_data; targets(1,:)];














function [ERP, nERP] = Linear_stackERP(data)
% This function reads the filtered EEG data &electrode info and gives the 
% separated ERP and Not ERP data Stacked towards three dimension
    E_stPoint=data.pos(find(data.typ==6 | data.typ==9));   
    E_endPoint = E_stPoint+512-1;
    N_stPoint=data.pos(find(data.typ~=6 & data.typ~=9));   
    N_endPoint = N_stPoint+512-1;  
    for i=1:length(E_stPoint)
        ERP(:,i) = data.eeg(E_stPoint(i):E_endPoint(i))';
    end
    for i=1:length(N_stPoint)
        nERP(:,i) = data.eeg(N_stPoint(i):N_endPoint(i))';
    end    
end