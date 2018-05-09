function [ data ] = amprej_get_rawdata( dataset_epoched, hpfreq, resamplefs, savepath, savename )

%% read epoched dataset and preprocess (hp-filt, downsample)


%define dataset
cfg = [];
cfg.dataset = dataset_epoched;
cfg.channel = {'MEG'};
cfg.demean = 'yes';
[data] = ft_preprocessing(cfg)

%preprocess epoched dataset
cfg = [];
cfg.hpfilter = 'yes';
cfg.hpfreq = hpfreq;
cfg.padding = 8;
% cfg.demean = 'yes';
% cfg.channel = {'MEG'};
[data] = ft_preprocessing(cfg, data)

%downsample to 300 Hz
cfg = [];
cfg.resamplefs = resamplefs;
cfg.detrend = 'no';
[data] = ft_resampledata(cfg, data)

%quick and dirty anonymisation
data.cfg.previous.previous = [];

%save index to visually rejected trials
% cd(savepath)
save(fullfile(savepath, [savename '.mat']), '-v7.3', '-struct', 'data')

% clear savepath
% clear savename
% clear dataset
% clear dataset_epoched

end