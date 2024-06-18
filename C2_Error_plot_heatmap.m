% Error Distripution plotting
% List1:Actual Locations
% List2:Computed Locations
list1 = [Sensors_locations_actual_computed(:,1),Sensors_locations_actual_computed(:,2)];
%list2 = [Sensors_locations_actual_computed(:,3),Sensors_locations_actual_computed(:,4)];
list2 = [Sensors_locations_actual_computed(:,1),Sensors_locations_actual_computed(:,2)];






% Calculate Haversine distances between points in List 1 and List 2
distances_matrix = zeros(size(list1, 1), size(list2, 1));

for i = 1:size(list1, 1)
    for j = 1:size(list2, 1)
        distances_matrix(i, j) = haversine(list1(i, 1), list1(i, 2), list2(j, 1), list2(j, 2));
    end
end

% Use a logarithmic color sacle
logDistancesMatrix=log1p(distances_matrix);

% Distance matrix heatmap using imagesc
figure;
%imagesc(logDistancesMatrix);
imagesc(distances_matrix);
colormap('jet');
colorbar;

% Add labels and title
%xlabel('Computed Locations',FontWeight='bold');
xlabel('Actual Locations',FontWeight='bold');
ylabel('Actual Locations','FontWeight','bold');
title('Distance between Actual and Computed Sensors Locations ','FontWeight','bold');
%title('Distance between each Pairwise Actual Sensors Locations ','FontWeight','bold');

