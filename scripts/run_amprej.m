
clear
iSubj = 1;

loadpath = '/cubric/collab/meg-cleaning/rawdata';
loadname = ['s' num2str(iSubj,'%03d')];
data = load(fullfile(loadpath, loadname));


%% filter data and plot topo metrics (LOW-PASS)

lpfreq = 4; %filter definitions
filtertype = 'lp'; %filter definitions
filterfreq = lpfreq; %filter definitions
filterpadding = 8; %filter definitions
threshSD = 3; %threshold definition
percentChannels = 20; %threshold definition

%define string for saving filterfreq info
filterfreqstr = []; for f=1:length(filterfreq), filterfreqstr = [filterfreqstr num2str(filterfreq(f)) '-']; end, filterfreqstr(end) = [];

fig_savepath = '/cubric/collab/meg-cleaning/trialrej_fig';
topo1_savename = ['s' num2str(iSubj,'%03d') '_topo_' filtertype num2str(filterfreqstr) 'Hz_ampMax_uncleaned'];
topo2_savename = ['s' num2str(iSubj,'%03d') '_topo_' filtertype num2str(filterfreqstr) 'Hz_ampSD_uncleaned'];

preproc_data_and_topoplot_metrics


%% reject trials and plot multi trials (LOW-PASS)

yLim = [-1 1]*5e-12;

savepath = '/cubric/collab/meg-cleaning/trialrej';
savename = ['s' num2str(iSubj,'%03d') '_rejTrials_' filtertype num2str(filterfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD'];
fig_savepath = '/cubric/collab/meg-cleaning/trialrej_fig';
fig_savename = ['s' num2str(iSubj,'%03d') '_multitrial_' filtertype num2str(filterfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD'];

mark_badtrials_and_multiplot_trials


%define trials to reject based on visual inspection (LOW-PASS)
rejTrialsIndex_visual = [14,15,21,44,60,63,64,74,79,81,84,86,90,93]; %20p, 3SD

rejTrials_visual = false(length(rejTrials),1);
rejTrials_visual(rejTrialsIndex_visual) = true;

%save index to visually rejected trials
savepath = '/cubric/collab/meg-cleaning/trialrej';
savename = ['s' num2str(iSubj,'%03d') '_rejTrials_' filtertype num2str(filterfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD_visual'];
save(fullfile(savepath, [savename '.mat']), '-v7.3', 'rejTrials_visual', 'rejTrialsIndex_visual')

clear savepath
clear savename

clear rejTrials
clear rejTrials_visual
clear rejTrialsIndex_visual
clear filterfreqstr
clear filtertype
clear filterfreq
clear filterpadding
clear percentChannels
clear threshSD
clear datafilt
clear chanMetrics
clear zMatrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% filter data and plot topo metrics (BAND-PASS)

bpfreq = [110 140]; %filter definitions
filtertype = 'bp'; %filter definitions
filterfreq = bpfreq; %filter definitions
filterpadding = 6; %filter definitions
threshSD = 3; %threshold definition
percentChannels = 20; %threshold definition

%define string for saving filterfreq info
filterfreqstr = []; for f=1:length(filterfreq), filterfreqstr = [filterfreqstr num2str(filterfreq(f)) '-']; end, filterfreqstr(end) = [];

fig_savepath = '/cubric/collab/meg-cleaning/trialrej_fig';
topo1_savename = ['s' num2str(iSubj,'%03d') '_topo_' filtertype num2str(filterfreqstr) 'Hz_ampMax_uncleaned'];
topo2_savename = ['s' num2str(iSubj,'%03d') '_topo_' filtertype num2str(filterfreqstr) 'Hz_ampSD_uncleaned'];

preproc_data_and_topoplot_metrics


%% reject trials and plot multi trials (BAND-PASS)

yLim = [-1 1]*2e-12;

savepath = '/cubric/collab/meg-cleaning/trialrej';
savename = ['s' num2str(iSubj,'%03d') '_rejTrials_' filtertype num2str(filterfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD'];
fig_savepath = '/cubric/collab/meg-cleaning/trialrej_fig';
fig_savename = ['s' num2str(iSubj,'%03d') '_multitrial_' filtertype num2str(filterfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD'];

mark_badtrials_and_multiplot_trials


%define trials to reject based on visual inspection (LOW-PASS)
rejTrialsIndex_visual = [14,92,99]; %20p, 3SD

rejTrials_visual = false(length(rejTrials),1);
rejTrials_visual(rejTrialsIndex_visual) = true;

%save index to visually rejected trials
savepath = '/cubric/collab/meg-cleaning/trialrej';
savename = ['s' num2str(iSubj,'%03d') '_rejTrials_' filtertype num2str(filterfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD_visual'];
save(fullfile(savepath, [savename '.mat']), '-v7.3', 'rejTrials_visual', 'rejTrialsIndex_visual')

clear savepath
clear savename

clear rejTrials
clear rejTrials_visual
clear rejTrialsIndex_visual
clear filterfreqstr
clear filtertype
clear filterfreq
clear filterpadding
clear percentChannels
clear threshSD
clear datafilt
clear chanMetrics
clear zMatrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% do something with kurtosis! (?)

%the following parts need to be updated...


