
%% ROIs
%% FEF -> caudal boundary of the superior frontal gyrus in the DK atlas,
%both L and R so based on the labels: area 57 and area 58
%superiorfrontal L, superiorfrontal R
%% VLPFC ->
% rostralmiddlefrontal L and rostralmiddlefrontal R (areas 5+6)
% AND caudalmiddlefrontal L + caudalmiddlefrontal R (areas 55+56)
% AND parstriangularis L +parstriangularis R (areas 41 +42)
% AND parsopercularis L +parsopercularis R (areas 37, 38)
%% DLPFC -> Defined within middle frontal gyrus, which is, again, here:
%rostralmiddlefrontal L and rostralmiddlefrontal R (areas 5+6)
%AND caudalmiddlefrontal L + caudalmiddlefrontal R (areas 55+56)
%% ACC ->
%caudalanteriorcingulate L + caudalanteriorcingulate R (areas 3+4)
% AND rostralanteriorcingulate L + rostralanteriorcingulate R ( (areas 53+54)
%% code starts here


clc
clear all
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
path_headmodeling = '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\headmodel';
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
%subjects = {subjects{4:end-3}}';
clear x

nsub = 50; %length(subjects)
varspro = cell(1,3);
varsanti = cell(1,3);
powspctrm = zeros(nsub, 68,20,40);

for subj = 4:24%14 %41%length(subjects)
    try
        %%
        datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
        cd (datapath)
        load tfranticueleftbl
        load tfrERRanticueleftbl
        load  tfrantisaccleftbl
        load tfrERRantisaccleftbl
        
        load tfranticuerightbl
        load tfrERRanticuerightbl
        load  tfrantisaccrightbl
        load tfrERRantisaccrightbl
        
        
        varsanticueleft{subj-3} = tfranticueleftbl;
        varsanticueright{subj-3} = tfranticuerightbl;
        varsantisaccleft{subj-3} = tfrantisaccleftbl;
        varsantisaccright{subj-3} = tfrantisaccrightbl;
        
        varsERRanticueleft{subj-3} = tfrERRanticueleftbl;
        varsERRanticueright{subj-3} = tfrERRanticuerightbl;
        varsERRantisaccleft{subj-3} = tfrERRantisaccleftbl;
        varsERRantisaccright{subj-3} = tfrERRantisaccrightbl;
        
    catch
    end
end
%% compute grandaverage

addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
ft_defaults

varsERRantisaccright = varsERRantisaccright(~cellfun('isempty',varsERRantisaccright));
varsERRantisaccleft = varsERRantisaccleft(~cellfun('isempty',varsERRantisaccleft));
varsantisaccright = varsantisaccright(~cellfun('isempty',varsantisaccright));
varsantisaccleft = varsantisaccleft(~cellfun('isempty',varsantisaccleft));

cfg = [];
ga_antisaccleft = ft_freqgrandaverage(cfg,  varsantisaccleft{:});
ga_antisaccright = ft_freqgrandaverage(cfg, varsantisaccright{:});
ga_ERRantisaccleft = ft_freqgrandaverage(cfg, varsERRantisaccleft{:});
ga_ERRantisaccright = ft_freqgrandaverage(cfg, varsERRantisaccright{:});

%% compute difference

cfg = [];
cfg.operation =  'subtract';
cfg.parameter = 'powspctrm';

diffsaccleft = ft_math(cfg, ga_antisaccleft, ga_ERRantisaccleft);
diffsaccright = ft_math(cfg, ga_antisaccright, ga_ERRantisaccright);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%      PLOTS          %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SACC LOCKED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %%DIRECTIONS TOGETHER

ga_antisacc = ft_freqgrandaverage([],ga_antisaccleft,ga_antisaccright);
ga_ERRantisacc=ft_freqgrandaverage([],ga_ERRantisaccleft,ga_ERRantisaccright);

cfg =[];
cfg.operation = 'subtract';
cfg.parameter = 'powspctrm';
diffsacc = ft_math(cfg,ga_antisacc,ga_ERRantisacc);


%% FEF
figure(1);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_antisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
%try with hold on xline(0)
title('FEF ANTI ','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_ERRantisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF error anti ','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,diffsacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF DIFF ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap

%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


%% DLPFC all
figure(2);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_antisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC ANTI','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
cfg.zlim = 'absmax';
ft_singleplotTFR(cfg,ga_ERRantisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC error anti ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,3);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,diffsacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC DIFF ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

%% VLPFC
figure(3);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
cfg.zlim = 'absmax';% or [-.5 .5]
ft_singleplotTFR(cfg,ga_antisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC ANTI', 'fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-2 2])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_ERRantisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC error anti ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


subplot(3,1,3);
cfg=[];
cfg.figure = 'gcf';
cfg.zlim = 'absmax';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,diffsacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC DIFF','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

%% ACC
figure(4);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'caudalanteriorcingulate L' 'caudalanteriorcingulate R' 'rostralanteriorcingulate L' 'rostralanteriorcingulate R'};
ft_singleplotTFR(cfg,ga_antisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC ANTI ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'caudalanteriorcingulate L' 'caudalanteriorcingulate R' 'rostralanteriorcingulate L' 'rostralanteriorcingulate R'};
ft_singleplotTFR(cfg,ga_ERRantisacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC PRO ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


subplot(3,1,3);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'caudalanteriorcingulate L' 'caudalanteriorcingulate R' 'rostralanteriorcingulate L' 'rostralanteriorcingulate R'};
ft_singleplotTFR(cfg,diffsacc);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC DIFF ','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'
