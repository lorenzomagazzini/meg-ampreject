
clear

%path to collab
base_path = '/cubric/collab/meg-cleaning/';
cd(base_path)

%task
task_label = 'restopen';

%path to data (.mat files)
data_path = fullfile(base_path, 'megpartnership', task_label, 'traindata');

%save paths
data_savepath = data_path;
fig_savepath = fullfile(base_path, 'megpartnership', task_label, 'trainfigures');

%list of files
dir_struct = dir(fullfile(data_path, 'sub-*_data.mat'));
file_list = {dir_struct(:).name}';
nsubj = length(file_list);

%%

%define subj from list
s = 5
subj_label = strrep(file_list{s}, '_data.mat', '');

%load data
cd(data_path)
data = load(file_list{s});

%%

clear badtrialsindex
badtrialsindex_file = fullfile(data_path, [subj_label '_cls-multitrial.mat']);
if exist(badtrialsindex_file,'file')
    load(badtrialsindex_file)
end

%%

% %low-level padding
% paddata = data;
% padlength       = 2* ceil( abs(data.time{1}(end)-data.time{1}(1)) ) * data.fsample;
% prepadlength    = padlength/2;
% postpadlength   = padlength/2;
% padtype         = 'mirror';
% for i = 1:length(data.trial)
%     dat = ft_preproc_padding(data.trial{i}, padtype, prepadlength, postpadlength);
%     tim = linspace(data.time{i}(1)-(padlength/data.fsample)/2, data.time{i}(end)+(padlength/data.fsample)/2, size(dat,2));
%     paddata.trial{i} = dat;
%     paddata.time{i} = tim;
% end
% paddata = rmfield(paddata,'sampleinfo')

%low-pass filtering
cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 4;
cfg.padding = 0.5*(abs(data.time{1}(end)-data.time{1}(1)))+abs(data.time{1}(end)-data.time{1}(1));
data_lp = ft_preprocessing(cfg,data);
% data_lp = ft_preprocessing(cfg,paddata);

% %trim down
% cfg = [];
% cfg.latency = [data.time{1}(1) data.time{1}(end)];
% data_lp = ft_selectdata(cfg, data_lp)

%interactive multitrial plot
cfgplot = [];
cfgplot.title = 'bad trials marked in red';
cfgplot.drawnow = 'yes';
cfgplot.ylim = [];
cfgplot.chandownsamp = 4;
cfgplot.timedownsamp = 20;
cfgplot.badtrialscolor = [];
cfgplot.numrows = [];
cfgplot.numcolumns = [];

cfgplot.ylim = [-1 1]*5e-12;
cfgplot.interactive = 'yes';

%use bad trials index if exists
if exist('badtrialsindex','var')
    cfgplot.badtrialsindex = badtrialsindex;
else
    cfgplot.badtrialsindex = [];
end

%plot highpass trials
[badtrialsindex, h] = amprej_multitrialplot(cfgplot, data_lp);

%%

%high-pass filtering
cfg = [];
cfg.hpfilter = 'yes';
cfg.hpfreq = 60;
cfg.padding = 0.5*(abs(data.time{1}(end)-data.time{1}(1)))+abs(data.time{1}(end)-data.time{1}(1));
data_hp = ft_preprocessing(cfg,data);

%visualise previously marked bad trials
cfgplot.ylim = [-1 1]*2e-12;
cfgplot.badtrialsindex = badtrialsindex;
cfgplot.interactive = 'no';

%plot highpass trials
[badtrialsindex, h] = amprej_multitrialplot(cfgplot, data_hp);

%initialise interactive mode, if necessary
badtrialsindex = init_multitrialplot_interactive(cfgplot);

%%

%visualise previously marked bad trials
cfgplot.ylim = [-1 1]*5e-12;
cfgplot.badtrialsindex = badtrialsindex;
cfgplot.interactive = 'no';

%plot broadband trials
[badtrialsindex, h] = amprej_multitrialplot(cfgplot, data);

%initialise interactive mode, if necessary
badtrialsindex = init_multitrialplot_interactive(cfgplot);

%%

%save figure
saveas(gcf, fullfile(fig_savepath, [subj_label '_cls-multitrial.png']))

%save bad trials index
save(fullfile(data_savepath, [subj_label '_cls-multitrial.mat']), 'badtrialsindex')

