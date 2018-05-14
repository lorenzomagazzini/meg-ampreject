function [ badtrialsindex, h ] = amprej_multitrialplot( cfg, data, badtrials )
%[ badtrialsindex, h ] = amprej_multitrialplot( cfg, data, badtrials )
%   Detailed explanation goes here


%default figure title
if isempty(cfg) || ~isfield(cfg,'title') || isempty(cfg.title)
    titletext = '';
else
    titletext = cfg.title;
end

%default drawnow option
if isempty(cfg) || ~isfield(cfg,'drawnow') || isempty(cfg.drawnow)
    dodrawnow = true;
else
    dodrawnow = istrue(cfg.drawnow);
end

%retro-compatibility
if ~isempty(cfg) && isfield(cfg,'yLim')
    cfg.ylim = cfg.yLim;
end

%default y-axis limits
if isempty(cfg) || ~isfield(cfg,'ylim') || isempty(cfg.ylim)
    ylimits = [-1 1]*5e-12;
else
    ylimits = cfg.ylim;
end

%default channel downsampling
if isempty(cfg) || ~isfield(cfg,'chandownsamp') || isempty(cfg.chandownsamp)
    chandownsamp = 2; %1 = no downsampling
else
    chandownsamp = cfg.chandownsamp;
end

%default time downsampling
if isempty(cfg) || ~isfield(cfg,'timedownsamp') || isempty(cfg.timedownsamp)
    timedownsamp = 10; %1 = no downsampling
else
    timedownsamp = cfg.timedownsamp;
end

%define trials
numtrials = length(data.trial);

%retro-compatibility
if nargin > 2
    if islogical(badtrials)
        badtrialsindex = find(badtrials);
    else
        badtrialsindex = badtrials;
    end
else
    %default bad trials index
    if isempty(cfg) || ~isfield(cfg,'badtrialsindex') || isempty(cfg.badtrialsindex)
        badtrialsindex = [];
    else
        badtrialsindex = cfg.badtrialsindex;
    end
end

%default colour for bad trials
if isempty(cfg) || ~isfield(cfg,'badtrialscolor') || isempty(cfg.badtrialscolor)
    badtrialscolor = [215 48 31]./255;
else
    badtrialscolor = cfg.badtrialscolor;
end

%default number of subplot rows
if isempty(cfg) || ~isfield(cfg,'numrows') || isempty(cfg.numrows)
    numrows = 10;
else
    numrows = cfg.numrows;
end

%default number of subplot columns
if isempty(cfg) || ~isfield(cfg,'numcolumns') || isempty(cfg.numcolumns)
    numcolumns = ceil(numtrials/10);
else
    numcolumns = cfg.numcolumns;
end

%default interactive mode
if isempty(cfg) || ~isfield(cfg,'interactive') || isempty(cfg.interactive)
    interactive = cfg.interactive;
else
    interactive = istrue(cfg.interactive);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%store time array (assume same number of samples across trials)
samplesindex = 1:timedownsamp:size(data.time{1},2);
samplestimes = data.time{1}(1,samplesindex);
numsamples = length(samplestimes);

%store channel array (assume same number of samples across trials)
channelsindex = 1:chandownsamp:size(data.trial{1},1);
numchannels = length(channelsindex);

%store trials into 3-D matrix
trialmatrix = nan(numchannels, numsamples, numtrials);
for t = 1:numtrials
    trialmatrix(1:numchannels,1:numsamples,t) = data.trial{t}(channelsindex,samplesindex);
end
% clear data
clear t

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
h.figure = gcf;
h.figure.Units = 'centimeters';
h.figure.Position = [0 3 2*numcolumns+1 2*numrows+1];
h.figure.Color = [1 1 1];

if ~dodrawnow
    fprintf('plotting trials, please wait...\n')
end

h.subplots = nan(numtrials,1);
for t = 1:numtrials
    
    %draw sublot
    subplot(numrows, numcolumns, t)
    
    %define axis properties
    hS = gca;
    hS.YLim = ylimits;
    hS.XLim = [samplestimes(1) samplestimes(end)];
    % hS.YTick = ylimits;
    hS.XTick = [];
    if t~=1, hS.YTickLabel = {''}; end
    hS.XTickLabel = {''};
    hS.Box = 'on';
    hS.Layer = 'bottom';
    pbaspect([1 1 1])
    hS.Units = 'normalized';
    
    %differentiate trials to reject from trials to keep
    if ismember(t, badtrialsindex)
        hS.LineWidth = 2;
        hS.XColor = badtrialscolor;
        hS.YColor = badtrialscolor;
    else
        hS.LineWidth = 0.5;
        hS.XColor = [.25 .25 .25];
        hS.YColor = [.25 .25 .25];
    end
    
    %plot overlaid channels for given trial
    for c = 1:numchannels
        hold on
        plot(samplestimes, squeeze(trialmatrix(c,:,t)), 'Color',[0 0 0], 'LineWidth',0.5)
    end
    
    %add trial numbers
    hText = text(0.05, 0.85, num2str(t), 'Parent',hS, 'Units','normalized');
    hText.FontSize = 8;
    
    %draw or not
    if dodrawnow, drawnow; end
    
    %add tag
    hS.Tag = num2str(t);
    
    %subplot handle
    h.subplots(t) = hS;
    
end

%draw title
h.title = suptitle(titletext);
h.title.FontSize = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% interactive %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if interactive
    subplothandles = h.subplots;
    badtrialsindex = init_multitrialplot_interactive(cfg, subplothandles, badtrialsindex);
end

end%function