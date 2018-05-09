function [ rejTrials_visual, rejTrialsIndex_visual ] = amprej_get_visually_marked_badtrials( dataset_epoched, savepath, savename )

%% read visually marked bad trials and save as .mat file

%read bad trials after visual rejection
cls = read_ctf_cls(fullfile(dataset_epoched, 'ClassFile.cls'));

%read total number of trials (depends on trigger of interest)
mrk = readmarkerfile(dataset_epoched);
nTrials = mrk.number_samples(find(ismember(mrk.marker_names,'Grating')));

%define trials to reject based on visual inspection
rejTrialsIndex_visual = [cls{:}]; %20p, 3SD
rejTrials_visual = false(nTrials,1);
rejTrials_visual(rejTrialsIndex_visual) = true;


%save index to visually rejected trials
% cd(savepath)
save(fullfile(savepath, [savename '.mat']), '-v7.3', 'rejTrials_visual', 'rejTrialsIndex_visual')

% clear savepath
% clear savename
% % clear rejTrials_visual
% % clear rejTrialsIndex_visual
% clear nTrials
% clear cls
% clear mrk

end