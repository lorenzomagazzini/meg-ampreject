
%% compare visual-only artifact rejection with amprej

loadpath = '/home/c1356674/data/ampreject/results';



%take visual-only as ground truth, and test performance of auto-only amprej (LP+BP)

%load visual-only
loadname = ['rejTrials_visual' '.mat'];
load(fullfile(loadpath, loadname), 'rejTrials_visual') %load the logical array
rejTrials_visualOnly = rejTrials_visual;
clear rejTrials_visual

%load auto-only amprej (LP)
loadname = ['rejTrials_lp' num2str(lpfreq) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD' '.mat'];
load(fullfile(loadpath, loadname), 'rejTrials') %load the logical array
rejTrials_autoOnlyLP = rejTrials;
clear rejTrials

%load auto-only amprej (BP)
bpfreqstr = []; for f=1:length(bpfreq), bpfreqstr = [bpfreqstr num2str(bpfreq(f)) '-']; end, bpfreqstr(end) = [];
loadname = ['rejTrials_bp' num2str(bpfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD' '.mat'];
load(fullfile(loadpath, loadname), 'rejTrials') %load the logical array
rejTrials_autoOnlyBP = rejTrials;
clear rejTrials

%combine LP and BP for auto-only amprej
rejTrials_autoOnly = logical(rejTrials_autoOnlyLP + rejTrials_autoOnlyBP)';


CP = classperf(rejTrials_visualOnly, rejTrials_autoOnly, 'Positive', 1, 'Negative', 0)


%%%   get summary measures of interest here   %%%




%take auto+visual amprej as ground truth, and test performance of visual-only

%load auto+visual amprej (LP)
loadname = ['rejTrials_lp' num2str(lpfreq) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD' '.mat'];
load(fullfile(loadpath, loadname), 'rejTrials') %load the logical array
loadname = ['rejTrials_lp' num2str(lpfreq) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD_visual' '.mat'];
load(fullfile(loadpath, loadname), 'rejTrials_visual') %load the logical array
rejTrials_autoVisualLP = logical(rejTrials + rejTrials_visual);
clear rejTrials
clear rejTrials_visual

%load auto+visual amprej (BP)
bpfreqstr = []; for f=1:length(bpfreq), bpfreqstr = [bpfreqstr num2str(bpfreq(f)) '-']; end, bpfreqstr(end) = [];
loadname = ['rejTrials_bp' num2str(bpfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD' '.mat'];
load(fullfile(loadpath, loadname), 'rejTrials') %load the logical array
loadname = ['rejTrials_bp' num2str(bpfreqstr) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD_visual' '.mat'];
load(fullfile(loadpath, loadname), 'rejTrials_visual') %load the logical array
rejTrials_autoVisualBP = logical(rejTrials + rejTrials_visual);
clear rejTrials
clear rejTrials_visual

%combine LP and BP for auto+visual amprej
rejTrials_autoVisual = logical(rejTrials_autoVisualLP + rejTrials_autoVisualBP)';


CP = classperf(rejTrials_autoVisual, rejTrials_visualOnly, 'Positive', 1, 'Negative', 0)














%%

trialsReject = sort(unique([find(rejTrials); find(rejTrials_visual)]))';
trialsKeep = sort(intersect(find(~rejTrials), find(~rejTrials_visual)))';

cfg = [];
cfg.trials = trialsKeep;
datafilt_clean = ft_preprocessing(cfg, datafilt);

cfg = [];
[~, chanMetrics_clean, zMatrix_clean] = amprej_getchanmetrics(cfg, datafilt_clean);


%plot topography of max amplitude (within channels, across concatenated trials)
% close all
hFigure = [];
cfg = [];
[hFigure, cfg] = amprej_preparetopofigure(cfg, hFigure);
hFigure.Position = [15 10 5 5];

cfg.parameter = 'max';
cfg.zlim = zLim_topoMax;
hTopo = amprej_topoplot(cfg, data, chanMetrics_clean, hFigure);

cfg.title = {'Max amp (clean)' ['(' num2str(filterfreq) 'Hz ' filtertype '-filt)']};
[hTopo, hColbar, hTitle] = amprej_refinetopofigure(cfg, hTopo);

%save figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
savepath = '/home/c1356674/data/ampreject/figures';
savename = ['ampreject_topo_' filtertype num2str(filterfreq) 'Hz_maxamp_cleaned'];
pause(1);
% print(hFigure, '-dpdf', fullfile(savepath, savename))
saveas(hFigure, fullfile(savepath, [savename '.png']))
clear savepath
clear savename


%plot topography of max amplitude (within channels, across concatenated trials)
% close all
hFigure = [];
cfg = [];
[hFigure, cfg] = amprej_preparetopofigure(cfg, hFigure);
hFigure.Position = [20 10 5 5];

cfg.parameter = 'sd';
cfg.zlim = zLim_topoSD;
hTopo = amprej_topoplot(cfg, data, chanMetrics_clean, hFigure);

cfg.title = {'SD of amp (clean)' ['(' num2str(filterfreq) 'Hz ' filtertype '-filt)']};
[hTopo, hColbar, hTitle] = amprej_refinetopofigure(cfg, hTopo);

%save figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
savepath = '/home/c1356674/data/ampreject/figures';
savename = ['ampreject_topo_' filtertype num2str(filterfreq) 'Hz_ampSD_cleaned'];
pause(1);
% print(hFigure, '-dpdf', fullfile(savepath, savename))
saveas(hFigure, fullfile(savepath, [savename '.png']))
clear savepath
clear savename


%%

rejTrialsFinal = zeros(length(rejTrials),1);
rejTrialsFinal(trialsReject) = 1;

%plot all trials marking those to be rejected in red (automatic+visual)
cfg = [];
cfg.title = sprintf('Automatic+Visual trial rejection (%dHz %s-filt)', filterfreq, filtertype);
[hSubplots, hFigure, hTitle] = amprej_multitrialplot(cfg, datafilt, rejTrialsFinal);

%save figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
savepath = '/home/c1356674/data/ampreject/figures';
savename = ['ampreject_multitrial_' filtertype num2str(filterfreq) 'Hz_' num2str(percentChannels) 'p_' num2str(threshSD) 'SD_visual'];
pause(1);
% print(hFigure, '-dpdf', fullfile(savepath, savename))
saveas(hFigure, fullfile(savepath, [savename '.png']))
clear savepath
clear savename





