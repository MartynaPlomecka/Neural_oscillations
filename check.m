%% load data
clc
clear all
addpath('\\130.60.169.45\methlab\Neurometric\Antisaccades\fieldtrip-20210730')


x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x

for subj = 4:length(subjects)
    try
        %%
        datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
        cd (datapath)
        %     load tfrprocueleftbl
        %       load tfrprosaccleft
        % %     load tfranticueleftbl
        %      load tfrantisaccleft
        %
        %     load tfrprocuerightbl
        load tfrprosaccleft
        %     load tfranticuerightbl
        load tfrantisaccleft
        
        
        %     varsprocueleft{subj-3} = tfrprocueleftbl;
        %     varsprocueright{subj-3} = tfrprocuerightbl;
        varsprosacc{subj-3} = ft_freqdescriptives([],tfrprosaccleft);
        varsprosacc{subj-3}.cfg=[];
        %     varsanticueleft{subj-3} = tfranticueleftbl;
        %     varsanticueright{subj-3} = tfranticuerightbl;
        varsantisacc{subj-3} = ft_freqdescriptives([],tfrantisaccleft);
        varsantisacc{subj-3}.cfg=[];
    catch
    end
end
%% remove eegalab
% rmpath(genpath('\\130.60.169.45\methlab\Neurometric\Antisaccades\code\eeglab14_1_2b'))
%%
cfg = [];
cfg.spmversion       = 'spm12';
cfg.frequency          = [2 35];
cfg.latency          = [-.8 0];
cfg.method           = 'montecarlo';
%  cfg.method           = 'analytic';%
cfg.statistic        = 'ft_statfun_depsamplesT';
%  cfg.channel = {'rostralmiddlefrontal L' ,'rostralmiddlefrontal R', 'inferiorparietal R'}
%  cfg.channel = {'caudalmiddlefrontal L' 'caudalmiddlefrontal R'...
%     'rostralmiddlefrontal R' 'rostralmiddlefrontal L'...
%     'inferiorparietal R' 'inferiorparietal L' ...
%     'caudalanteriorcingulate R' 'caudalanteriorcingulate L' };
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
% cfg.clusterstatistic = 'maxsum';
% cfg.tail             = 0;
% cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 500;
cfg.neighbours       = [];
clear design
subj = 181;
design = zeros(2,2*subj);
for i = 1:subj
    design(1,i) = i;
end
for i = 1:subj
    design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design   = design;
cfg.uvar     = 1;
cfg.ivar     = 2;
%%%%% this is design for indep sample
% design = zeros(1,numel(varsprosacc) + numel(varsantisacc));
% design(1,1:numel(varsprosacc)) = 1;
% design(1,numel(varsprosacc)+1 :...
%     numel(varsprosacc)+ numel(varsantisacc)) = 2;

% cfg.design           = design;
% cfg.ivar             = 1;

[stat] = ft_freqstatistics(cfg, varsprosacc{:}, varsantisacc{:});
%%
figure;
cfg=[];
cfg.figure = 'gcf';
cfg.parameter = 'stat';
cfg.maskparameter = 'mask';
cfg.maskstyle = 'outline';
cfg.zlim  = [-3 3];
 cfg.channel = {'rostralmiddlefrontal L' ,'rostralmiddlefrontal R', 'inferiorparietal R','inferiorparietal L'};
% cfg.channel = {'inferiorparietal R' };
ft_singleplotTFR(cfg,stat);