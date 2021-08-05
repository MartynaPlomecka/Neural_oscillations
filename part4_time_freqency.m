%% reference of time freq
clc
clear all
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
path_headmodeling = '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\headmodel';
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x

%% PROSACCADES cue locked
for subj = 6:7%length(subjects) %186 - BA5 didnt work, 346- BY2
    try
        datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
        cd (datapath)
        
        load data68procue
        
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
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrblprocue           = ft_freqbaseline(cfg,tfrprocue);
        
        %% average across trials
        cfg                 = [];
        cfg.trials = find(tfrblprocue.trialinfo(:,2) == 0 & tfrblprocue.trialinfo(:,1) == 1);%0 jest left
        tfrblprocueleft = ft_freqdescriptives(cfg, tfrblprocue); %this now averages across bl corrected
        %trials, now i do the same for the right
        save tfrblprocueleft tfrblprocueleft
        %% avergae over trials first and then do baseline for left
        cfg                 = [];
        cfg.trials = find(tfrprocue.trialinfo(:,2) == 0 & tfrprocue.trialinfo(:,1) == 1);%0 jest left
        tfrprocueleft = ft_freqdescriptives(cfg, tfrprocue); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrprocueleftbl           = ft_freqbaseline(cfg,tfrprocueleft);
        save tfrprocueleftbl tfrprocueleftbl
        %% average  across trials
        cfg                 = [];
        cfg.trials = find(tfrblprocue.trialinfo(:,2) == 1 & tfrblprocue.trialinfo(:,1) == 1);%1 is right and correct (second cond
        tfrblprocueright = ft_freqdescriptives(cfg, tfrblprocue); %this now averages across bl corrected
        save tfrblprocueright tfrblprocueright
        %% avergae over trials first and then do baseline for right
        cfg                 = [];
        cfg.trials = find(tfrprocue.trialinfo(:,2) == 0 & tfrprocue.trialinfo(:,1) == 1);%0 jest right
        tfrprocueright = ft_freqdescriptives(cfg, tfrprocue); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrprocuerightbl           = ft_freqbaseline(cfg,tfrprocueright);
        save tfrprocuerightbl tfrprocuerightbl
    catch
    end
end



%% proSACCADE LOCKED

for subj = 6:7%length(subjects) %186 - BA5 didnt work, 346- BY2
    try
        load data68prosacc
        
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
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrblprosacc           = ft_freqbaseline(cfg,tfrprosacc);
        
        %% average across trials
        cfg                 = [];
        cfg.trials = find(tfrblprosacc.trialinfo(:,2) == 0 & tfrblprosacc.trialinfo(:,1) == 1);%0 jest left
        tfrblprosaccleft = ft_freqdescriptives(cfg, tfrblprosacc); %this now averages across bl corrected
        %trials, now i do the same for the right
        save tfrblprosaccleft tfrblprosaccleft
        %% avergae over trials first and then do baseline for left
        cfg                 = [];
        cfg.trials = find(tfrprosacc.trialinfo(:,2) == 0 & tfrprosacc.trialinfo(:,1) == 1);%0 jest left
        tfrprosaccleft = ft_freqdescriptives(cfg, tfrprosacc); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-1.25 -1];
        cfg.baselinetype    = 'db';
        tfrprosaccleftbl           = ft_freqbaseline(cfg,tfrprosaccleft);
        save tfrprosaccleftbl tfrprosaccleftbl
        %% average  across trials
        cfg                 = [];
        cfg.trials = find(tfrblprosacc.trialinfo(:,2) == 1 & tfrblprosacc.trialinfo(:,1) == 1);%1 is right and correct (second cond
        tfrblprosaccright = ft_freqdescriptives(cfg, tfrblprosacc); %this now averages across bl corrected
        save tfrblprosaccright tfrblprosaccright
        %% avergae over trials first and then do baseline for right
        cfg                 = [];
        cfg.trials = find(tfrprosacc.trialinfo(:,2) == 0 & tfrprosacc.trialinfo(:,1) == 1);%0 jest right
        tfrprosaccright = ft_freqdescriptives(cfg, tfrprosacc); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-1.25 -1];
        cfg.baselinetype    = 'db';
        tfrprosaccrightbl           = ft_freqbaseline(cfg,tfrprosaccright);
        save tfrprosaccrightbl tfrprosaccrightbl
    catch
    end
end


%% antiSACCADES cue locked


for subj = 4:6%length(subjects) %186 - BA5 didnt work, 346- BY2
    try
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
        tfranticue = ft_freqanalysis(cfg, data68anticue);
        save tfranticue tfranticue
        
        %% do baseline first for cue locked data
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrblanticue           = ft_freqbaseline(cfg,tfranticue);
        
        %% average across trials
        cfg                 = [];
        cfg.trials = find(tfrblanticue.trialinfo(:,2) == 0 & tfrblanticue.trialinfo(:,1) == 1);%0 jest left
        tfrblanticueleft = ft_freqdescriptives(cfg, tfrblanticue); %this now averages across bl corrected
        %trials, now i do the same for the right
        save tfrblanticueleft tfrblanticueleft
        %% avergae over trials first and then do baseline for left
        cfg                 = [];
        cfg.trials = find(tfranticue.trialinfo(:,2) == 0 & tfranticue.trialinfo(:,1) == 1);%0 jest left
        tfranticueleft = ft_freqdescriptives(cfg, tfranticue); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfranticueleftbl           = ft_freqbaseline(cfg,tfranticueleft);
        save tfranticueleftbl tfranticueleftbl
        %% average  across trials
        cfg                 = [];
        cfg.trials = find(tfrblanticue.trialinfo(:,2) == 1 & tfrblanticue.trialinfo(:,1) == 1);%1 is right and correct (second cond
        tfrblanticueright = ft_freqdescriptives(cfg, tfrblanticue); %this now averages across bl corrected
        save tfrblanticueright tfrblanticueright
        %% avergae over trials first and then do baseline for right
        cfg                 = [];
        cfg.trials = find(tfranticue.trialinfo(:,2) == 0 & tfranticue.trialinfo(:,1) == 1);%0 jest right
        tfranticueright = ft_freqdescriptives(cfg, tfranticue); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfranticuerightbl           = ft_freqbaseline(cfg,tfranticueright);
        save tfranticuerightbl tfranticuerightbl
        
    catch
    end
end




%% antiSACCADE LOCKED
for subj = 6:7%length(subjects) %186 - BA5 didnt work, 346- BY2
    try
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
        tfrantisacc = ft_freqanalysis(cfg, data68antisacc);
        save tfrantisacc tfrantisacc
        
        %% do baseline first for sacc locked data
        cfg                 = [];
        cfg.baseline        = [-.55 -.25];
        cfg.baselinetype    = 'db';
        tfrblantisacc           = ft_freqbaseline(cfg,tfrantisacc);
        
        %% average across trials
        cfg                 = [];
        cfg.trials = find(tfrblantisacc.trialinfo(:,2) == 0 & tfrblantisacc.trialinfo(:,1) == 1);%0 jest left
        tfrblantisaccleft = ft_freqdescriptives(cfg, tfrblantisacc); %this now averages across bl corrected
        %trials, now i do the same for the right
        save tfrblantisaccleft tfrblantisaccleft
        %% avergae over trials first and then do baseline for left
        cfg                 = [];
        cfg.trials = find(tfrantisacc.trialinfo(:,2) == 0 & tfrantisacc.trialinfo(:,1) == 1);%0 jest left
        tfrantisaccleft = ft_freqdescriptives(cfg, tfrantisacc); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-1.25 -1];
        cfg.baselinetype    = 'db';
        tfrantisaccleftbl           = ft_freqbaseline(cfg,tfrantisaccleft);
        save tfrantisaccleftbl tfrantisaccleftbl
        %% average  across trials
        cfg                 = [];
        cfg.trials = find(tfrblantisacc.trialinfo(:,2) == 1 & tfrblantisacc.trialinfo(:,1) == 1);%1 is right and correct (second cond
        tfrblantisaccright = ft_freqdescriptives(cfg, tfrblantisacc); %this now averages across bl corrected
        save tfrblantisaccright tfrblantisaccright
        %% avergae over trials first and then do baseline for right
        cfg                 = [];
        cfg.trials = find(tfrantisacc.trialinfo(:,2) == 0 & tfrantisacc.trialinfo(:,1) == 1);%0 jest right
        tfrantisaccright = ft_freqdescriptives(cfg, tfrantisacc); %this now averages across bl corrected
        cfg                 = [];
        cfg.baseline        = [-1.25 -1];
        cfg.baselinetype    = 'db';
        tfrantisaccrightbl           = ft_freqbaseline(cfg,tfrantisaccright);
        save tfrantisaccrightbl tfrantisaccrightbl
    catch
    end
end
