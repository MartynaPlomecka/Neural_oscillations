clc
close all

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

for subj = 4:6 %41%length(subjects)
    %%
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    cd (datapath)
    load tfrblprocueleft
    load tfrblprosaccleft
    load tfrblanticueleft
    load tfrblantisaccleft
    
    load tfrblprocueright
    load tfrblprosaccright
    load tfrblanticueright
    load tfrblantisaccright
    
    
    varsprocueleft{subj-3} = tfrblprocueleft;
    varsprocueright{subj-3} = tfrblprocueright;
    varsprosaccleft{subj-3} = tfrblprosaccleft;
    varsprosaccright{subj-3} = tfrblprosaccright;
    varsanticueleft{subj-3} = tfrblanticueleft;
    varsanticueright{subj-3} = tfrblanticueright;
    varsantisaccleft{subj-3} = tfrblantisaccleft;
    varsantisaccright{subj-3} = tfrblantisaccright;
    
    
end
%% compute grandaverage

cfg = [];
ga_antisaccleft = ft_freqgrandaverage(cfg, varsantisaccleft{:});
ga_antisaccright = ft_freqgrandaverage(cfg, varsantisaccright{:});
ga_prosaccleft = ft_freqgrandaverage(cfg, varsprosaccleft{:});
ga_prosaccright = ft_freqgrandaverage(cfg, varsprosaccright{:});


ga_anticueleft = ft_freqgrandaverage(cfg, varsanticueleft{:});
ga_anticueright = ft_freqgrandaverage(cfg, varsanticueright{:});
ga_procueleft = ft_freqgrandaverage(cfg, varsprocueleft{:});
ga_procueright = ft_freqgrandaverage(cfg, varsprocueright{:});
%% compute difference

cfg = [];
cfg.operation =  'subtract'
cfg.parameter = 'powspctrm';


diffcueleft = ft_math(cfg, ga_anticueleft, ga_procueleft);
diffcueright = ft_math(cfg, ga_anticueright, ga_procueright);
diffsaccleft = ft_math(cfg, ga_antisaccleft, ga_prosaccleft);
diffsaccright = ft_math(cfg, ga_antisaccright, ga_prosaccright);






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
%% FEF
%LEFT
figure(1);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_antisaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
%try with hold on xline(0)
title('FEF ANTI left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_prosaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF PRO left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,diffsaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF DIFF left','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

%right
figure(2);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_antisaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
%try with hold on xline(0)
title('FEF ANTI right','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_prosaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF PRO','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,diffsaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF DIFF right','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


%% VLPFC left
figure(3);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_antisaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC ANTI left', 'fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_prosaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC PRO left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,diffsaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC DIFF left','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


% VLPFC right
figure(4);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_antisaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC ANTI right', 'fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_prosaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC PRO right','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,diffsaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC DIFF right','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'



%% DLPFC left
figure(5);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_antisaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC ANTI left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_prosaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC PRO left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,diffsaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC DIFF left','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


% DLPFC right
figure(6);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_antisaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC ANTI right','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_prosaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC PRO right','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,diffsaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC DIFF right','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


%% ACC left
figure(7);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'caudalanteriorcingulate L' 'caudalanteriorcingulate R' 'rostralanteriorcingulate L' 'rostralanteriorcingulate R'};
ft_singleplotTFR(cfg,ga_antisaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC ANTI left','fontsize', 12,'fontname','Corbel')
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
ft_singleplotTFR(cfg,ga_prosaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC PRO left','fontsize', 12,'fontname','Corbel')
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
ft_singleplotTFR(cfg,diffsaccleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC DIFF left','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

% ACC right
figure(8);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'caudalanteriorcingulate L' 'caudalanteriorcingulate R' 'rostralanteriorcingulate L' 'rostralanteriorcingulate R'};
ft_singleplotTFR(cfg,ga_antisaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC ANTI right','fontsize', 12,'fontname','Corbel')
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
ft_singleplotTFR(cfg,ga_prosaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC PRO right','fontsize', 12,'fontname','Corbel')
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
ft_singleplotTFR(cfg,diffsaccright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC DIFF right','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%      PLOTS          %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% cue LOCKED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FEF
%LEFT
figure(9);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_anticueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
%try with hold on xline(0)
title('FEF ANTI left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_procueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF PRO left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,diffcueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF DIFF left','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

%right
figure(10);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_anticueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
%try with hold on xline(0)
title('FEF ANTI right','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,ga_procueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF PRO','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'superiorfrontal L' 'superiorfrontal R' };
ft_singleplotTFR(cfg,diffcueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('FEF DIFF right','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
%caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


%% VLPFC left
figure(11);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_anticueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC ANTI left', 'fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_procueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC PRO left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,diffcueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC DIFF left','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


% VLPFC right
figure(12);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_anticueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC ANTI right', 'fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

subplot(3,1,2);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,ga_procueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC PRO right','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' 'parstriangularis L' 'parstriangularis R' 'parsopercularis L' 'parsopercularis R'};
ft_singleplotTFR(cfg,diffcueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('VLPFC DIFF right','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'



%% DLPFC left
figure(13);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_anticueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC ANTI left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_procueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC PRO left','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,diffcueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC DIFF left','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


% DLPFC right
figure(14);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_anticueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC ANTI right','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,ga_procueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC PRO right','fontsize', 12,'fontname','Corbel')
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
cfg.channel = {'rostralmiddlefrontal L' 'rostralmiddlefrontal R' 'caudalmiddlefrontal L' 'caudalmiddlefrontal R' };
ft_singleplotTFR(cfg,diffcueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('DLPFC DIFF right','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
% caxis([-1 1])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'


%% ACC left
figure(15);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'caudalanteriorcingulate L' 'caudalanteriorcingulate R' 'rostralanteriorcingulate L' 'rostralanteriorcingulate R'};
ft_singleplotTFR(cfg,ga_anticueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC ANTI left','fontsize', 12,'fontname','Corbel')
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
ft_singleplotTFR(cfg,ga_procueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC PRO left','fontsize', 12,'fontname','Corbel')
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
ft_singleplotTFR(cfg,diffcueleft);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC DIFF left','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'

% ACC right
figure(16);
subplot(3,1,1);
cfg=[];
cfg.figure = 'gcf';
cfg.channel = {'caudalanteriorcingulate L' 'caudalanteriorcingulate R' 'rostralanteriorcingulate L' 'rostralanteriorcingulate R'};
ft_singleplotTFR(cfg,ga_anticueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC ANTI right','fontsize', 12,'fontname','Corbel')
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
ft_singleplotTFR(cfg,ga_procueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC PRO right','fontsize', 12,'fontname','Corbel')
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
ft_singleplotTFR(cfg,diffcueright);
hold on
xline(0,'Linewidth',2)
set(gcf,'color','white');
title('ACC DIFF right','fontsize', 12,'fontname','Corbel')
ft_hastoolbox('brewermap', 1);
colormap(flipud(brewermap(64,'RdBu'))) % change the colormap
caxis([-1.5 1.5])
c = colorbar;
c.LineWidth = 1;
c.FontSize = 10;
title(c,'')%'\muV^2/Hz'



