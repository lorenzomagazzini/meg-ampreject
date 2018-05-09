function [ hTopo ] = amprej_topoplot( cfg, data, chanMetrics, hFigure )
%[ hTopo ] = amprej_topoplot( cfg, data, chanMetrics, hFigure )
%   The input 'cfg' should be defined using amprej_preparetopofigure
%   The input 'data' is used simply to simulate a data structure for the call to ft_topoplot
%   The input 'chanMetrics' is a structure with Nchannels x 1 vectors as fields
%   The input 'hFigure' should be a figure handle created using amprej_preparetopofigure
%   The plotted data is the field of 'chanMetrics' specified by cfg.parameter

%default cfg
if isempty(cfg)
    error('please define a cfg structure using the function amprej_preparetopofigure and specifying a cfg.parameter field');
end

%default hFigure
if nargin<4 || isempty(hFigure)
    [hFigure] = amprej_preparetopofigure;
end

%define plotting parameter
if isfield(cfg,'parameter') && ~isempty(cfg.parameter);
    parameter = cfg.parameter;
else
    error('please specify cfg.parameter')
end

%simulate ft struct
ft_topo = struct;
ft_topo.(parameter) = chanMetrics.(parameter);
ft_topo.time = 0;
ft_topo.label = data.label;
ft_topo.dimord = 'chan_time';
% ft_topo.elec = data.elec;
ft_topo.grad = data.grad;

%plot
figure(hFigure)
ft_topoplotER(cfg, ft_topo)
drawnow

%return handle to topoplot
hTopo = gca;


end