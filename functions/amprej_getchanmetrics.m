function [ datafilt, chanMetrics, zMatrix ] = amprej_getchanmetrics( cfg, data )
%[ datafilt, chanMetrics, zMatrix ] = amprej_getchanmetrics( cfg, data )
%   
%   This function pre-processes the input structure (data) according to the 
%   specified cfg parameters (see help ft_preprocessing) and it returns
%   the filtered data in the output data structure (datafilt).
%   Additional outputs are a structure (chanMetrics) containing a number of 
%   across-channel metrics and an nChannels x nSamples x nTrials matrix 
%   (zMatrix), which contains the z-transformed data, where the z-scores 
%   are calculated within channels, over the concatenated data.


%do pre-processing if cfg options are specified
if ~isempty(cfg)
    datafilt = ft_preprocessing(cfg, data);
else
    datafilt = data;
    warning('the input data will not be pre-processed')
end

%assume same number of channels and samples across trials ...
nChans = size(data.trial{1},1);
nSamples = size(data.trial{1},2);
nTrials = length(data.trial);

%store trials into 3-D matrix
trialMatrix = nan(nChans, nSamples, nTrials);
for iTrial = 1:nTrials
    trialMatrix(:,:,iTrial) = datafilt.trial{iTrial}(:,:);
end

%concatenate trials and calculate within-channel max, mean and SD (mean should be zero)
chanData = nan(nChans, nSamples*nTrials);
chanData_max = nan(nChans, 1);
chanData_avg = nan(nChans, 1);
chanData_sd = nan(nChans, 1);
for iChan = 1:nChans
    chanData(iChan,:) = reshape(squeeze(trialMatrix(iChan,:,:)), 1, nSamples*nTrials);
    chanData_max(iChan) = max(chanData(iChan,:));
    chanData_avg(iChan) = mean(chanData(iChan,:));
    chanData_sd(iChan) = std(chanData(iChan,:));
end
clear trialMatrix

%z-transform the concatenated trials (z scores calculated within channels)
chanZscores = nan(nChans, nSamples*nTrials);
for iChan = 1:nChans
    chanZscores(iChan,:) = (chanData(iChan,:)-chanData_avg(iChan)) / chanData_sd(iChan);
end
clear chanData

%store into chanMetrics structure
chanMetrics = struct;
chanMetrics.max = chanData_max;
chanMetrics.avg = chanData_avg;
chanMetrics.sd = chanData_sd;

%de-concatenate trials (re-arrange into a 3-D matrix)
zMatrix = nan(nChans, nSamples, nTrials);
for iChan = 1:nChans
    zMatrix(iChan,:,:) = reshape(chanZscores(iChan,:), nSamples, nTrials);
end

clear cfg
clear lpfreq
clear chanData*
clear nChans
clear nSamples
clear nTrials


end