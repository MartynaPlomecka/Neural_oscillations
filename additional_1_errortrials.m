%% reference of time freq
clc
clear all
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
path_headmodeling = '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\headmodel';
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x


%% ONLY ANTISACCADES , actually that's a part "4"of a standard pipeline


%% antiSACCADES cue locked
for subj = 23:24
        datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
        cd (datapath)
        
        load data68anticue
        
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
        tfrERRanticue = ft_freqanalysis(cfg, data68anticue);
        save tfrERRanticue tfrERRanticue
        
        %% do baseline first for cue locked data
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrblERRanticue           = ft_freqbaseline(cfg,tfrERRanticue);
        
        %% average across trials
        cfg                 = [];
        cfg.trials = find(tfrblERRanticue.trialinfo(:,2) == 0 & tfrblERRanticue.trialinfo(:,1) == 0);%0 jest left
        tfrblERRanticueleft = ft_freqdescriptives(cfg, tfrblERRanticue); %this now averages across bl corrected
        %trials, now i do the same for the right
        save tfrblERRanticueleft tfrblERRanticueleft
        %% avergae over trials first and then do baseline for left
        cfg                 = [];
        cfg.trials = find(tfrERRanticue.trialinfo(:,2) == 0 & tfrERRanticue.trialinfo(:,1) == 0);%0 jest left
        tfrERRanticueleft = ft_freqdescriptives(cfg, tfrERRanticue); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrERRanticueleftbl           = ft_freqbaseline(cfg,tfrERRanticueleft);
        save tfrERRanticueleftbl tfrERRanticueleftbl
        %% average  across trials
        cfg                 = [];
        cfg.trials = find(tfrblERRanticue.trialinfo(:,2) == 1 & tfrblERRanticue.trialinfo(:,1) == 0);%1 is right and correct (second cond
        tfrblERRanticueright = ft_freqdescriptives(cfg, tfrblERRanticue); %this now averages across bl corrected
        save tfrblERRanticueright tfrblERRanticueright
        %% avergae over trials first and then do baseline for right
        cfg                 = [];
        cfg.trials = find(tfrERRanticue.trialinfo(:,2) == 0 & tfrERRanticue.trialinfo(:,1) == 0);%0 jest right
        tfrERRanticueright = ft_freqdescriptives(cfg, tfrERRanticue); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrERRanticuerightbl           = ft_freqbaseline(cfg,tfrERRanticueright);
        save tfrERRanticuerightbl tfrERRanticuerightbl

end




%% antiSACCADE LOCKED
for subj = 23:24
        datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
        cd (datapath)
        load data68antisacc
        
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
        tfrERRantisacc = ft_freqanalysis(cfg, data68antisacc);
        save tfrERRantisacc tfrERRantisacc
        
        %% do baseline first for sacc locked data
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrblERRantisacc           = ft_freqbaseline(cfg,tfrERRantisacc);
        
        %% average across trials
        cfg                 = [];
        cfg.trials = find(tfrblERRantisacc.trialinfo(:,2) == 0 & tfrblERRantisacc.trialinfo(:,1) == 0);%0 jest left
        tfrblERRantisaccleft = ft_freqdescriptives(cfg, tfrblERRantisacc); %this now averages across bl corrected
        %trials, now i do the same for the right
        save tfrblERRantisaccleft tfrblERRantisaccleft
        %% avergae over trials first and then do baseline for left
        cfg                 = [];
        cfg.trials = find(tfrERRantisacc.trialinfo(:,2) == 0 & tfrERRantisacc.trialinfo(:,1) == 0);%0 jest left
        tfrERRantisaccleft = ft_freqdescriptives(cfg, tfrERRantisacc); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-1.25 -1];
        cfg.baselinetype    = 'db';
        tfrERRantisaccleftbl           = ft_freqbaseline(cfg,tfrERRantisaccleft);
        save tfrERRantisaccleftbl tfrERRantisaccleftbl
        %% average  across trials
        cfg                 = [];
        cfg.trials = find(tfrblERRantisacc.trialinfo(:,2) == 1 & tfrblERRantisacc.trialinfo(:,1) == 0);%1 is right and correct (second cond
        tfrblERRantisaccright = ft_freqdescriptives(cfg, tfrblERRantisacc); %this now averages across bl corrected
        save tfrblERRantisaccright tfrblERRantisaccright
        %% avergae over trials first and then do baseline for right
        cfg                 = [];
        cfg.trials = find(tfrERRantisacc.trialinfo(:,2) == 0 & tfrERRantisacc.trialinfo(:,1) == 0);%0 jest right
        tfrERRantisaccright = ft_freqdescriptives(cfg, tfrERRantisacc); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-1.25 -1];
        cfg.baselinetype    = 'db';
        tfrERRantisaccrightbl           = ft_freqbaseline(cfg,tfrERRantisaccright);
        save tfrERRantisaccrightbl tfrERRantisaccrightbl

end
