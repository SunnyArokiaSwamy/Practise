function [Xtrain,Ytrain,Xtest,Ytest] = prepareforCNN(Xtrain,Ytrain,Xtest,Ytest)       

idx1 = find(Ytrain==1);
idx2 = find(Ytrain==2);
idx3 = find(Ytrain==3);
idx2 = randi([min(idx2) max(idx2)],length(idx1),1);
idx3 = randi([min(idx3) max(idx3)],length(idx1),1);
Xtrain = cat(4,Xtrain(:,:,:,idx1),Xtrain(:,:,:,idx2),Xtrain(:,:,:,idx3));
Ytrain = cat(1,Ytrain(idx1),Ytrain(idx2),Ytrain(idx3));
rd = randperm(length(Ytrain));
Xtrain = Xtrain(:,:,:,rd);
Ytrain = Ytrain(rd,1);


idx1 = find(Ytest==1);
idx2 = find(Ytest==2);
idx3 = find(Ytest==3);
idx2 = randi([min(idx2) max(idx2)],length(idx1),1);
idx3 = randi([min(idx3) max(idx3)],length(idx1),1);
Xtest = cat(4,Xtest(:,:,:,idx1),Xtest(:,:,:,idx2),Xtest(:,:,:,idx3));
Ytest = cat(1,Ytest(idx1),Ytest(idx2),Ytest(idx3));
rd = randperm(length(Ytest));
Xtest = Xtest(:,:,:,rd);
Ytest = Ytest(rd,1);

