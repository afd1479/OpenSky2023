% Assuming 'errors' contains the error values calculated previously

% Calculate mean and standard deviation
mean_error = mean(errors);
std_error = std(errors);

% Create the figure
figure;
hold on;

% Plot the histogram of errors
histogram(errors, 20, 'Normalization', 'pdf', 'FaceColor', [0.7 0.7 0.7]);

% Plot the mean line
mean_line = xline(mean_error, '--r', 'LineWidth', 2);
mean_line.Label = sprintf('Mean = %.2f', mean_error);
mean_line.LabelVerticalAlignment = 'bottom';
mean_line.LabelHorizontalAlignment = 'right';

% Plot the standard deviation lines
std_line1 = xline(mean_error + std_error, '--b', 'LineWidth', 2);
std_line1.Label = sprintf('+1 SD = %.2f', mean_error + std_error);
std_line1.LabelVerticalAlignment = 'bottom';
std_line1.LabelHorizontalAlignment = 'right';

std_line2 = xline(mean_error - std_error, '--b', 'LineWidth', 2);
std_line2.Label = sprintf('-1 SD = %.2f', mean_error - std_error);
std_line2.LabelVerticalAlignment = 'bottom';
std_line2.LabelHorizontalAlignment = 'right';

% Customize the plot
xlabel('Error (Distance in km)');
ylabel('Probability Density');
title('Error Distribution with Mean and Standard Deviation');
legend({'Error Distribution', 'Mean', '+/- 1 SD'}, 'Location', 'northeast');
grid on;
hold off;
