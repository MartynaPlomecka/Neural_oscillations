clc
clear

cd('\\130.60.169.45\methlab\Neurometric\Antisaccades\code\eeglab14_1_2b')
eeglab;
close all

x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\')
subjects = {x.name};
clear x

for subj = 177:length(subjects)
    
    
    datapath = strcat('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\',subjects{subj});
    
    cd (datapath)
    
    if exist(strcat('gip_',subjects{subj},'_AS_EEG.mat')) > 0
        datafile= strcat('gip_',subjects{subj},'_AS_EEG.mat');
        load (datafile)
    elseif exist(strcat('oip_',subjects{subj},'_AS_EEG.mat')) > 0
        datafile= strcat('oip_',subjects{subj},'_AS_EEG.mat');
        load (datafile)
    end
    
    
    
    
    %% Re-reference to average reference
    EEG = pop_reref(EEG,[]);
    
    %% triggers renaming
    countblocks = 1;
    for e = 1:length(EEG.event)
        if strcmp(EEG.event(e).type, 'boundary')
            countblocks = countblocks + 1;
            continue;
        end
        if countblocks == 2 || countblocks == 3 || countblocks == 4 % antisaccade blocks
            if strcmp(EEG.event(e).type,'10  ') % change 10 to 12 for AS
                EEG.event(e).type = 'cue_anti_left';
            elseif strcmp(EEG.event(e).type,'11  ')
                EEG.event(e).type = 'cue_anti_right'; % change 11 to 13 for AS
            end
            
            if strcmp(EEG.event(e).type,'40  ')
                EEG.event(e).type = '41  ';
            end
            
        end
        
        if countblocks == 1 || countblocks == 5 %prosaccade blocks
            if strcmp(EEG.event(e).type,'10  ') % change numbers to words
                EEG.event(e).type = 'cue_pro_left';
            elseif strcmp(EEG.event(e).type,'11  ')
                EEG.event(e).type = 'cue_pro_right'; % change numbers to words
            end
        end
        
        
    end
    
    EEG.event(strcmp('boundary',{EEG.event.type})) = [];
    rmEventsIx = strcmp('L_fixation',{EEG.event.type});
    rmEv =  EEG.event(rmEventsIx);
    EEG.event(rmEventsIx) = [];
    EEG.event(1).dir = []; %left or right
    EEG.event(1).cond = [];%pro or anti
    %% rename EEG.event.type
    previous = '';
    for e = 1:length(EEG.event)
        if strcmp(EEG.event(e).type, 'L_saccade')
            if strcmp(previous, 'cue_pro_left')
                EEG.event(e).type = 'saccade_pro_left';
                EEG.event(e).cond = 'pro';
                EEG.event(e).dir = 'left';
                %pro left
            elseif strcmp(previous, 'cue_pro_right')
                EEG.event(e).type = 'saccade_pro_right';
                EEG.event(e).cond = 'pro';
                EEG.event(e).dir = 'right';
            elseif strcmp(previous, 'cue_anti_left')
                EEG.event(e).type = 'saccade_anti_left';
                EEG.event(e).cond = 'anti';
                EEG.event(e).dir = 'left';
            elseif strcmp(previous, 'cue_anti_right')
                EEG.event(e).type = 'saccade_anti_right';
                EEG.event(e).cond = 'anti';
                EEG.event(e).dir = 'right';
            else
                EEG.event(e).type = 'invalid';
            end
        end
        if ~strcmp(EEG.event(e).type, 'L_fixation') ...
                && ~strcmp(EEG.event(e).type, 'L_blink')
            previous = EEG.event(e).type;
        end
    end
    
    %% remove everything from EEG.event which is not saccade or trigger sent by me from the stimulus pc
    
    tmpinv=find(strcmp({EEG.event.type}, 'invalid') | strcmp({EEG.event.type}, 'L_blink')) ;
    EEG.event(tmpinv)=[];
    
    %% renaming errors
    
    
    for e = 1:length(EEG.event)
        
        if strcmp(EEG.event(e).type, 'saccade_anti_left') && ( EEG.event(e).sac_startpos_x > EEG.event(e).sac_endpos_x)
            EEG.event(e).accuracy = 'error_anti_sacc';
            EEG.event(e-1).accuracy = 'error_anti_cue';
            
        elseif strcmp(EEG.event(e).type, 'saccade_anti_left') && (EEG.event(e).sac_startpos_x < EEG.event(e).sac_endpos_x)
            EEG.event(e).accuracy = 'correct_anti_sacc';
            EEG.event(e-1).accuracy = 'correct_anti_cue';
            
        elseif strcmp(EEG.event(e).type, 'saccade_anti_right') && (EEG.event(e).sac_startpos_x <EEG.event(e).sac_endpos_x)
            EEG.event(e).accuracy = 'error_anti_sacc';
            EEG.event(e-1).accuracy = 'error_anti_cue';
            
        elseif strcmp(EEG.event(e).type, 'saccade_anti_right') && (EEG.event(e).sac_startpos_x >EEG.event(e).sac_endpos_x)
            EEG.event(e).accuracy = 'correct_anti_sacc';
            EEG.event(e-1).accuracy = 'correct_anti_cue';
            
        elseif strcmp(EEG.event(e).type, 'saccade_pro_left') && ( EEG.event(e).sac_startpos_x < EEG.event(e).sac_endpos_x)
            EEG.event(e).accuracy = 'error_pro_sacc';
            EEG.event(e-1).accuracy = 'error_pro_cue';
            
        elseif strcmp(EEG.event(e).type, 'saccade_pro_left') && (EEG.event(e).sac_startpos_x > EEG.event(e).sac_endpos_x)
            EEG.event(e).accuracy = 'correct_pro_sacc';
            EEG.event(e-1).accuracy = 'correct_pro_cue';
            
        elseif strcmp(EEG.event(e).type, 'saccade_pro_right') && (EEG.event(e).sac_startpos_x >EEG.event(e).sac_endpos_x)
            EEG.event(e).accuracy = 'error_pro_sacc';
            EEG.event(e-1).accuracy = 'error_pro_cue';
            
        elseif strcmp(EEG.event(e).type, 'saccade_pro_right') && (EEG.event(e).sac_startpos_x <EEG.event(e).sac_endpos_x)
            EEG.event(e).accuracy = 'correct_pro_sacc';
            EEG.event(e-1).accuracy = 'correct_pro_cue';
            
            
        else
            EEG.event(e).accuracy = 'NA';
        end
    end
    
    %% CALCULATE RT FOR EACH TRIALS
    
    
    for e = 1:length(EEG.event)
        
        if strcmp(EEG.event(e).type, 'saccade_anti_left')
            EEG.event(e).rt = (EEG.event(e).latency - EEG.event(e-1).latency)*2;%for sacc
            EEG.event(e-1).rt = (EEG.event(e).latency - EEG.event(e-1).latency)*2; %for the "pair"cue
            
            
        elseif strcmp(EEG.event(e).type, 'saccade_anti_right')
            EEG.event(e).rt = (EEG.event(e).latency - EEG.event(e-1).latency)*2;
            EEG.event(e-1).rt = (EEG.event(e).latency - EEG.event(e-1).latency)*2;
            
            
        elseif strcmp(EEG.event(e).type, 'saccade_pro_left')
            EEG.event(e).rt = (EEG.event(e).latency - EEG.event(e-1).latency)*2;
            EEG.event(e-1).rt = (EEG.event(e).latency - EEG.event(e-1).latency)*2;
            
            
        elseif strcmp(EEG.event(e).type, 'saccade_pro_right')
            EEG.event(e).rt = (EEG.event(e).latency - EEG.event(e-1).latency)*2;
            EEG.event(e-1).rt = (EEG.event(e).latency - EEG.event(e-1).latency)*2;
            
            
        else
            EEG.event(e).rt = 'NA';
        end
    end
    
    %% amplitude too small
    tmperrsacc6=find(strcmp({EEG.event.type}, 'saccade_pro_right') ...
        & [EEG.event.sac_amplitude]<1.5);
    tmperrsacc7=find(strcmp({EEG.event.type}, 'saccade_pro_left') ...
        & [EEG.event.sac_amplitude]<1.5);
    tmperrsacc8=find(strcmp({EEG.event.type}, 'saccade_anti_left') ...
        & [EEG.event.sac_amplitude]<1.5);
    tmperrsacc9=find(strcmp({EEG.event.type}, 'saccade_anti_right') ...
        & [EEG.event.sac_amplitude]<1.5);
    tmperr69=[tmperrsacc6 (tmperrsacc6-1) tmperrsacc7 (tmperrsacc7-1) tmperrsacc8 (tmperrsacc8-1) tmperrsacc9 (tmperrsacc9-1)];
    EEG.event(tmperr69)=[];
    
    clear tmperrsacc1 tmperrsacc2 tmperrsacc3 tmperrsacc4 tmperrsacc6 tmperrsacc7 tmperrsacc8 tmperrsacc9
    
    
    
    %% delete cues where there was no saccade afterwards
    
    tmperrcue10=  find(strcmp({EEG.event.type}, 'cue_pro_left')) ;
    for i=1:length(tmperrcue10)
        pos = tmperrcue10(i);
        if ~ (strcmp(EEG.event(pos+1).type , 'saccade_pro_left'))
            
            EEG.event(pos).type='missingsacc'; %cue
        end
    end
    
    %%11
    tmperrcue11 =   find(strcmp({EEG.event.type}, 'cue_pro_right'))    ;
    for i=1:length(tmperrcue11)
        pos = tmperrcue11(i);
        if ~ (strcmp(EEG.event(pos+1).type , 'saccade_pro_right'))
            
            EEG.event(pos).type='missingsacc'; %cue
        end
    end
    
    
    tmperrcue12=  find(strcmp({EEG.event.type}, 'cue_anti_left')) ;
    for i=1:length(tmperrcue12)
        pos = tmperrcue12(i);
        if ~ (strcmp(EEG.event(pos+1).type , 'saccade_anti_left'))
            
            EEG.event(pos).type='missingsacc'; %cue
        end
    end
    
    %%11
    tmperrcue13 =   find(strcmp({EEG.event.type}, 'cue_anti_right'))    ;
    for i=1:length(tmperrcue13)
        pos = tmperrcue13(i);
        if ~ (strcmp(EEG.event(pos+1).type , 'saccade_anti_right'))
            
            EEG.event(pos).type='missingsacc'; %cue
        end
    end
    
    
    
    
    tmpinv=find(strcmp({EEG.event.type}, 'missingsacc')) ;
    EEG.event(tmpinv)=[];
    
    
    
    
    %% delete saccades and cues when the saccade comes faster than 100ms after cue
    tmpevent=length(EEG.event);
    saccpro=find(strcmp({EEG.event.type},'saccade_pro_right')==1 | strcmp({EEG.event.type},'saccade_pro_left')==1); % find rows where there is a saccade
    saccanti=find(strcmp({EEG.event.type},'saccade_anti_right')==1 | strcmp({EEG.event.type},'saccade_anti_left')==1);%find rows where there is a saccade
    
    for b=1:size(saccpro,2)
        
        if (EEG.event(saccpro(1,b)).latency-EEG.event(saccpro(1,b)-1).latency)<50 %50 because 100ms
            EEG.event(saccpro(b)).type='too_fast'; %saccade
            EEG.event(saccpro(b)-1).type = 'too_fast'; %cue
        end
    end
    
    for b=1:size(saccanti,2)
        
        if (EEG.event(saccanti(b)).latency-EEG.event(saccanti(1,b)-1).latency)<50
            EEG.event(saccanti(b)-1).type ='too_fast';
            EEG.event(saccanti(b)).type ='too_fast';
        end
        
    end
    
    tmpinv=find(strcmp({EEG.event.type}, 'too_fast')) ;
    EEG.event(tmpinv)=[];
    
    clear tmpinv
    
    
    
    %%     epoching and showing which saccade/cue is important
    %procue
    EEGprocue= pop_epoch(EEG, {'cue_pro_right','cue_pro_left'}, [-1.5, 1.5]);
    for e= 1:size(EEGprocue.epoch,2)
        for i= 1:size(EEGprocue.epoch(e).eventlatency,2)
            if EEGprocue.epoch(e).eventlatency{1,i}== 0 && strcmp(EEGprocue.epoch(e).eventtype{1,i}, 'cue_pro_left')
                EEGprocue.epoch(e).eventtype{1,i} = 'OKcue_pro_left';
                index = EEGprocue.epoch(e).event(i);
                EEGprocue.event(index).type  = 'OKcue_pro_left';
            elseif EEGprocue.epoch(e).eventlatency{1,i}==0 && strcmp(EEGprocue.epoch(e).eventtype{1,i}, 'cue_pro_right')
                EEGprocue.epoch(e).eventtype{1,i} = 'OKcue_pro_right';
                index = EEGprocue.epoch(e).event(i);
                EEGprocue.event(index).type  = 'OKcue_pro_right';
            else EEGprocue.epoch(e).eventtype{1,i} = 'notok';
            end
        end
    end
    
    
    %anticue
    EEGanticue= pop_epoch(EEG, {'cue_anti_right','cue_anti_left'}, [-1.5, 1.5]);
    for e= 1:size(EEGanticue.epoch,2)
        for i= 1:size(EEGanticue.epoch(e).eventlatency,2)
            if EEGanticue.epoch(e).eventlatency{1,i}== 0 && strcmp(EEGanticue.epoch(e).eventtype{1,i}, 'cue_anti_left')
                EEGanticue.epoch(e).eventtype{1,i} = 'OKcue_anti_left';
                index = EEGanticue.epoch(e).event(i);
                EEGanticue.event(index).type  = 'OKcue_anti_left';
            elseif EEGanticue.epoch(e).eventlatency{1,i}==0 && strcmp(EEGanticue.epoch(e).eventtype{1,i}, 'cue_anti_right')
                EEGanticue.epoch(e).eventtype{1,i} = 'OKcue_anti_right';
                index = EEGanticue.epoch(e).event(i);
                EEGanticue.event(index).type  = 'OKcue_anti_right';
            else EEGanticue.epoch(e).eventtype{1,i} = 'notok';
            end
        end
    end
    
    % pro sacc
    EEGprosacc= pop_epoch(EEG, {'saccade_pro_right','saccade_pro_left'}, [-1.5, 1.5]);
    for e= 1:size(EEGprosacc.epoch,2)
        for i= 1:size(EEGprosacc.epoch(e).eventlatency,2)
            if EEGprosacc.epoch(e).eventlatency{1,i}== 0 && strcmp(EEGprosacc.epoch(e).eventtype{1,i}, 'saccade_pro_left')
                EEGprosacc.epoch(e).eventtype{1,i} = 'OKsaccade_pro_left';
                index = EEGprosacc.epoch(e).event(i);
                EEGprosacc.event(index).type  = 'OKsaccade_pro_left';
            elseif EEGprosacc.epoch(e).eventlatency{1,i}==0 && strcmp(EEGprosacc.epoch(e).eventtype{1,i}, 'saccade_pro_right')
                EEGprosacc.epoch(e).eventtype{1,i} = 'OKsaccade_pro_right';
                index = EEGprosacc.epoch(e).event(i);
                EEGprosacc.event(index).type  = 'OKsaccade_pro_right';
            else EEGprosacc.epoch(e).eventtype{1,i} = 'notok';
            end
        end
    end
    
    % anti, sacc locked
    
    EEGantisacc= pop_epoch(EEG, {'saccade_anti_right','saccade_anti_left'}, [-1.5, 1.5]);
    for e= 1:size(EEGantisacc.epoch,2)
        for i= 1:size(EEGantisacc.epoch(e).eventlatency,2)
            if EEGantisacc.epoch(e).eventlatency{1,i}== 0 && strcmp(EEGantisacc.epoch(e).eventtype{1,i}, 'saccade_anti_left')
                EEGantisacc.epoch(e).eventtype{1,i} = 'OKsaccade_anti_left';
                index = EEGantisacc.epoch(e).event(i)
                EEGantisacc.event(index).type  = 'OKsaccade_anti_left';
            elseif EEGantisacc.epoch(e).eventlatency{1,i}==0 && strcmp(EEGantisacc.epoch(e).eventtype{1,i}, 'saccade_anti_right')
                EEGantisacc.epoch(e).eventtype{1,i} = 'OKsaccade_anti_right';
                index = EEGantisacc.epoch(e).event(i)
                EEGantisacc.event(index).type  = 'OKsaccade_anti_right';
            else EEGantisacc.epoch(e).eventtype{1,i} = 'notok';
            end
        end
    end
    
    
    % sanity check -> how many epochs
    % trialinfopro.epochs=size(EEGprocue.data, 3);
    % trialinfoanti.epochs=size(EEGanticue.data, 3);
    
    
    
    
    %% add new substructure -> info about the direction
    
    %sacc locked
    
    tmpprosacc=find(strcmp({EEGprosacc.event.type}, 'OKsaccade_pro_right') | strcmp({EEGprosacc.event.type}, 'OKsaccade_pro_left') );
    tmpantisacc=find(strcmp({EEGantisacc.event.type}, 'OKsaccade_anti_right') | strcmp({EEGantisacc.event.type}, 'OKsaccade_anti_left') );
    
    rightprosacc= find(strcmp({EEGprosacc.event(tmpprosacc).type},'OKsaccade_pro_right')==1);
    leftprosacc= find(strcmp({EEGprosacc.event(tmpprosacc).type},'OKsaccade_pro_left')==1);
    rightantisacc= find(strcmp({EEGantisacc.event(tmpantisacc).type},'OKsaccade_anti_right')==1);
    leftantisacc= find(strcmp({EEGantisacc.event(tmpantisacc).type},'OKsaccade_anti_left')==1);
    
    EEGprosacc.direction  = nan(length(tmpprosacc),1);
    EEGprosacc.direction(leftprosacc)= 0;
    EEGprosacc.direction(rightprosacc)= 1;
    
    EEGantisacc.direction  = nan(length(tmpantisacc),1);
    EEGantisacc.direction(leftantisacc)= 0;
    EEGantisacc.direction(rightantisacc)= 1;
    
    %cue locked
    
    
    tmpprocue=find(strcmp({EEGprocue.event.type}, 'OKcue_pro_right') | strcmp({EEGprocue.event.type}, 'OKcue_pro_left') );
    tmpanticue=find(strcmp({EEGanticue.event.type}, 'OKcue_anti_right') | strcmp({EEGanticue.event.type}, 'OKcue_anti_left') );
    
    rightprocue= find(strcmp({EEGprocue.event(tmpprocue).type},'OKcue_pro_right')==1);
    leftprocue= find(strcmp({EEGprocue.event(tmpprocue).type},'OKcue_pro_left')==1);
    rightanticue= find(strcmp({EEGanticue.event(tmpanticue).type},'OKcue_anti_right')==1);
    leftanticue= find(strcmp({EEGanticue.event(tmpanticue).type},'OKcue_anti_left')==1);
    
    EEGprocue.direction  = nan(length(tmpprocue),1);
    EEGprocue.direction(leftprocue)= 0;
    EEGprocue.direction(rightprocue)= 1;
    
    EEGanticue.direction  = nan(length(tmpanticue),1);
    EEGanticue.direction(leftanticue)= 0;
    EEGanticue.direction(rightanticue)= 1;
    
    
    
    %% %% add new substructure -> info about the RT
    
    %% prosaccades
    
    for e= 1:size(EEGprosacc.event,2)
        if (strcmp(EEGprosacc.event(e).type, 'OKsaccade_pro_right') )
            EEGprosacc.event(e).case = 'important';
        elseif (strcmp(EEGprosacc.event(e).type, 'OKsaccade_pro_left'))
            EEGprosacc.event(e).case = 'important';
            
        else
            EEGprosacc.event(e).case = 'notimportant';
        end
    end
    
    tmpinv=find(strcmp({EEGprosacc.event.case}, 'notimportant'));
    EEGprosacc.event(tmpinv)=[];
    clear tmpinv
    
    
    EEGprosacc.rt = {EEGprosacc.event.rt}.';
    
    
    
    
    % antisaccades
    for e= 1:size(EEGantisacc.event,2)
        if (strcmp(EEGantisacc.event(e).type, 'OKsaccade_anti_right') )
            EEGantisacc.event(e).case = 'important';
        elseif (strcmp(EEGantisacc.event(e).type, 'OKsaccade_anti_left'))
            EEGantisacc.event(e).case = 'important';
            
        else
            EEGantisacc.event(e).case = 'notimportant';
        end
    end
    
    tmpinv=find(strcmp({EEGantisacc.event.case}, 'notimportant'))
    EEGantisacc.event(tmpinv)=[];
    clear tmpinv
    
    
    EEGantisacc.rt = {EEGantisacc.event.rt}.';
    
    
    
    %procues
    
    for e= 1:size(EEGprocue.event,2)
        if (strcmp(EEGprocue.event(e).type, 'OKcue_pro_right') )
            EEGprocue.event(e).case = 'important';
        elseif (strcmp(EEGprocue.event(e).type, 'OKcue_pro_left'))
            EEGprocue.event(e).case = 'important';
            
        else
            EEGprocue.event(e).case = 'notimportant';
        end
    end
    
    tmpinv=find(strcmp({EEGprocue.event.case}, 'notimportant'));
    EEGprocue.event(tmpinv)=[];
    clear tmpinv
    
    
    EEGprocue.rt = {EEGprocue.event.rt}.';
    
    
    
    
    % anticues
    for e= 1:size(EEGanticue.event,2)
        if (strcmp(EEGanticue.event(e).type, 'OKcue_anti_right') )
            EEGanticue.event(e).case = 'important';
        elseif (strcmp(EEGanticue.event(e).type, 'OKcue_anti_left'))
            EEGanticue.event(e).case = 'important';
            
        else
            EEGanticue.event(e).case = 'notimportant';
        end
    end
    
    tmpinv=strcmp({EEGanticue.event.case}, 'notimportant');
    EEGanticue.event(tmpinv)=[];
    clear tmpinv
    
    
    EEGanticue.rt = {EEGanticue.event.rt}.';
    
    
    
    %% add new substructure -> info about the correctness
    
    %sacc locked
    
    tmpprosacc=find(strcmp({EEGprosacc.event.accuracy}, 'correct_pro_sacc') | strcmp({EEGprosacc.event.accuracy}, 'error_pro_sacc') );
    tmpantisacc=find(strcmp({EEGantisacc.event.accuracy}, 'correct_anti_sacc') | strcmp({EEGantisacc.event.accuracy}, 'error_anti_sacc') );
    
    correctprosacc= find(strcmp({EEGprosacc.event(tmpprosacc).accuracy},'correct_pro_sacc')==1);
    errorprosacc= find(strcmp({EEGprosacc.event(tmpprosacc).accuracy},'error_pro_sacc')==1);
    correctantisacc= find(strcmp({EEGantisacc.event(tmpantisacc).accuracy},'correct_anti_sacc')==1);
    errorantisacc= find(strcmp({EEGantisacc.event(tmpantisacc).accuracy},'error_anti_sacc')==1);
    
    EEGprosacc.correctness  = nan(length(tmpprosacc),1);
    EEGprosacc.correctness(errorprosacc)= 0;
    EEGprosacc.correctness(correctprosacc)= 1;
    
    EEGantisacc.correctness  = nan(length(tmpantisacc),1);
    EEGantisacc.correctness(errorantisacc)= 0;
    EEGantisacc.correctness(correctantisacc)= 1;
    
    %cue locked
    
    tmpprocue=find(strcmp({EEGprocue.event.accuracy}, 'correct_pro_cue') | strcmp({EEGprocue.event.accuracy}, 'error_pro_cue') );
    tmpanticue=find(strcmp({EEGanticue.event.accuracy}, 'correct_anti_cue') | strcmp({EEGanticue.event.accuracy}, 'error_anti_cue') );
    
    correctprocue= find(strcmp({EEGprocue.event(tmpprocue).accuracy},'correct_pro_cue')==1);
    errorprocue= find(strcmp({EEGprocue.event(tmpprocue).accuracy},'error_pro_cue')==1);
    correctanticue= find(strcmp({EEGanticue.event(tmpanticue).accuracy},'correct_anti_cue')==1);
    erroranticue= find(strcmp({EEGanticue.event(tmpanticue).accuracy},'error_anti_cue')==1);
    
    EEGprocue.correctness  = nan(length(tmpprocue),1);
    EEGprocue.correctness(errorprocue)= 0;
    EEGprocue.correctness(correctprocue)= 1;
    
    EEGanticue.correctness  = nan(length(tmpanticue),1);
    EEGanticue.correctness(erroranticue)= 0;
    EEGanticue.correctness(correctanticue)= 1;
    
    
    %% save epoched pro, sacc locked and cue locked
    if length(EEGprocue.direction) == length(EEGprocue.epoch)
        save EEGprocue EEGprocue
    end
    
    if length(EEGprosacc.direction) == length(EEGprosacc.epoch)
        save EEGprosacc EEGprosacc
    end
    
    %% save epoched anti, sacc locked and cue locked
    if length(EEGanticue.direction) == length(EEGanticue.epoch)
        save EEGanticue EEGanticue
    end
    
    if length(EEGantisacc.direction) == length(EEGantisacc.epoch)
        save EEGantisacc EEGantisacc
    end
end
