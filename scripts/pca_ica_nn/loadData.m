clc
clear
close all

events = 6; % Type of event
numOfSub = 1; % Number of Subjects
numOfEvents = 1; % Number of events of each subject
dataERP = [];
dataNotERP = [];

for i=1:numOfSub
    for j=1:numOfEvents
        for k=1:length(events)
            eveTyp = events(k);
            str = strcat('subject0',num2str(i),'_s',num2str(j));
            X = load(str);            
            [stackedERPdata, stackedERPidx, stackedNotERPdata, stackedNotERPidx]...
                = exploreOpen(X,eveTyp);
            for l = 1:size(stackedERPdata,2)
                dataERP = [dataERP; stackedERPdata{1,l}];
                dataNotERP = [dataNotERP; stackedNotERPdata{1,l}];
            end            
        end
    end
end





%% Functions


function [stackedERPdata, stackedERPidx, stackedNotERPdata, stackedNotERPidx] = exploreOpen(X,eveTyp)   
    X = X.run;
    l = length(X);    
    for i=1:l
        stackERPidx = [];
        dat = X{1,i};
        eeg = dat.eeg;
        stackNotERPidx = 1:size(eeg,1);
        header = dat.header;
        SampleRate = header.SampleRate;
        %label = header.Label;
        eventType = header.EVENT.TYP;
        eventPos = header.EVENT.POS;       
        erpDataStPoint = eventPos(find(eventType==eveTyp));
        numERP = length(erpDataStPoint);
        for k=1:numERP            
            stackERPidx = [stackERPidx erpDataStPoint(k):erpDataStPoint(k)+SampleRate-1];           
        end
        stackNotERPidx(stackERPidx) = [];
        eegERP = eeg(stackERPidx,:);
        eegNotERP = eeg(stackNotERPidx,:);
        stackedERPdata{i} = eegERP;
        stackedERPidx{i} = stackERPidx;        
        stackedNotERPdata{i} = eegNotERP;
        stackedNotERPidx{i} = stackNotERPidx;       
    end
end
