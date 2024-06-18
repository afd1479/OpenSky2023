% Assuming 'Sensors' and 'Sensors_Locations' are defined as described
% Extract the list of sensors from Sensors_Locations
num_sensors_locations = length(Sensors_Locations);
num_sensors = length(Sensors);

% Initialize arrays to store coordinates for plotting
sensor_lat_all = [];
sensor_lon_all = [];
predicted_lat_all = [];
predicted_lon_all = [];
error_lines = {};

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
            
            % Store coordinates for plotting
            sensor_lat_all = [sensor_lat_all; centroid_lat];
            sensor_lon_all = [sensor_lon_all; centroid_lon];
            predicted_lat_all = [predicted_lat_all; predicted_lat];
            predicted_lon_all = [predicted_lon_all; predicted_lon];
            error_lines{end+1} = [centroid_lat, centroid_lon; predicted_lat, predicted_lon];
        end
    end
end

% Plotting

% Scatter plot with error bars
figure;
hold on;
% Plot sensor locations
h1 = scatter(sensor_lat_all, sensor_lon_all, 'bo');
% Plot predicted locations
h2 = scatter(predicted_lat_all, predicted_lon_all, 'ro');
for i = 1:length(error_lines)
    plot(error_lines{i}(:,1), error_lines{i}(:,2), 'k--');
end
xlabel('Latitude');
ylabel('Longitude');
title('Sensor and Predicted Locations with Error Bars');
% Add legend with only the required entries
legend([h1, h2], {'Sensor Locations', 'Predicted Locations'});
hold off;
