function plotfft(signal, yLabel, titleText)
    Fs = 2000; % Sampling frequency (Hz)
    % Perform FFT
    N = length(signal);
    frequencies = Fs*(0:(N/2))/N;
    fft_result = fft(signal);
    amplitude_spectrum = 2/N * abs(fft_result(1:N/2+1));    
    
    hfig = figure;
    plot(frequencies, amplitude_spectrum, 'LineWidth', 2);
    grid on
    hold on
    ylim([0, 0.008])
    xlabel('Frequency (Hz)')
    ylabel(yLabel)
    title(titleText)

    % Find the index corresponding to 0.5 Hz
    idx_05Hz = find(frequencies > 20, 1);

    % Find the maximum amplitude value after 20 Hz
    [maxY_after_05Hz, maxIndex_after_05Hz] = max(amplitude_spectrum(idx_05Hz:end));
    
    % Plot a red dot at the maximum point after 20 Hz
    maxFreq = frequencies(idx_05Hz + maxIndex_after_05Hz - 1);
    plot(maxFreq, maxY_after_05Hz, 'ro', 'MarkerSize', 7);
    text(maxFreq + 20, maxY_after_05Hz, [' Amplitude = ' num2str(maxY_after_05Hz) ' mm'], 'Color', 'red');
    text(maxFreq + 20, maxY_after_05Hz - 0.0005, [' Frequency = ' num2str(maxFreq) ' Hz'], 'Color', 'red');
    
    % Show the plot
    grid on;
    
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
end
