%% only reshaping the data which will be needed for computing vts
clc
clear
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
ft_defaults
cd('\\130.60.169.45\methlab\Neurometric\Antisaccades\code\eeglab14_1_2b')
eeglab;
close all
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x

for subj = 4:14%:6%:6%54%length(subjects) %186 - BA5 didnt work, 346- BY2
    
    %%
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    keep datapath subj subjects % Tzvetan added this line to remove the leftovers from the prev subject
    load EEGprocue
    EEG=EEGprocue;
    
    %% reorganize data to be compatible with FieldTrip
    ftdata.fsample = EEG.srate;
    ftdata.dir = EEG.direction;
    ftdata.correctness = EEG.correctness;
    
    ftdata.label   = {EEG.chanlocs(:).labels};
    for trl = 1:EEG.trials
        ftdata.trial{trl}   = EEG.data(:,:,trl);
        ftdata.time{trl}    = EEG.times./1000;
    end
    %ftdata.trialinfo = trialinfopro.cues(1:trialinfopro.epochs)
    procuedata = ftdata;
    save procuedata procuedata
    clear ftdata
    
    
    
end



for subj = 4:14
   %%
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    keep datapath subj subjects % Tzvetan added this line to remove the leftovers from the prev subject
    load EEGanticue
    EEG=EEGanticue;
    
    %% reorganize data to be compatible with FieldTrip
    ftdata.fsample = EEG.srate;
    ftdata.dir = EEG.direction;
    ftdata.correctness = EEG.correctness;
    
    
    ftdata.label   = {EEG.chanlocs(:).labels};
    for trl = 1:EEG.trials
        ftdata.trial{trl}   = EEG.data(:,:,trl);
        ftdata.time{trl}    = EEG.times./1000;
    end
    %ftdata.trialinfo = trialinfopro.cues(1:trialinfopro.epochs)
    anticuedata = ftdata;
    save anticuedata anticuedata
    clear ftdata
    
end

%% saccade locked

for subj = 4:14%:6%:6%54%length(subjects) %186 - BA5 didnt work, 346- BY2
    
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    keep datapath subj subjects % Tzvetan added this line to remove the leftovers from the prev subject
    load EEGprosacc
    EEG=EEGprosacc;
    
    %% reorganize data to be compatible with FieldTrip
    ftdata.fsample = EEG.srate;
    ftdata.dir = EEG.direction;
    ftdata.correctness = EEG.correctness;
    
    ftdata.label   = {EEG.chanlocs(:).labels};
    for trl = 1:EEG.trials
        ftdata.trial{trl}   = EEG.data(:,:,trl);
        ftdata.time{trl}    = EEG.times./1000;
    end
    %ftdata.trialinfo = trialinfopro.cues(1:trialinfopro.epochs)
    prosaccdata = ftdata;
    save prosaccdata prosaccdata
    clear ftdata
    
    
    
end


for subj = 4:14%5%:6
   
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    keep datapath subj subjects % Tzvetan added this line to remove the leftovers from the prev subject
    load EEGantisacc
    EEG=EEGantisacc;
    
    % reorganize data to be compatible with FieldTrip
    ftdata.fsample = EEG.srate;
    ftdata.dir = EEG.direction;
    ftdata.correctness = EEG.correctness;
    
    
    ftdata.label   = {EEG.chanlocs(:).labels};
    for trl = 1:EEG.trials
        ftdata.trial{trl}   = EEG.data(:,:,trl);
        ftdata.time{trl}    = EEG.times./1000;
    end
    %ftdata.trialinfo = trialinfopro.cues(1:trialinfopro.epochs)
    antisaccdata = ftdata;
    save antisaccdata antisaccdata
    clear ftdata
    
end