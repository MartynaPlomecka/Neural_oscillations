clc
clear

cd('\\130.60.169.45\methlab\Neurometric\Antisaccades\code\eeglab14_1_2b')
eeglab;
close all

x = dir('\\130.60.169.45\methlab\Neurometric\Antisaccades\new_paper\martyna\')
subjects = {x.name};
clear x

for subj = 4:14%:length(subjects) 
    
    
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
    for iii=1:length(tmperrcue10)
        pos = tmperrcue10(iii);
        if ~ (strcmp(EEG.event(pos+1).type , 'saccade_pro_left'))
            
            EEG.event(pos).type='missingsacc'; %cue
        end
    end
    
    %%11
    tmperrcue11 =   find(strcmp({EEG.event.type}, 'cue_pro_right'))    ;
    for iii=1:length(tmperrcue11)
        pos = tmperrcue11(iii);
        if ~ (strcmp(EEG.event(pos+1).type , 'saccade_pro_right'))
            
            EEG.event(pos).type='missingsacc'; %cue
        end
    end
    
    
    tmperrcue12=  find(strcmp({EEG.event.type}, 'cue_anti_left')) ;
    for iii=1:length(tmperrcue12)
        pos = tmperrcue12(iii);
        if ~ (strcmp(EEG.event(pos+1).type , 'saccade_anti_left'))
            
            EEG.event(pos).type='missingsacc'; %cue
        end
    end
    
    %%11
    tmperrcue13 =   find(strcmp({EEG.event.type}, 'cue_anti_right'))    ;
    for iii=1:length(tmperrcue13)
        pos = tmperrcue13(iii);
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
    
    
    
    
    
    %%     epoching
    EEGprocue= pop_epoch(EEG, {'cue_pro_right','cue_pro_left'}, [-1.5, 1.5]);
    EEGanticue= pop_epoch(EEG, {'cue_anti_right','cue_anti_left'}, [-1.5, 1.5]);
    EEGprosacc= pop_epoch(EEG, {'saccade_pro_right','saccade_pro_left'}, [-1.5, 1.5]);
    EEGantisacc= pop_epoch(EEG, {'saccade_anti_right','saccade_anti_left'}, [-1.5, 1.5]);
    
    % sanity check -> how many epochs
    % trialinfopro.epochs=size(EEGprocue.data, 3);
    % trialinfoanti.epochs=size(EEGanticue.data, 3);
    
    %% important; direction cue
    
    tmppro=find(strcmp({EEGprocue.event.type}, 'cue_pro_right') | strcmp({EEGprocue.event.type}, 'cue_pro_left') );
    tmpanti=find(strcmp({EEGanticue.event.type},'cue_anti_right') | strcmp({EEGanticue.event.type}, 'cue_anti_left') );
    
    rightpro= find(strcmp({EEGprocue.event(tmppro).type},'cue_pro_right')==1);
    leftpro= find(strcmp({EEGprocue.event(tmppro).type},'cue_pro_left')==1);
    rightanti= find(strcmp({EEGanticue.event(tmpanti).type},'cue_anti_right')==1);
    leftanti= find(strcmp({EEGanticue.event(tmpanti).type}, 'cue_anti_left')==1);
    
    EEGprocue.direction  = nan(length(tmppro),1);
    EEGprocue.direction(leftpro)= 0;
    EEGprocue.direction(rightpro)= 1;
    
    EEGanticue.direction  = nan(length(tmpanti),1);
    EEGanticue.direction(leftanti)= 0;
    EEGanticue.direction(rightanti)= 1;
    
    
    
    %% add new substructure -> info about the direction
    
    %sacc locked

    tmpprosacc=find(strcmp({EEGprosacc.event.type}, 'saccade_pro_right') | strcmp({EEGprosacc.event.type}, 'saccade_pro_left') );
    tmpantisacc=find(strcmp({EEGantisacc.event.type}, 'saccade_anti_right') | strcmp({EEGantisacc.event.type}, 'saccade_anti_left') );
    
    rightprosacc= find(strcmp({EEGprosacc.event(tmpprosacc).type},'saccade_pro_right')==1);
    leftprosacc= find(strcmp({EEGprosacc.event(tmpprosacc).type},'saccade_pro_left')==1);
    rightantisacc= find(strcmp({EEGantisacc.event(tmpantisacc).type},'saccade_anti_right')==1);
    leftantisacc= find(strcmp({EEGantisacc.event(tmpantisacc).type},'saccade_anti_left')==1);
    
    EEGprosacc.direction  = nan(length(tmpprosacc),1);
    EEGprosacc.direction(leftprosacc)= 0;
    EEGprosacc.direction(rightprosacc)= 1;
    
    EEGantisacc.direction  = nan(length(tmpantisacc),1);
    EEGantisacc.direction(leftantisacc)= 0;
    EEGantisacc.direction(rightantisacc)= 1;
    
    %cue locked
    
    
    tmpprocue=find(strcmp({EEGprocue.event.type}, 'cue_pro_right') | strcmp({EEGprocue.event.type}, 'cue_pro_left') );
    tmpanticue=find(strcmp({EEGanticue.event.type}, 'cue_anti_right') | strcmp({EEGanticue.event.type}, 'cue_anti_left') );
    
    rightprocue= find(strcmp({EEGprocue.event(tmpprocue).type},'cue_pro_right')==1);
    leftprocue= find(strcmp({EEGprocue.event(tmpprocue).type},'cue_pro_left')==1);
    rightanticue= find(strcmp({EEGanticue.event(tmpanticue).type},'cue_anti_right')==1);
    leftanticue= find(strcmp({EEGanticue.event(tmpanticue).type},'cue_anti_left')==1);
    
    EEGprocue.direction  = nan(length(tmpprocue),1);
    EEGprocue.direction(leftprocue)= 0;
    EEGprocue.direction(rightprocue)= 1;
    
    EEGanticue.direction  = nan(length(tmpanticue),1);
    EEGanticue.direction(leftanticue)= 0;
    EEGanticue.direction(rightanticue)= 1;
    
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
    
    save EEGprocue EEGprocue
    save EEGprosacc EEGprosacc
    
    
    %% save epoched anti, sacc locked and cue locked
    
    save EEGanticue EEGanticue
    save EEGantisacc EEGantisacc
    
    
end
