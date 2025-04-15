%% Run this script to make plot pretty. 

% Plot something, then call this script to make the plot pretty. 

% Turn plot box on
set(gca,'Box','on')

% Make lines wide enough to see
set(gca, 'LineWidth', 2)

% Make font size legible
set(gca,'FontSize',16)

% Make the box square
pbaspect([1 1 1])

% Change all line widths
    set(findall(gca, 'Type', 'Line'),'LineWidth',3);