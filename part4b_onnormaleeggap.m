%% reference of time freq

%%% the same as part 4 but this time oon cue locked data
clc
clear all
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x



%% procueADE LOCKED

for subj = 4:length(subjects) 
    %     try
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    
    load procuedata
    procuedata.rt = str2double(procuedata.rt);
    procuedata.trialinfo = [procuedata.correctness,procuedata.dir, procuedata.rt];

 

    cfg              = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 2:2:40; %if i really used 40 low pass filter, then i dont have 40hz!!! check again, maybe that was 50, then 40 is fine!                        % analysis 1 to 40 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 1 sec, in order to have 1 Hz freq resolution
    cfg.toi          = (procuedata.time{1}(1)+cfg.t_ftimwin(1)/2):0.05:(procuedata.time{1}(end)-cfg.t_ftimwin(1)/2);
    % time window "slides" from -1.5 to 1.5 sec in steps of 0.05 sec (50 ms).
    % time window from -1 to 2
    cfg.keeptrials   = 'yes'; %SINCE THE DEFAULT IS NO
    tfrprocueeegcap = ft_freqanalysis(cfg, procuedata);
    save tfrprocueeegcap tfrprocueeegcap
    %% now separate directions, again without the baseline
    cfg                 = [];
    cfg.trials = find(tfrprocueeegcap.trialinfo(:,2) == 0 & tfrprocueeegcap.trialinfo(:,1) == 1);%0 jest left
    tfrprocuelefteegcap = ft_freqdescriptives(cfg, tfrprocueeegcap); 
    save tfrprocuelefteegcap tfrprocuelefteegcap
    
    cfg                 = [];
    cfg.trials = find(tfrprocueeegcap.trialinfo(:,2) == 1 & tfrprocueeegcap.trialinfo(:,1) == 1);%0 jest left
    tfrprocuerighteegcap = ft_freqdescriptives(cfg, tfrprocueeegcap); 
    save tfrprocuerighteegcap tfrprocuerighteegcap
      
    %% %%%%%
    %%%%%%%% HERE BASELINING STARTS
    %% do baseline first for cue locked data
    cfg                 = [];
    cfg.baseline        = [-.55 -.25];
    cfg.baselinetype    = 'db';
    tfrblprocueeegcap           = ft_freqbaseline(cfg,tfrprocueeegcap);
    
    %% average across trials
    cfg                 = [];
    cfg.trials = find(tfrblprocueeegcap.trialinfo(:,2) == 0 & tfrblprocueeegcap.trialinfo(:,1) == 1);%0 jest left
    tfrblprocuelefteegcap = ft_freqdescriptives(cfg, tfrblprocueeegcap); %this now averages across bl corrected
    %trials, now i do the same for the right
    save tfrblprocuelefteegcap tfrblprocuelefteegcap
    %% avergae over trials first and then do baseline for left
    cfg                 = [];
    cfg.trials = find(tfrprocueeegcap.trialinfo(:,2) == 0 & tfrprocueeegcap.trialinfo(:,1) == 1);%0 jest left
    tfrprocuelefteegcap = ft_freqdescriptives(cfg, tfrprocueeegcap); %this now averages across bl corrected
    cfg                 = [];
    cfg.baseline         = [-.55 -.25];
    cfg.baselinetype    = 'db';
    tfrprocueleftbleegcap           = ft_freqbaseline(cfg,tfrprocuelefteegcap);
    save tfrprocueleftbleegcap tfrprocueleftbleegcap
    %% average  across trials
    cfg                 = [];
    cfg.trials = find(tfrblprocueeegcap.trialinfo(:,2) == 1 & tfrblprocueeegcap.trialinfo(:,1) == 1);%1 is right and correct (second cond
    tfrblprocuerighteegcap = ft_freqdescriptives(cfg, tfrblprocueeegcap); %this now averages across bl corrected
    save tfrblprocuerighteegcap tfrblprocuerighteegcap
    %% avergae over trials first and then do baseline for right
    cfg                 = [];
    cfg.trials = find(tfrprocueeegcap.trialinfo(:,2) == 1 & tfrprocueeegcap.trialinfo(:,1) == 1);%0 jest right
    tfrprocuerighteegcap = ft_freqdescriptives(cfg, tfrprocueeegcap); %this now averages across bl corrected
    cfg                 = [];
    cfg.baseline        = [-.55 -.25];
    cfg.baselinetype    = 'db';
    tfrprocuerightbleegcap           = ft_freqbaseline(cfg,tfrprocuerighteegcap);
    save tfrprocuerightbleegcap tfrprocuerightbleegcap

end


for subj = 4:length(subjects) 
    %     try
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    
    load anticuedata
    anticuedata.rt = str2double(anticuedata.rt);
    anticuedata.trialinfo = [anticuedata.correctness,anticuedata.dir, anticuedata.rt];

 

    cfg              = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 2:2:40; %if i really used 40 low pass filter, then i dont have 40hz!!! check again, maybe that was 50, then 40 is fine!                        % analysis 1 to 40 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 1 sec, in order to have 1 Hz freq resolution
    cfg.toi          = (anticuedata.time{1}(1)+cfg.t_ftimwin(1)/2):0.05:(anticuedata.time{1}(end)-cfg.t_ftimwin(1)/2);
    % time window "slides" from -1.5 to 1.5 sec in steps of 0.05 sec (50 ms).
    % time window from -1 to 2
    cfg.keeptrials   = 'yes'; %SINCE THE DEFAULT IS NO
    tfranticueeegcap = ft_freqanalysis(cfg, anticuedata);
    save tfranticueeegcap tfranticueeegcap
    
    %% now separate directions, again without the baseline
    cfg                 = [];
    cfg.trials = find(tfranticueeegcap.trialinfo(:,2) == 0 & tfranticueeegcap.trialinfo(:,1) == 1);%0 jest left
    tfranticuelefteegcap = ft_freqdescriptives(cfg, tfranticueeegcap); 
    save tfranticuelefteegcap tfranticuelefteegcap
    
    cfg                 = [];
    cfg.trials = find(tfranticueeegcap.trialinfo(:,2) == 1 & tfranticueeegcap.trialinfo(:,1) == 1);%0 jest left
    tfranticuerighteegcap = ft_freqdescriptives(cfg, tfranticueeegcap); 
    save tfranticuerighteegcap tfranticuerighteegcap
      
    %% %%%%%
    %%%%%%%% HERE BASELINING STARTS
    %% do baseline first for cue locked data
    cfg                 = [];
    cfg.baseline        = [-.55 -.25];
    cfg.baselinetype    = 'db';
    tfrblanticueeegcap           = ft_freqbaseline(cfg,tfranticueeegcap);
    
    %% average across trials
    cfg                 = [];
    cfg.trials = find(tfrblanticueeegcap.trialinfo(:,2) == 0 & tfrblanticueeegcap.trialinfo(:,1) == 1);%0 jest left
    tfrblanticuelefteegcap = ft_freqdescriptives(cfg, tfrblanticueeegcap); %this now averages across bl corrected
    %trials, now i do the same for the right
    save tfrblanticuelefteegcap tfrblanticuelefteegcap
    %% avergae over trials first and then do baseline for left
    cfg                 = [];
    cfg.trials = find(tfranticueeegcap.trialinfo(:,2) == 0 & tfranticueeegcap.trialinfo(:,1) == 1);%0 jest left
    tfranticuelefteegcap = ft_freqdescriptives(cfg, tfranticueeegcap); %this now averages across bl corrected
    cfg                 = [];
    cfg.baseline        = [-.55 -.25];
    cfg.baselinetype    = 'db';
    tfranticueleftbleegcap           = ft_freqbaseline(cfg,tfranticuelefteegcap);
    save tfranticueleftbleegcap tfranticueleftbleegcap
    %% average  across trials
    cfg                 = [];
    cfg.trials = find(tfrblanticueeegcap.trialinfo(:,2) == 1 & tfrblanticueeegcap.trialinfo(:,1) == 1);%1 is right and correct (second cond
    tfrblanticuerighteegcap = ft_freqdescriptives(cfg, tfrblanticueeegcap); %this now averages across bl corrected
    save tfrblanticuerighteegcap tfrblanticuerighteegcap
    %% avergae over trials first and then do baseline for right
    cfg                 = [];
    cfg.trials = find(tfranticueeegcap.trialinfo(:,2) == 1 & tfranticueeegcap.trialinfo(:,1) == 1);%0 jest right
    tfranticuerighteegcap = ft_freqdescriptives(cfg, tfranticueeegcap); %this now averages across bl corrected
    cfg                 = [];
    cfg.baseline        = [-.55 -.25];
    cfg.baselinetype    = 'db';
    tfranticuerightbleegcap           = ft_freqbaseline(cfg,tfranticuerighteegcap);
    save tfranticuerightbleegcap tfranticuerightbleegcap

end

