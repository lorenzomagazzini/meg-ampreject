function [ rejTrials, rejSamples, outlierMatrix ] = amprej_z2reject( cfg, zMatrix )
%[ rejTrials, rejSamples, outlierMatrix ] = amprej_z2reject( cfg, zMatrix )
%   
%   This function takes the input matrix (zMatrix), which is one of the outputs of
%   the function amprej_getchanmetrics, and uses it to identify trials to reject.
%   First, the function calculates within-channel outliers, i.e. z-scores 
%   more extreme than the specified threshold in standard deviations (cfg.threshSD).
%   Second, within each trial, the function identifies data samples in which 
%   the number of outliers is equal or greater than in the specified percentage of 
%   channels (cfg.percentChannels).
%   The function returns:
%   1) a logical array indicating the trials to reject (rejTrials)
%   2) the samples, within each trial, to reject (rejSamples)
%   3) an nChannels x nSamples x nTrials matrix (outlierMatrix), containing
%      the within-channel outliers.

threshSD = cfg.threshSD;
percentChannels = cfg.percentChannels;

%assume same number of channels and samples across trials ...
nChans = size(zMatrix,1);
nSamples = size(zMatrix,2);
nTrials = size(zMatrix,3);

%define threshold number of channels
threshChans = ceil(nChans/100*percentChannels);

%re-concatenate trials from z-score matrix
chanZscores = nan(nChans, nSamples*nTrials);
for iChan = 1:nChans
    chanZscores(iChan,:) = reshape(squeeze(zMatrix(iChan,:,:)), 1, nSamples*nTrials);
end


%find within-channel outliers
chanOutliers = abs(chanZscores) > threshSD;
clear chanZscores

%de-concatenate trials (re-arrange into a 3-D matrix)
outlierMatrix = nan(nChans, nSamples, nTrials);
for iChan = 1:nChans
    outlierMatrix(iChan,:,:) = reshape(chanOutliers(iChan,:), nSamples, nTrials);
end
clear chanOutliers


%for each sample, within each trial, find number of across-channel outliers
rejSamples = nan(nTrials, nSamples);
for iTrial = 1:nTrials
    trialOutliers = squeeze(outlierMatrix(:,:,iTrial));
    rejSamples(iTrial,:) = sum(trialOutliers) >= threshChans;
    clear trialOutliers
end

%find trials to reject
rejTrials = any(rejSamples,2);

clear cfg
clear threshSD
clear percentChannels
clear threshChans
clear nChans
clear nSamples
clear nTrials


end