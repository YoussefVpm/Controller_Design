% Bar chart MTE
hfig = figure;
names = categorical({'PID','Cascade P/PI','Classical SMC','Sigmoid SMC','ST-SMC'});

RMSE_values_with = [8.3, 49.8, 13.2, 5.7, 7.4];
RMSE_values_without = [10.1, 45.7, 15.4, 6.8, 8.1];

RMSE_values = [RMSE_values_with; RMSE_values_without]';

% Create the bar chart with specified properties
b = bar(names, RMSE_values, 'grouped');

% Set the colors for each set of bars
b(1).FaceColor = "#4DBEEE"; % Blue color for the first set
b(2).FaceColor = "#D95319"; % Red color for the second set

ylim([0 55]);
grid on;

ylabel('Maximum Tracking Error, MTE ($\mu$m)');
legend('With disturbance', 'without disturbance');

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);

xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);

% Add text labels to the bars
text(xtips1, ytips1, labels1, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','FontSize', 10);
text(xtips2, ytips2, labels2, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','FontSize', 10);

pictureWidth = 15;
hw_ratio = 0.65;
% set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])

%% barchart RMSE

hfig = figure;
names = categorical({'PID','Cascade P/PI','Classical SMC','Sigmoid SMC','ST-SMC'});

RMSE_values_with = [2.9, 31.3, 4.9, 2.6, 2.7];
RMSE_values_without = [1.6 31.2 4.4 1.8 2.3];

RMSE_values = [RMSE_values_with; RMSE_values_without]';

% Create the bar chart with specified properties
b = bar(names, RMSE_values, 'grouped');

% Set the colors for each set of bars
b(1).FaceColor = "#4DBEEE"; % Blue color for the first set
b(2).FaceColor = "#D95319"; % Red color for the second set

ylim([0 35]);
grid on;

ylabel('Position Error RMSE ($\mu$m)');
legend('With disturbance', 'without disturbance');

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);

xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);

% Add text labels to the bars
text(xtips1, ytips1, labels1, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','FontSize', 10);
text(xtips2, ytips2, labels2, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','FontSize', 10);

pictureWidth = 15;
hw_ratio = 0.65;
% set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])



%%
% Bar chart
hfig = figure;
names = categorical({'Disturbance Force', 'PID','Cascade P/PI','Classical SMC','Sigmoid SMC','ST-SMC'});
FFT_values = [2.7776, 2.2385, 2.0851 0.9970 0.8804 1.2985];
bar(names,FFT_values, 0.5, 'FaceColor', "#4DBEEE")
% ylim([0 0.006]);
grid on
text(names, FFT_values, num2str(FFT_values'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
ylabel('Peak Value of FFT tracking error ($\mu$ m)');


pictureWidth = 15;
hw_ratio = 0.65;
% set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
