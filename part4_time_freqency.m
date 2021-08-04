%% reference of time freq
clc
clear all
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
path_headmodeling = '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\headmodel';
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x
%% PROSACCADES
for subj = 4:6%length(subjects) %186 - BA5 didnt work, 346- BY2
  
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    
    load data68procue
    load data68prosacc
    
    % http://www.fieldtriptoolbox.org/tutorial/timefrequencyanalysis/
    cfg              = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 2:2:40; %if i really used 40 low pass filter, then i dont have 40hz!!! check again, maybe that was 50, then 40 is fine!                        % analysis 1 to 40 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 1 sec, in order to have 1 Hz freq resolution
    cfg.toi          = (data68procue.time{1}(1)+cfg.t_ftimwin(1)/2):0.05:(data68procue.time{1}(end)-cfg.t_ftimwin(1)/2);
    % time window "slides" from -1.5 to 1.5 sec in steps of 0.05 sec (50 ms).
    % time window from -1 to 2
    cfg.keeptrials   = 'yes'; %SINCE THE DEFAULT IS NO
    tfrprocue = ft_freqanalysis(cfg, data68procue);
    save tfrprocue tfrprocue
    
    %% do baseline first for cue locked data
    cfg                 = [];
    cfg.baseline        = [-.5 -.25];
    cfg.baselinetype    = 'db';
    tfrblprocue           = ft_freqbaseline(cfg,tfrprocue);
    %% average across trials
    cfg                 = [];
    cfg.trials = find(tfrblprocue.trialinfo(:,2) == 0 & tfrblprocue.trialinfo(:,1) == 1);%0 jest left
    tfrblprocueleft = ft_freqdescriptives(cfg, tfrblprocue); %this now averages across bl corrected
    %trials, now i do the same for the right
    save tfrblprocueleft tfrblprocueleft
    %%
    cfg                 = [];
    cfg.trials = find(tfrblprocue.trialinfo(:,2) == 1 & tfrblprocue.trialinfo(:,1) == 1);%1 is right and correct (second cond
    tfrblprocueright = ft_freqdescriptives(cfg, tfrblprocue); %this now averages across bl corrected
    save tfrblprocueright tfrblprocueright
    
    
    %% SACCADE LOCKED
    cfg              = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 2:2:40; %if i really used 40 low pass filter, then i dont have 40hz!!! check again, maybe that was 50, then 40 is fine!                        % analysis 1 to 40 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 1 sec, in order to have 1 Hz freq resolution
    cfg.toi          = (data68prosacc.time{1}(1)+cfg.t_ftimwin(1)/2):0.05:(data68prosacc.time{1}(end)-cfg.t_ftimwin(1)/2);
    % time window "slides" from -1.5 to 1.5 sec in steps of 0.05 sec (50 ms).
    % time window from -1 to 2
    cfg.keeptrials   = 'yes'; %SINCE THE DEFAULT IS NO
    tfrprosacc = ft_freqanalysis(cfg, data68prosacc);
    save tfrprosacc tfrprosacc
    
    %% do baseline first for sacc locked data
    cfg                 = [];
    cfg.baseline        = [-.5 -.25];
    cfg.baselinetype    = 'db';
    tfrblprosacc        = ft_freqbaseline(cfg,tfrprosacc);
    %% average across trials
    cfg                 = [];
    cfg.trials = find(tfrblprosacc.trialinfo(:,2) == 0 & tfrblprosacc.trialinfo(:,1) == 1);%0 jest left
    tfrblprosaccleft = ft_freqdescriptives(cfg, tfrblprosacc); %this now averages across bl corrected
    %trials, now i do the same for the right
    save tfrblprosaccleft tfrblprosaccleft
    %%
    cfg                 = [];
    cfg.trials = find(tfrblprosacc.trialinfo(:,2) == 1 & tfrblprosacc.trialinfo(:,1) == 1);%1 is right
    tfrblprosaccright = ft_freqdescriptives(cfg, tfrblprosacc); %this now averages across bl corrected
    save tfrblprosaccright tfrblprosaccright
    
 
end

%% antiSACCADES
for subj = 4:6
  
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    
    load data68anticue
    load data68antisacc
    
    % http://www.fieldtriptoolbox.org/tutorial/timefrequencyanalysis/
    cfg              = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 2:2:40; %if i really used 40 low pass filter, then i dont have 40hz!!! check again, maybe that was 50, then 40 is fine!                        % analysis 1 to 40 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 1 sec, in order to have 1 Hz freq resolution
    cfg.toi          = (data68anticue.time{1}(1)+cfg.t_ftimwin(1)/2):0.05:(data68anticue.time{1}(end)-cfg.t_ftimwin(1)/2);
    % time window "slides" from -1.5 to 1.5 sec in steps of 0.05 sec (50 ms).
    % time window from -1 to 2
    cfg.keeptrials   = 'yes'; %SINCE THE DEFAULT IS NO
    tfranticue = ft_freqanalysis(cfg, data68anticue);
    save tfranticue tfranticue
    
    %% do baseline first for cue locked data
    cfg                 = [];
    cfg.baseline        = [-.5 -.25];
    cfg.baselinetype    = 'db';
    tfrblanticue           = ft_freqbaseline(cfg,tfranticue);
    %% average across trials
    cfg                 = [];
    cfg.trials = find(tfrblanticue.trialinfo(:,2) == 0 & tfrblanticue.trialinfo(:,1) == 1);%0 jest left
    tfrblanticueleft = ft_freqdescriptives(cfg, tfrblanticue); %this now averages across bl corrected
    %trials, now i do the same for the right
    save tfrblanticueleft tfrblanticueleft
    %%
    cfg                 = [];
    cfg.trials = find(tfrblanticue.trialinfo(:,2) == 1 & tfrblanticue.trialinfo(:,1) == 1);%1 is right
    tfrblanticueright = ft_freqdescriptives(cfg, tfrblanticue); %this now averages across bl corrected
    save tfrblanticueright tfrblanticueright
    
    
    %% SACCADE LOCKED
    cfg              = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 2:2:40; %if i really used 40 low pass filter, then i dont have 40hz!!! check again, maybe that was 50, then 40 is fine!                        % analysis 1 to 40 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 1 sec, in order to have 1 Hz freq resolution
    cfg.toi          = (data68antisacc.time{1}(1)+cfg.t_ftimwin(1)/2):0.05:(data68antisacc.time{1}(end)-cfg.t_ftimwin(1)/2);
    % time window "slides" from -1.5 to 1.5 sec in steps of 0.05 sec (50 ms).
    % time window from -1 to 2
    cfg.keeptrials   = 'yes'; %SINCE THE DEFAULT IS NO
    tfrantisacc = ft_freqanalysis(cfg, data68antisacc);
    save tfrantisacc tfrantisacc
    
    %% do baseline first for sacc locked data
    cfg                 = [];
    cfg.baseline        = [-.5 -.25];
    cfg.baselinetype    = 'db';
    tfrblantisacc        = ft_freqbaseline(cfg,tfrantisacc);
    %% average across trials
    cfg                 = [];
    cfg.trials = find(tfrblantisacc.trialinfo(:,2) == 0 & tfrblantisacc.trialinfo(:,1) == 1);%0 jest left
    tfrblantisaccleft = ft_freqdescriptives(cfg, tfrblantisacc); %this now averages across bl corrected
    %trials, now i do the same for the right
    save tfrblantisaccleft tfrblantisaccleft
    %%
    cfg                 = [];
    cfg.trials = find(tfrblantisacc.trialinfo(:,2) == 1 & tfrblantisacc.trialinfo(:,1) == 1);%1 is right
    tfrblantisaccright = ft_freqdescriptives(cfg, tfrblantisacc); %this now averages across bl corrected
    save tfrblantisaccright tfrblantisaccright
    
 
end


