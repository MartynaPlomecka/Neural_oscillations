 clc
clear
x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\');
subjects = {x.name};
clear x
addpath '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\fieldtrip-20200109'
path_data= '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna';
path_headmodeling = '\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\headmodel';
load(fullfile(path_headmodeling, 'lf68norm.mat'));
load(fullfile(path_headmodeling, 'headmodel_eeg.mat'));
load(fullfile(path_headmodeling, 'elec_aligned.mat'));
load(fullfile(path_headmodeling, 'dkatlas.mat'));
load(fullfile(path_headmodeling, 'templatesourcesheet68.mat'));

%%
for subj = 25:length(subjects)
    %     try
    %         close all
    datapath = strcat(path_data, '/', subjects{subj});
    cd(datapath)
    %
    load procuedata
    
    procuedata.rt = str2double(procuedata.rt);
    procuedata.combined = [procuedata.correctness,procuedata.dir, procuedata.rt];
    
    cfg = [];
    cfg.covariance='yes';
    %     cfg.covariancewindow=[0 1];
    avg = ft_timelockanalysis(cfg,procuedata);
    
    clear virtdata
    for parcel=1:68 % n pracels, because of the brain atlas
        cfg=[];
        cfg.method='lcmv';
        cfg.sourcemodel=lf{parcel};
        cfg.headmodel=headmodel_eeg;
        cfg.lcmv.keepfilter='yes';
        cfg.lcmv.fixedori = 'yes';
        cfg.lcmv.lambda    = '5%';
        cfg.elec    = elec_aligned;
        sourceavg=ft_sourceanalysis(cfg, avg);
        %%
        spatialfilter = cat(1,sourceavg.avg.filter{:});%
        for ii=1:length(procuedata.trial)
            virtdata.trial{ii} = spatialfilter*procuedata.trial{ii};
        end
        virtdata.label = {dkatlas.tissuelabel{parcel}};
        virtdata.time = procuedata.time;
        virtdata.fsample = procuedata.fsample;
        virtdata.trialinfo = procuedata.combined;
        allvirt{parcel} = virtdata;
    end
    % append data
    cfg = [];
    data68procue = ft_appenddata(cfg,allvirt{:});
    save(fullfile(datapath, 'data68procue.mat'), 'data68procue');
    
    %         catch
    %         %display('a')
    %     end
end



%%  prosaccdata
for subj = 25:length(subjects)%:length(subjects)
    %     try
    close all
    datapath = strcat(path_data, '/', subjects{subj});
    cd(datapath)
    
    load prosaccdata
    prosaccdata.rt = str2double(prosaccdata.rt);
    
    
    prosaccdata.combined = [prosaccdata.correctness,prosaccdata.dir,prosaccdata.rt];
    
    % keep covariance in the output
    cfg = [];
    cfg.covariance='yes';
    %     cfg.covariancewindow=[0 1];
    avg = ft_timelockanalysis(cfg,prosaccdata);
    
    clear virtdata
    for parcel=1:68 % n pracels, because of the brain atlas
        cfg=[];
        cfg.method='lcmv';
        cfg.sourcemodel=lf{parcel};
        cfg.headmodel=headmodel_eeg;
        cfg.lcmv.keepfilter='yes';
        cfg.lcmv.fixedori = 'yes';
        cfg.lcmv.lambda    = '5%';
        cfg.elec    = elec_aligned;
        sourceavg=ft_sourceanalysis(cfg, avg);
        %%
        spatialfilter = cat(1,sourceavg.avg.filter{:});%
        for ii=1:length(prosaccdata.trial)
            virtdata.trial{ii} = spatialfilter*prosaccdata.trial{ii};
        end
        virtdata.label = {dkatlas.tissuelabel{parcel}};
        virtdata.time = prosaccdata.time;
        virtdata.fsample = prosaccdata.fsample;
        virtdata.trialinfo = prosaccdata.combined;
        allvirt{parcel} = virtdata;
    end
    %append data
    cfg = [];
    data68prosacc = ft_appenddata(cfg,allvirt{:});
    save(fullfile(datapath, 'data68prosacc.mat'), 'data68prosacc');
    %     catch
    %     end
end




%%  antisaccdata
for subj = 25:length(subjects)%:length(subjects)
    %     try
    close all
    datapath = strcat(path_data, '/', subjects{subj});
    cd(datapath)
    %
    load antisaccdata
    antisaccdata.rt = str2double(antisaccdata.rt);
    antisaccdata.combined = [antisaccdata.correctness,antisaccdata.dir, antisaccdata.rt];
    
    % keep covariance in the output
    cfg = [];
    cfg.covariance='yes';
    %  cfg.covariancewindow=[0 1];
    avg = ft_timelockanalysis(cfg,antisaccdata);
    
    clear virtdata
    for parcel=1:68 % n pracels, because of the brain atlas
        cfg=[];
        cfg.method='lcmv';
        cfg.sourcemodel=lf{parcel};
        cfg.headmodel=headmodel_eeg;
        cfg.lcmv.keepfilter='yes';
        cfg.lcmv.fixedori = 'yes';
        cfg.lcmv.lambda    = '5%';
        cfg.elec    = elec_aligned;
        sourceavg=ft_sourceanalysis(cfg, avg);
        %%
        spatialfilter = cat(1,sourceavg.avg.filter{:});%
        for ii=1:length(antisaccdata.trial)
            virtdata.trial{ii} = spatialfilter*antisaccdata.trial{ii};
        end
        virtdata.label = {dkatlas.tissuelabel{parcel}};
        virtdata.time = antisaccdata.time;
        virtdata.fsample = antisaccdata.fsample;
        virtdata.trialinfo = antisaccdata.combined;
        allvirt{parcel} = virtdata;
    end
    %% append data
    cfg = [];
    data68antisacc = ft_appenddata(cfg,allvirt{:});
    save(fullfile(datapath, 'data68antisacc.mat'), 'data68antisacc');
    %     catch
    %     end
end


%% start with anticuedata

for subj = 25:length(subjects)%:length(subjects)
    %     try
    close all
    datapath = strcat(path_data, '/', subjects{subj});
    cd(datapath)
    %
    load anticuedata
    anticuedata.rt = str2double(anticuedata.rt);
    
    anticuedata.combined = [anticuedata.correctness,anticuedata.dir, anticuedata.rt];
    
    % keep covariance in the output
    cfg = [];
    cfg.covariance='yes';
    %     cfg.covariancewindow=[0 1];
    avg = ft_timelockanalysis(cfg,anticuedata);
    
    clear virtdata
    for parcel=1:68 % n pracels, because of the brain atlas
        cfg=[];
        cfg.method='lcmv';
        cfg.sourcemodel=lf{parcel};
        cfg.headmodel=headmodel_eeg;
        cfg.lcmv.keepfilter='yes';
        cfg.lcmv.fixedori = 'yes';
        cfg.lcmv.lambda    = '5%';
        cfg.elec    = elec_aligned;
        sourceavg=ft_sourceanalysis(cfg, avg);
        
        spatialfilter = cat(1,sourceavg.avg.filter{:});%
        for ii=1:length(anticuedata.trial)
            virtdata.trial{ii} = spatialfilter*anticuedata.trial{ii};
        end
        virtdata.label = {dkatlas.tissuelabel{parcel}};
        virtdata.time = anticuedata.time;
        virtdata.fsample = anticuedata.fsample;
        virtdata.trialinfo = anticuedata.combined;
        allvirt{parcel} = virtdata;
    end
    % append data
    cfg = [];
    data68anticue = ft_appenddata(cfg,allvirt{:});
    save(fullfile(datapath, 'data68anticue.mat'), 'data68anticue');
    
    
    %     catch
    %
    %     end
end