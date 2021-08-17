

clc
clear all
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
path_headmodeling = '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\headmodel';
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
%subjects = {subjects{4:end-3}}';
clear x


for subj = 4:7

    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
%     load tfrprocueleftbl
      load tfrprosaccleftbl
%     load tfranticueleftbl
     load tfrantisaccleftbl
    
%     load tfrprocuerightbl
    load tfrprosaccrightbl
%     load tfranticuerightbl
    load tfrantisaccrightbl
    
    
%     varsprocueleft{subj-3} = tfrprocueleftbl;
%     varsprocueright{subj-3} = tfrprocuerightbl;
    varsprosaccleft{subj-3} = tfrprosaccleftbl;
    varsprosaccright{subj-3} = tfrprosaccrightbl;
%     varsanticueleft{subj-3} = tfranticueleftbl;
%     varsanticueright{subj-3} = tfranticuerightbl;
    varsantisaccleft{subj-3} = tfrantisaccleftbl;
    varsantisaccright{subj-3} = tfrantisaccrightbl;
 
end
%% compute grandaverage

addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
ft_defaults


cfg = [];
ga_antisaccleft = ft_freqgrandaverage(cfg, varsantisaccleft{:});
ga_antisaccright = ft_freqgrandaverage(cfg, varsantisaccright{:});
ga_prosaccleft = ft_freqgrandaverage(cfg, varsprosaccleft{:});
ga_prosaccright = ft_freqgrandaverage(cfg, varsprosaccright{:});
%%
cfg         = [];
cfg.figure= 'gcf'; % this stops the empty figure
cfg.baselinetype ='db';
cfg.baseline = [-1 -.5]; % baseline applied only for plotting
cfg.layout  = lay129_head
cfg.xlim    = [3 40];
figure;
ft_multiplotER(cfg,ga_antisaccright,ga_prosaccleft)
%,ga_prosaccleft);