function plotn(x, y, titleText)
    % Plot disturbance
    hfig = figure;
    plot(x, y, 'LineWidth', 1);
    grid on
    xlabel('Time (s)')
    ylabel('Input disturbance (V)');
    title(titleText);

    % Formatting
    pictureWidth = 15;
    hw_ratio = 0.65;
    set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
    set(findall(hfig, '-property', 'Box'), 'Box', 'on')
    set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
    set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
    set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
    pos = get(hfig, 'Position');
    set(hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'Papersize', [pos(3), pos(4)])

    % Save as PDF
    print(hfig, 'input_disturbance', '-dpdf', '-painters', '-fillpage')
end
