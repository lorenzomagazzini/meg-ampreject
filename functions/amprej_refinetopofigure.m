function [ hTopo, hColbar, hTitle ] = amprej_refinetopofigure( cfg, hTopo )
%[ hTopo, hColbar, hTitle ] = amprej_refinetopofigure( cfg, hTopo )
%   This function refines a figure containing a topoplot (with axis handle hTopo)
%   according to default parameters (and a title which can be specified as cfg.title)

if isempty(cfg) || ~isfield(cfg,'title')
    titletext = '';
else
    titletext = cfg.title;
end

hTopo.Units = 'centimeters';
hColbar = colorbar(hTopo,'Location','EastOutside');
hTopo.Position = [0.5 0.5 3 3];
hT_Pos = hTopo.Position;

hColbar.Units = 'centimeters';
hColbar.Position = [hT_Pos(1)+hT_Pos(3)+0.25 hT_Pos(2)+0.5 0.15 hT_Pos(4)-1];
% hColbar.TickLabels = {};
% hColbar.Color = 'none';
hColbar.FontSize = 8;

hTopo.ActivePositionProperty = 'outerposition';

hTitle = title(titletext);
hTitle.FontSize = 10;
hTitle.FontWeight = 'normal';
hTitle.Units = 'centimeters';
hTitle.Position(1) = 2;
hTitle.Position(2) = 3.3;


end