%%% Get the mean and std between the reported and estimated values.
% Initialize arrays to store errors
all_errors = [];

% Function to calculate the Haversine distance between two points
haversine = @(lat1, lon1, lat2, lon2) 2 * 6371 * asin(sqrt(sin(deg2rad(lat2 - lat1) / 2).^2 + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) .* sin(deg2rad(lon2 - lon1) / 2).^2));

% Getting the flights
for Flights_ID = 1:length(Flights)
    % Extract latitude and longitude data
    x = [Flights{Flights_ID, 1}.latitude];
    y = [Flights{Flights_ID, 1}.longitude];

    x1 = [Computed_Flights{Flights_ID, 1}.latitude];
    y1 = [Computed_Flights{Flights_ID, 1}.longitude];

    x2 = [Computed_Flights_m2{Flights_ID, 1}.latitude];
    y2 = [Computed_Flights_m2{Flights_ID, 1}.longitude];

    x3 = [Computed_Flights_m3{Flights_ID, 1}.latitude];
    y3 = [Computed_Flights_m3{Flights_ID, 1}.longitude];

    % Create a logical index to identify NaN values in either x or y
    valid_indices1 = ~isnan(x1) & ~isnan(y1);
    valid_indices2 = (x2 ~= -1000) & (y2 ~= -1000);
    valid_indices3 = (x3 ~= -1000) & (y3 ~= -1000);

    % Filter the data to exclude points with NaN values
    % Filter the data to exclude points with NaN values
% This with method one
    x_valid = x(valid_indices1);  
    y_valid = y(valid_indices1);
    
    % This with method two
    % x_valid = x(valid_indices2);
    % y_valid = y(valid_indices2);
    % 
    % % This with method three
     % x_valid = x(valid_indices3);
     % y_valid = y(valid_indices3);

    x1_valid = x1(valid_indices1);
    y1_valid = y1(valid_indices1);

    x2_valid = x2(valid_indices2);
    y2_valid = y2(valid_indices2);

    x3_valid = x3(valid_indices3);
    y3_valid = y3(valid_indices3);

    % Define two matrices representing geographical coordinates (latitude and longitude)
    trajectory1 = [x_valid, y_valid];
    trajectory2 = [x1_valid, y1_valid];
    % trajectory2 = [x2_valid, y2_valid]; 
    %trajectory2 = [x3_valid, y3_valid];

    % Calculate the distances between corresponding points in the two trajectories
    for i = 1:size(trajectory1, 1)
        distance = haversine(trajectory1(i, 1), trajectory1(i, 2), trajectory2(i, 1), trajectory2(i, 2));
        all_errors = [all_errors; distance];
    end
end

% Remove NaN values from all_errors array
all_errors = all_errors(~isnan(all_errors));

% Calculate mean and standard deviation
mean_error = mean(all_errors);
std_error = std(all_errors);

% Create the figure
figure;
hold on;

% Plot the kernel density estimate (KDE) of errors
[f, xi] = ksdensity(all_errors,'Support','positive');
plot(xi, f, 'LineWidth', 2, 'DisplayName', 'Error Distribution');

% Plot the mean line
mean_line = xline(mean_error, '--r', 'LineWidth', 2, 'DisplayName', 'Mean');
mean_line.Label = sprintf('Mean = %.2f', mean_error);
mean_line.LabelVerticalAlignment = 'bottom';
mean_line.LabelHorizontalAlignment = 'right';

% Plot the standard deviation lines
std_line1 = xline(mean_error + std_error, '--b', 'LineWidth', 2, 'DisplayName', '+1 SD');
std_line1.Label = sprintf('+1 SD = %.2f', mean_error + std_error);
std_line1.LabelVerticalAlignment = 'bottom';
std_line1.LabelHorizontalAlignment = 'right';

std_line2 = xline(mean_error - std_error, '--b', 'LineWidth', 2, 'DisplayName', '-1 SD');
std_line2.Label = sprintf('-1 SD = %.2f', mean_error - std_error);
std_line2.LabelVerticalAlignment = 'bottom';
std_line2.LabelHorizontalAlignment = 'right';

% Customize the plot
xlabel('Error (Distance in km)');
ylabel('Density');
title('Error Distribution with Mean and Standard Deviation');
legend('Location', 'northeast');
grid on;
hold off;
