
%% trial rejection based on amplitude thresholds

%find trials to reject based on percentage of channels over specified SD
cfg = [];
cfg.threshSD = threshSD;
cfg.percentChannels = percentChannels;
[rejTrials, rejSamples, outlierMatrix] = amprej_z2reject(cfg, zMatrix);

%get index to bad trials (rejTrials is a logical array)
rejTrialsIndex = find(rejTrials);

%save index to automatically rejected trials
% cd(savepath)
save(fullfile(savepath, [savename '.mat']), '-v7.3', 'rejTrials', 'rejTrialsIndex', 'rejSamples', 'outlierMatrix', 'filtertype', 'filterfreq', 'threshSD', 'percentChannels')

clear savepath
clear savename


%% multitrial plot

%define savepath
fig_savepath = '/cubric/collab/meg-cleaning/trialrej_fig';

%plot all trials marking those to be rejected in red
cfg = [];
cfg.title = sprintf('Reject if %d%% channels over +/-%.1fSD (%sHz %s-filt)', percentChannels, threshSD, filterfreqstr, filtertype);
cfg.yLim = yLim;% [-1 1]*5e-12;
[hSubplots, hFigure, hTitle] = amprej_multitrialplot(cfg, datafilt, rejTrials);

%save figure
pause(1);
% print(hFigure, '-dpdf', fullfile(savepath, savename))
saveas(hFigure, fullfile(fig_savepath, [fig_savename '.png']))

clear rejTrialsIndex
clear rejSamples
clear outlierMatrix
clear yLim
clear hSubplots
clear hFigure
clear hTitle

