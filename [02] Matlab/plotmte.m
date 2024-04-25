function plotmte(x, y, xLabel, yLabel, titleText, filename, save)
    hfig = figure;
    plot(x, y, 'LineWidth', 1);
    grid on
    hold on
    xlabel(xLabel)
    ylabel(yLabel)
    title(titleText)
    
    xSubset = x(x > 0.5);
    ySubset = y(x > 0.5);
    [maxY, maxIndex] = max(ySubset);
    maxX = xSubset(maxIndex);

    % Plot a red dot at the maximum point
    plot(maxX, maxY, 'ro', 'MarkerSize', 7, 'LineWidth', 3);

    % Trace a horizontal line at the maximum point
    plot([0, 15], [maxY, maxY], '--', 'Color', 'red');

    % Display the maximum point
    text(6, maxY+0.003, [' MTE = ' num2str(maxY) ' mm'], 'Color', 'red');

    hold off;
    
    % formatting
    pictureWidth = 15;
    hw_ratio = 0.65;
    set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
    set(findall(hfig, '-property', 'Box'), 'Box', 'on')
    set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
    set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
    set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
    pos = get(hfig, 'Position');
    set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
    % print(hfig, 'custom_plot', '-dpdf', '-painters', '-fillpage')
    if strcmpi(save, 'yes') && nargin == 7
        print(hfig, filename, '-dpdf', '-painters', '-fillpage');
    end
end
