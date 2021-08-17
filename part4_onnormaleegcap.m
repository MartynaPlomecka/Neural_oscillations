%% reference of time freq
clc
clear all
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x



%% proSACCADE LOCKED

for subj = 4:length(subjects) 
    %     try
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    
    load prosaccdata
    prosaccdata.rt = str2double(prosaccdata.rt);
    prosaccdata.trialinfo = [prosaccdata.correctness,prosaccdata.dir, prosaccdata.rt];

 

    cfg              = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 2:2:40; %if i really used 40 low pass filter, then i dont have 40hz!!! check again, maybe that was 50, then 40 is fine!                        % analysis 1 to 40 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 1 sec, in order to have 1 Hz freq resolution
    cfg.toi          = (prosaccdata.time{1}(1)+cfg.t_ftimwin(1)/2):0.05:(prosaccdata.time{1}(end)-cfg.t_ftimwin(1)/2);
    % time window "slides" from -1.5 to 1.5 sec in steps of 0.05 sec (50 ms).
    % time window from -1 to 2
    cfg.keeptrials   = 'yes'; %SINCE THE DEFAULT IS NO
    tfrprosacceegcap = ft_freqanalysis(cfg, prosaccdata);
    tfrprosacceegcap = ft_freqdescriptives(cfg, tfrprosacceegcap); 
    save tfrprosacceegcap tfrprosacceegcap
    %% now separate directions, again without the baseline
    cfg                 = [];
    cfg.trials = find(tfrprosacceegcap.trialinfo(:,2) == 0 & tfrprosacceegcap.trialinfo(:,1) == 1);%0 jest left
    tfrprosacclefteegcap = ft_freqdescriptives(cfg, tfrprosacceegcap); 
    save tfrprosacclefteegcap tfrprosacclefteegcap
    
    cfg                 = [];
    cfg.trials = find(tfrprosacceegcap.trialinfo(:,2) == 1 & tfrprosacceegcap.trialinfo(:,1) == 1);%0 jest left
    tfrprosaccrighteegcap = ft_freqdescriptives(cfg, tfrprosacceegcap); 
    save tfrprosaccrighteegcap tfrprosaccrighteegcap
      
    %% %%%%%
    %%%%%%%% HERE BASELINING STARTS
    %% do baseline first for sacc locked data
    cfg                 = [];
    cfg.baseline        = [-1.25 -1];
    cfg.baselinetype    = 'db';
    tfrblprosacceegcap           = ft_freqbaseline(cfg,tfrprosacceegcap);
    
    %% average across trials
    cfg                 = [];
    cfg.trials = find(tfrblprosacceegcap.trialinfo(:,2) == 0 & tfrblprosacceegcap.trialinfo(:,1) == 1);%0 jest left
    tfrblprosacclefteegcap = ft_freqdescriptives(cfg, tfrblprosacceegcap); %this now averages across bl corrected
    %trials, now i do the same for the right
    save tfrblprosacclefteegcap tfrblprosacclefteegcap
    %% avergae over trials first and then do baseline for left
    cfg                 = [];
    cfg.trials = find(tfrprosacceegcap.trialinfo(:,2) == 0 & tfrprosacceegcap.trialinfo(:,1) == 1);%0 jest left
    tfrprosacclefteegcap = ft_freqdescriptives(cfg, tfrprosacceegcap); %this now averages across bl corrected
    cfg                 = [];
    cfg.baseline        = [-1.25 -1];
    cfg.baselinetype    = 'db';
    tfrprosaccleftbleegcap           = ft_freqbaseline(cfg,tfrprosacclefteegcap);
    save tfrprosaccleftbleegcap tfrprosaccleftbleegcap
    %% average  across trials
    cfg                 = [];
    cfg.trials = find(tfrblprosacceegcap.trialinfo(:,2) == 1 & tfrblprosacceegcap.trialinfo(:,1) == 1);%1 is right and correct (second cond
    tfrblprosaccrighteegcap = ft_freqdescriptives(cfg, tfrblprosacceegcap); %this now averages across bl corrected
    save tfrblprosaccrighteegcap tfrblprosaccrighteegcap
    %% avergae over trials first and then do baseline for right
    cfg                 = [];
    cfg.trials = find(tfrprosacceegcap.trialinfo(:,2) == 1 & tfrprosacceegcap.trialinfo(:,1) == 1);%0 jest right
    tfrprosaccrighteegcap = ft_freqdescriptives(cfg, tfrprosacceegcap); %this now averages across bl corrected
    cfg                 = [];
    cfg.baseline        = [-1.25 -1];
    cfg.baselinetype    = 'db';
    tfrprosaccrightbleegcap           = ft_freqbaseline(cfg,tfrprosaccrighteegcap);
    save tfrprosaccrightbleegcap tfrprosaccrightbleegcap

end


for subj = 4:length(subjects) 
    %     try
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    
    load antisaccdata
    antisaccdata.rt = str2double(antisaccdata.rt);
    antisaccdata.trialinfo = [antisaccdata.correctness,antisaccdata.dir, antisaccdata.rt];

 

    cfg              = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 2:2:40; %if i really used 40 low pass filter, then i dont have 40hz!!! check again, maybe that was 50, then 40 is fine!                        % analysis 1 to 40 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 1 sec, in order to have 1 Hz freq resolution
    cfg.toi          = (antisaccdata.time{1}(1)+cfg.t_ftimwin(1)/2):0.05:(antisaccdata.time{1}(end)-cfg.t_ftimwin(1)/2);
    % time window "slides" from -1.5 to 1.5 sec in steps of 0.05 sec (50 ms).
    % time window from -1 to 2
    cfg.keeptrials   = 'yes'; %SINCE THE DEFAULT IS NO
    tfrantisacceegcap = ft_freqanalysis(cfg, antisaccdata);
     tfrantisacceegcap = ft_freqdescriptives(cfg, tfrantisacceegcap); 

    save tfrantisacceegcap tfrantisacceegcap
    
    %% now separate directions, again without the baseline
    cfg                 = [];
    cfg.trials = find(tfrantisacceegcap.trialinfo(:,2) == 0 & tfrantisacceegcap.trialinfo(:,1) == 1);%0 jest left
    tfrantisacclefteegcap = ft_freqdescriptives(cfg, tfrantisacceegcap); 
    save tfrantisacclefteegcap tfrantisacclefteegcap
    
    cfg                 = [];
    cfg.trials = find(tfrantisacceegcap.trialinfo(:,2) == 1 & tfrantisacceegcap.trialinfo(:,1) == 1);%0 jest left
    tfrantisaccrighteegcap = ft_freqdescriptives(cfg, tfrantisacceegcap); 
    save tfrantisaccrighteegcap tfrantisaccrighteegcap
      
    %% %%%%%
    %%%%%%%% HERE BASELINING STARTS
    %% do baseline first for sacc locked data
    cfg                 = [];
    cfg.baseline        = [-1.25 -1];
    cfg.baselinetype    = 'db';
    tfrblantisacceegcap           = ft_freqbaseline(cfg,tfrantisacceegcap);
    
    %% average across trials
    cfg                 = [];
    cfg.trials = find(tfrblantisacceegcap.trialinfo(:,2) == 0 & tfrblantisacceegcap.trialinfo(:,1) == 1);%0 jest left
    tfrblantisacclefteegcap = ft_freqdescriptives(cfg, tfrblantisacceegcap); %this now averages across bl corrected
    %trials, now i do the same for the right
    save tfrblantisacclefteegcap tfrblantisacclefteegcap
    %% avergae over trials first and then do baseline for left
    cfg                 = [];
    cfg.trials = find(tfrantisacceegcap.trialinfo(:,2) == 0 & tfrantisacceegcap.trialinfo(:,1) == 1);%0 jest left
    tfrantisacclefteegcap = ft_freqdescriptives(cfg, tfrantisacceegcap); %this now averages across bl corrected
    cfg                 = [];
    cfg.baseline        = [-1.25 -1];
    cfg.baselinetype    = 'db';
    tfrantisaccleftbleegcap           = ft_freqbaseline(cfg,tfrantisacclefteegcap);
    save tfrantisaccleftbleegcap tfrantisaccleftbleegcap
    %% average  across trials
    cfg                 = [];
    cfg.trials = find(tfrblantisacceegcap.trialinfo(:,2) == 1 & tfrblantisacceegcap.trialinfo(:,1) == 1);%1 is right and correct (second cond
    tfrblantisaccrighteegcap = ft_freqdescriptives(cfg, tfrblantisacceegcap); %this now averages across bl corrected
    save tfrblantisaccrighteegcap tfrblantisaccrighteegcap
    %% avergae over trials first and then do baseline for right
    cfg                 = [];
    cfg.trials = find(tfrantisacceegcap.trialinfo(:,2) == 1 & tfrantisacceegcap.trialinfo(:,1) == 1);%0 jest right
    tfrantisaccrighteegcap = ft_freqdescriptives(cfg, tfrantisacceegcap); %this now averages across bl corrected
    cfg                 = [];
    cfg.baseline        = [-1.25 -1];
    cfg.baselinetype    = 'db';
    tfrantisaccrightbleegcap           = ft_freqbaseline(cfg,tfrantisaccrighteegcap);
    save tfrantisaccrightbleegcap tfrantisaccrightbleegcap

end

