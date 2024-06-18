% Plot the trajectory and the sensors across its trajectory 
% Get the sensors seq and order from sensors_seq.m file. 
sensorData = sensors_seq_ord;
% Determine the number of time slots and sensors
numTimeSlots = length(sensorData);
sensorNames = unique_sens;

% Initialize arrays to store x and y coordinates for the scatter plot
x = [];
y = [];

% Loop through each time slot and sensor name
for t = 1:numTimeSlots
    for s = 2:length(sensorNames)
        % Check if the sensor is in the list for the current time slot
        if ismember(sensorNames(s), sensorData(t,:))
            % If the sensor is active at this time slot, add its coordinates
            x = [x, t];
            y = [y, s];
        end
    end
end

% Create the scatter plot
figure;
scatter(x, y, 'filled');

% Customize y-axis labels with sensor names
yticks(1:numel(sensorNames));
yticklabels(sensorNames);

% Set labels for the x and y axes
xlabel('Time Slot');
ylabel('Sensor Name');

% Adjust axis properties for better visualization (optional)
axis tight;