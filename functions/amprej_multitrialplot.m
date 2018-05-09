function [ hSubplots, hFigure, hTitle ] = amprej_multitrialplot( cfg, data, rejTrials )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here


%default figure title
if isempty(cfg) || ~isfield(cfg,'title')
    titletext = '';
else
    titletext = cfg.title;
end

%default drawnow option
if isempty(cfg) || ~isfield(cfg,'drawnow')
    dodrawnow = true;
else
    dodrawnow = istrue(cfg.drawnow);
end


%assume same number of channels and samples across trials ...
nChans = size(data.trial{1},1);
nSamples = size(data.trial{1},2);
nTrials = length(data.trial);

%store trials into 3-D matrix
trialMatrix = nan(nChans, nSamples, nTrials);
for iTrial = 1:nTrials
    trialMatrix(:,:,iTrial) = data.trial{iTrial}(:,:);
end

%store time array (again, assume same number of samples across trials)
timeVector = data.time{1};

%free up space?
clear data


%define plot limits
yLim = cfg.yLim;

%define subplot columns and rows
% nRows = cfg.nRows;
nRows = 10;% ceil(nTrials/10);
% nCols = cfg.nCols;
nCols = ceil(nTrials/10);

%define color for rejected trials
% rejColor = cfg.rejColor;
rejColor = [215 48 31]./255;




% close all
figure
hFigure = gcf;
hFigure.Units = 'centimeters';
hFigure.Position = [1 1 2*nCols+1 2*nRows+1];
hFigure.Color = [1 1 1];

if ~dodrawnow
    fprintf('plotting trials, please wait...\n')
end

hSubplots = nan(nTrials,1);
for iTrial = 1:nTrials
    
    %draw sublot
    subplot(nRows, nCols, iTrial)
    
    %define axis properties
    hS = gca;
    hS.YLim = yLim;
    hS.XLim = [timeVector(1) timeVector(end)];% [1 nSamples];
    % hS.YTick = yLim;
    hS.XTick = [];
    if iTrial ~=1, hS.YTickLabel = {''}; end
    hS.XTickLabel = {''};
    hS.Box = 'on';
    hS.Layer = 'bottom';
    pbaspect([1 1 1])
    hS.Units = 'normalized';
    
    %differentiate trials to reject from trials to keep
    if rejTrials(iTrial) == true
        hS.LineWidth = 2;
        hS.XColor = rejColor;
        hS.YColor = rejColor;
    else
        hS.LineWidth = 0.5;
        hS.XColor = [.25 .25 .25];
        hS.YColor = [.25 .25 .25];
    end
    
    %plot overlaid channels for given trial
    for iChan = 1:nChans
        
        trialData = squeeze(trialMatrix(iChan,:,iTrial));
        
        hold on
        plot(timeVector, trialData, 'Color',[0 0 0], 'LineWidth',0.5)
        
    end
    clear trialData
    
    %add trial numbers
    hText = text(0.05, 0.85, num2str(iTrial), 'Parent',hS, 'Units','normalized');
    hText.FontSize = 8;
    
    if dodrawnow
        drawnow
    end
    
    hSubplots(iTrial) = hS;
    
    
end

% hS = get(hSubplots(1));
% hS.YTick = yLim;
% hS.YTickLabel = {num2str(yLim(1)) num2str(yLim(2))};

%draw title
hTitle = suptitle(titletext);
hTitle.FontSize = 12;


end