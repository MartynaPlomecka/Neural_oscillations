clc
clear

addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\fieldtrip-20210730'
ft_defaults

x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x

addpath('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper')

OLD = readtable('OLD.xlsx','Range','A1:A121');
YNG = readtable('YOUNG.xlsx','Range', 'A1:A104');

for subj = 4:length(subjects)

        if ~any(ismember(OLD.Subject, subjects{subj}))%z tylda jesli nie jest stary to omin(tak wiec tylda stary, bez tyldy mlody)
            continue;
        end
        datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
        cd (datapath)
        load tfrprosaccleftbleegcap
        load tfrantisaccleftbleegcap
        load tfrprosaccrightbleegcap
        load tfrantisaccrightbleegcap
        
        varsprosaccleft{subj-3} = tfrprosaccleftbleegcap;
        varsprosaccright{subj-3} = tfrprosaccrightbleegcap;
        varsantisaccleft{subj-3} = tfrantisaccleftbleegcap;
        varsantisaccright{subj-3} = tfrantisaccrightbleegcap;
        

end


varsprosaccleft = varsprosaccleft(~cellfun('isempty',varsprosaccleft));
varsprosaccright = varsprosaccright(~cellfun('isempty',varsprosaccright));
varsantisaccleft = varsantisaccleft(~cellfun('isempty',varsantisaccleft));
varsantisaccright = varsantisaccright(~cellfun('isempty',varsantisaccright));




%% compute grandaverage
cfg = [];
ga_antisaccleft = ft_freqgrandaverage(cfg, varsantisaccleft{:});
ga_antisaccright = ft_freqgrandaverage(cfg, varsantisaccright{:});
ga_prosaccleft = ft_freqgrandaverage(cfg, varsprosaccleft{:});
ga_prosaccright = ft_freqgrandaverage(cfg, varsprosaccright{:});

%% compute diff

cfg = [];
cfg.operation =  'subtract';
cfg.parameter = 'powspctrm';


% diffcueleft = ft_math(cfg, ga_anticueleft, ga_procueleft);
% diffcueright = ft_math(cfg, ga_anticueright, ga_procueright);
diffsaccleftv1 = ft_math(cfg, ga_antisaccleft, ga_prosaccright);
diffsaccleftv2 = ft_math(cfg, ga_antisaccleft, ga_prosaccleft);

diffsaccrightv1 = ft_math(cfg, ga_antisaccright, ga_prosaccleft);
diffsaccrightv2 = ft_math(cfg, ga_antisaccright, ga_prosaccright);

%% directions together


ga_antisacc = ft_freqgrandaverage([],ga_antisaccleft,ga_antisaccright);
ga_prosacc=ft_freqgrandaverage([],ga_prosaccleft,ga_prosaccright);

cfg =[];
cfg.operation = 'subtract';
cfg.parameter = 'powspctrm';
diffsacc = ft_math(cfg,ga_prosacc,ga_antisacc);
%%
% % discuss with Nicolas
% % 
% ga_prosaccleft_powspctrm = ga_prosaccleft.powspctrm 
% for i = 1:size(ga_prosaccleft_powspctrm,1)
%     for j = 1: size(ga_prosaccleft_powspctrm,2)
%         for k = 1:size(ga_prosaccleft_powspctrm,3)
%             resh_ga_prosaccleft_powspctrm(k,i,j) = ga_prosaccleft_powspctrm(i,j,k);
%         end
%     end
% end
% 
% 
% ga_prosaccleft.powspctrm = resh_ga_prosaccleft_powspctrm
% ga_prosaccleft.dimord = 'freq_time_chan'


%% plots like before

figure(1);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
 cfg.channel = {'E24''E124' 'E19' 'E4' 'E11'};
ft_singleplotTFR(cfg,ga_antisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
%try with hold on xline(0)
title('E19, E4, E11 - (around FEF) ANTI ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
 cfg.channel = {'E24''E124' 'E19' 'E4' 'E11'};
ft_singleplotTFR(cfg,ga_prosacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('E19, E4, E11 - (around FEF) PRO ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'




subplot(3,1,3);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
 cfg.channel = {'E24''E124' 'E19' 'E4' 'E11'};
ft_singleplotTFR(cfg,diffsacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('E19, E4, E11 - (around FEF) diff ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


%%

%% plots like before

figure(1);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
 cfg.channel = {'E33' 'E122' 'E22' 'E9' 'E15'};
ft_singleplotTFR(cfg,ga_antisaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
%try with hold on xline(0)
title('E124, E24, E11 - (around FEF) ANTI ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
 cfg.channel = {'E33' 'E122' 'E22' 'E9' 'E15'};
ft_singleplotTFR(cfg,ga_prosaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('E124, E24, E11 - (around FEF) PRO ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'




subplot(3,1,3);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
 cfg.channel = {'E33' 'E122' 'E22' 'E9' 'E15'};
ft_singleplotTFR(cfg,diffsaccleftv1);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('E124, E24, E11 - (around FEF) diff ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

%%
% %% %
% load ('\\130.60.169.45\methlab\Decoding_workshop\data\lay129_head.mat')
% figure;
% cfg         = [];
% cfg.figure= 'gcf'; % this stops the empty figure
% cfg.parameter = 'powspctrm';% field to be plotted on y-axis, for example 'avg', 'powspctrm' or 'cohspctrm' (default is automatic)
% 
% cfg.baselinetype ='db';
% cfg.baseline = [-1 -.5]; % baseline applied only for plotting
% cfg.layout  = lay129_head;
% % cfg.xlim    = [3 30];
% ft_multiplotER(cfg,ga_prosaccleft)
% 
% 
% %% single plot,something around FEF
% figure;
% cfg         = [];
% cfg.figure= 'gcf'; % this stops the empty figure
% cfg.baselinetype ='db';
% cfg.baseline = [-1 -.5]; % baseline applied only for plotting
% cfg.layout    = lay129_head;
% cfg.channel = {'E3','E9', 'E10', 'E15','E16','E18','E22','E23'};
% cfg.linewidth = 3;                                   
% ft_singleplotER(cfg,ga_antisaccright,ga_prosaccleft);
% set(gcf,'color','white');
% set(gca,'Fontsize',14 );
% 
% legend({'anti';'pro'})
% 
% 
% %%
% %% plot the topography of alpha activity 8-12 Hz
% figure;
% cfg         = [];
% cfg.figure= 'gcf'; % this stops the empty figure
% cfg.baselinetype ='db';
% cfg.baseline = [-1 -.5]; % baseline applied only for plotting
%  cfg.xlim = [8 12];
% cfg.layout = lay129_head;
% cfg.comment = 'no';
% cfg.marker  = 'off';
% cfg.style   = 'fill';
% % cfg.zlim    = [0 1.5];
% subplot(1,2,1);ft_topoplotER(cfg,ga_prosaccleft);
% set(gcf,'color','white');
% title('EO')
% c = colorbar;
% c.LineWidth = 1;
% c.FontSize = 14;
% title(c,'\muV^2/Hz')
% 
% subplot(1,2,2);
% ft_topoplotER(cfg,ga_antisaccleft);
% title('EC')
% c = colorbar;
% c.LineWidth = 1;
% c.FontSize = 14;
% title(c,'\muV^2/Hz')
% 
