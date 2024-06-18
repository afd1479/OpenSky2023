%%%%%%%%%% Plot the boundary of each sensor as scatter plints 

for sen=2:length(unique_sens)
    index=find([Sensors.serial] == unique_sens(sen));
    boundary = [Sensors(index).boundary(:,1),Sensors(index).boundary(:,2)]; 
    figure;
    scatter(Sensors(index).boundary(:,1),Sensors(index).boundary(:,2), 'filled');
    title('sensor %s ',unique_sens(sen));
    %hold on;
end

%hold off; 
%%%%%%%%%%%%%%%%%%%%%%%%% Plot Trajectory + convhull for sensors
figure
scatter(Flights{425,1}.latitude,Flights{425,1}.longitude, 'DisplayName', 'Trajectory 1')
% Store convhull

hold on;
for sen=2:length(unique_sens)
    index=find([Sensors.serial] == unique_sens(sen));
    %boundary = [Sensors(index).boundary(:,1),Sensors(index).boundary(:,2)];
    ixnonan = find( not(isnan(Sensors(index).lat) & isnan(Sensors(index).lon)) );
    x=Sensors(index).lat(ixnonan);
    y=Sensors(index).lon(ixnonan);
    K = convhull(x,y);
    %boundary_convhull = [Sensors(sen).lat(tmp), Sensors(sen).lon(tmp)];
    %scatter(Sensors(sen).lat(ixnonan), Sensors(sen).lon(ixnonan), 'filled' );  
    plot(x(K),y(K),'lineWidth',2);
end
hold off;
%%%%%%%%%%%%%%%%%%%% 

for sen=2:length(unique_sens)
    index=find([Sensors.serial] == unique_sens(sen));

    ixnonan = find( not(isnan(Sensors(index).lat) & isnan(Sensors(index).lon)) );
    x=Sensors(index).lat(ixnonan);
    y=Sensors(index).lon(ixnonan); 
    figure;
    scatter(x,y, 'filled');
    title('sensor',unique_sens(sen));
    %hold on;
end
%hold off; 