function [ badtrialsindex ] = init_multitrialplot_interactive( cfg, subplothandles, badtrialsindex )
%[ badtrialsindex ] = init_multitrialplot_interactive( cfg, subplothandles, badtrialsindex )
%   Detailed explanation goes here

fprintf('entering interactive mode... press q to quit\n')

%default colour for bad trials
if isempty(cfg) || ~isfield(cfg,'badtrialscolor') || isempty(cfg.badtrialscolor)
    badtrialscolor = [215 48 31]./255;
else
    badtrialscolor = cfg.badtrialscolor;
end

if nargin <= 1 || isempty(subplothandles)
    subplothandles = get(gcf,'children');
end

%remove badtrialsindex from cfg, in case it has been updated
if ~isempty(cfg) && isfield(cfg,'badtrialsindex')
    fprintf('ignoring badtrialsindex field in cfg structure\n')
    cfg = rmfield(cfg, 'badtrialsindex');
end

%default bad trials index (unless specified, define based on axis colour)
if nargin <= 2 || isempty(badtrialsindex)
    badtrialsindex = [];
    fprintf('reconstructing bad trials index from colours in figure\n')
    for s = 1:length(subplothandles)
        if all(get(subplothandles(s),'XColor') == badtrialscolor)
            try
                badtrialsindex = sort([badtrialsindex str2num(get(subplothandles(s),'Tag'))]);
            catch
                badtrialsindex = sort([badtrialsindex; str2num(get(subplothandles(s),'Tag'))]);
            end
        end
    end
end

while 1 == 1
    
    w = waitforbuttonpress;
    switch w
        
        case 1 %keyboard button
            
            key = get(gcf,'currentcharacter');
            if strcmp(key,'q')
                fprintf('trial marking completed.\n')
                break
            end
            
        case 0 %mouse click
            
            subplotindex = [];
            try
                get(gcf,'SelectionType')
                [~, subplotindex] = ismember(gca, subplothandles);
            end
            
            if ~isempty(subplotindex)
                
                clickedtrialindex = str2num(get(subplothandles(subplotindex),'Tag'));
                
                if ismember(clickedtrialindex, badtrialsindex)
                    
                    fprintf('trial %d removed from list of bad trials\n', clickedtrialindex)
                    badtrialsindex(find(ismember(badtrialsindex, clickedtrialindex))) = [];
                    
                    set(subplothandles(subplotindex), 'LineWidth',0.5, 'XColor',[.25 .25 .25], 'YColor',[.25 .25 .25])
                    drawnow
                    
                elseif ~ismember(clickedtrialindex, badtrialsindex)
                    
                    fprintf('trial %d added to list of bad trials\n', clickedtrialindex)
                    try
                        badtrialsindex = sort([badtrialsindex clickedtrialindex]);
                    catch
                        badtrialsindex = sort([badtrialsindex; clickedtrialindex]);
                    end
                    
                    set(subplothandles(subplotindex), 'LineWidth',2, 'XColor',badtrialscolor, 'YColor',badtrialscolor)
                    drawnow
                    
                end %if ismember
            end %if ~isempty
    end %switch
end %while
