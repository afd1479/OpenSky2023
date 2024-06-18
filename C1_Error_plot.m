% Assuming 'Sensors' and 'Sensors_Locations' are defined as described
% Extract the list of sensors from Sensors_Locations
num_sensors_locations = length(Sensors_Locations);
num_sensors = length(Sensors);

% Initialize array to store errors
errors = [];

for i = 1:num_sensors_locations
    % Find the corresponding sensor in Sensors by serial number
    serial_number = Sensors_Locations(i).serial;
    sensor_idx = find(arrayfun(@(x) x.serial, Sensors) == serial_number);
    
    if ~isempty(sensor_idx)
        % Extract coordinates
        sensor_lat = Sensors(sensor_idx).lat;
        sensor_lon = Sensors(sensor_idx).lon;
        
        % Filter out non-finite values
        valid_idx = isfinite(sensor_lat) & isfinite(sensor_lon);
        sensor_lat = sensor_lat(valid_idx);
        sensor_lon = sensor_lon(valid_idx);
        
        % Extract the predicted location from Sensors_Locations
        predicted_lat = Sensors_Locations(i).lat;
        predicted_lon = Sensors_Locations(i).lon;
        
        % Ensure there are enough unique points to compute the convex hull
        unique_points = unique([sensor_lat(:), sensor_lon(:)], 'rows');
        
        if size(unique_points, 1) >= 3
            % Calculate the convex hull
            x = sensor_lat;
            y = sensor_lon;
            K = convhull(x, y);
            
            % Calculate the centroid of the convex hull
            centroid_lat = mean(x(K));
            centroid_lon = mean(y(K));
            
            % Calculate the Haversine distance from the centroid to the predicted location
            R = 6371; % Earth's radius in kilometers
            lat_diff = deg2rad(predicted_lat - centroid_lat);
            lon_diff = deg2rad(predicted_lon - centroid_lon);
            a = sin(lat_diff / 2).^2 + cos(deg2rad(centroid_lat)) .* cos(deg2rad(predicted_lat)) .* sin(lon_diff / 2).^2;
            c = 2 * atan2(sqrt(a), sqrt(1 - a));
            d = R * c; % Haversine distance
            
            % Ensure d is a column vector
            d = d(:);
            
            % Append errors
            errors = [errors; d];
        end
    end
end

% Plotting

% Scatter plot with error bars
figure;
hold on;
for i = 1:num_sensors_locations
    scatter(Sensors_Locations(i).lat, Sensors_Locations(i).lon, 'bo', 'DisplayName', 'Sensor Locations');
    if ~isempty(sensor_idx)
        scatter(sensor_lat, sensor_lon, 'ro', 'DisplayName', 'Predicted Locations');
        plot([Sensors_Locations(i).lat, sensor_lat], ...
             [Sensors_Locations(i).lon, sensor_lon], 'k--');
    end
end
xlabel('Latitude');
ylabel('Longitude');
legend;
title('Sensor and Predicted Locations with Error Bars');
hold off;

% Residual plot
figure;
plot(errors, 'o');
xlabel('Point Index');
ylabel('Error (Distance in km)');
title('Residual Plot');

% Histogram of errors
figure;
histogram(errors, 10);
xlabel('Error (Distance in km)');
ylabel('Frequency');
title('Histogram of Errors');

% Box plot of errors
figure;
boxplot(errors, 'Orientation', 'horizontal');
xlabel('Error (Distance in km)');
title('Box Plot of Errors');

% Heatmap of errors (if applicable)
% Creating an example grid for visualization
x_coords = linspace(min([Sensors_Locations.lat]), max([Sensors_Locations.lat]), 100);
y_coords = linspace(min([Sensors_Locations.lon]), max([Sensors_Locations.lon]), 100);
[X, Y] = meshgrid(x_coords, y_coords);
Z = zeros(size(X));

% Assuming errors are spatially distributed for visualization
for i = 1:num_sensors_locations
    Z = Z + exp(-((X - Sensors_Locations(i).lat).^2 + (Y - Sensors_Locations(i).lon).^2));
end

figure;
contourf(X, Y, Z, 'LineColor', 'none');
colorbar;
xlabel('Latitude');
ylabel('Longitude');
title('Heatmap of Errors');

