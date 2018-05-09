
%% filter the data

%filter the data, z-transform the data and calculate within-channel metrics (over the concatenated trials)
cfg = [];
cfg.([filtertype 'filter']) = 'yes';
cfg.([filtertype 'freq']) = filterfreq;
cfg.padding = filterpadding;
[datafilt, chanMetrics, zMatrix] = amprej_getchanmetrics(cfg, data);


%% topoplot metrics

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%draw figure
close all
hFigure = [];
cfg = [];
[hFigure, cfg] = amprej_preparetopofigure(cfg, hFigure);

%plot topography of max amplitude (within channels, across concatenated trials)
cfg.parameter = 'max';
% cfg.zlim = [0 1]*5e-12;
hTopo = amprej_topoplot(cfg, datafilt, chanMetrics, hFigure);
hFigure.Position = [15 15 5 5];

cfg.title = {'Max amp' ['(' num2str(filterfreqstr) 'Hz ' filtertype '-filt)']};
[hTopo, hColbar, hTitle] = amprej_refinetopofigure(cfg, hTopo);

%save color scale for clean topoplot
zLim_topoMax = get(hColbar,'Limits');


%save figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause(1);
% print(hFigure, '-dpdf', fullfile(savepath, savename))
saveas(hFigure, fullfile(fig_savepath, [topo1_savename '.png']))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot topography of max amplitude (within channels, across concatenated trials)
% close all
hFigure = [];
cfg = [];
[hFigure, cfg] = amprej_preparetopofigure(cfg, hFigure);
hFigure.Position = [20 15 5 5];

cfg.parameter = 'sd';
% cfg.zlim = [0 1]*5e-13;
hTopo = amprej_topoplot(cfg, datafilt, chanMetrics, hFigure);

cfg.title = {'SD of amp' ['(' num2str(filterfreqstr) 'Hz ' filtertype '-filt)']};
[hTopo, hColbar, hTitle] = amprej_refinetopofigure(cfg, hTopo);

%save color scale for clean topoplot
zLim_topoSD = get(hColbar,'Limits');


%save figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause(1);
% print(hFigure, '-dpdf', fullfile(savepath, savename))
saveas(hFigure, fullfile(fig_savepath, [topo2_savename '.png']))

clear hTopo
clear hColbar
clear topo1_savename
clear topo2_savename
clear zLim_topoMax
clear zLim_topoSD

