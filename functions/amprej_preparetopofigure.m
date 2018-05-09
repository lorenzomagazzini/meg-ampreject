function [ hFigure, cfg ] = amprej_preparetopofigure( cfg, hFigure )
%[ hFigure, cfg ] = amprej_preparetopofigure( cfg, hFigure )
%   To set default topoplot options, use cfg=[]
%   To open a default figure, use hFigure=[]

%define cfg, unless cfg options are passed on as second input
if nargin<2 || isempty(cfg)
    cfg = [];
end

%set default zlim
if ~isfield(cfg,'zlim')
    cfg.zlim = [];
end

%set default colormap
if ~isfield(cfg,'colormap')
    cfg.colormap = cmocean('amp');
end

%set default comment
if ~isfield(cfg,'comment')
    cfg.comment = 'no';
end


%open figure, unless a handle is passed on as second input
if nargin<1 || isempty(hFigure)
    hFigure = figure;% gcf;
    hFigure.Units = 'centimeters';
    hFigure.Position = [15 15 5 5];
    hFigure.Color = [1 1 1];
    hFigure.PaperUnits = 'centimeters';
    hFigure.PaperPosition = [0 0 5 5];
end

drawnow


end