% Sensor ID 

sensor_ID=10;
index=find([Sensors.serial] == sensor_ID);
ixnonan = find( not(isnan(Sensors(index).lat) & isnan(Sensors(index).lon)) );
    x=Sensors(index).lat(ixnonan);
    y=Sensors(index).lon(ixnonan); 
    z_score=zscore([x,y]);
    z_threshold =3;
    valid_indices=abs(z_score(:,1)) < z_threshold & abs(z_score(:,2)) < z_threshold;
    x=x(valid_indices);
    y=y(valid_indices); 
    K = convhull(x,y);    


% Predict the sensor Location" 
%     mean_x=mean(x(K));
%     mean_y=mean(y(K)); 
    mean_x=mean(x);
    mean_y=mean(y); 
    %figure;
    figure=plot(x(K),y(K),'lineWidth',2);
    hold on;
    scatter(mean_x,mean_y,'DisplayName','Computed');

% Actual Location     
    scatter(Sensors_Locations(sensor_ID).lat,Sensors_Locations(sensor_ID).lon,'DisplayName','Actual Location')
    % Set labels for the x,y and title axes
    xlabel('Latitude','FontWeight','bold');
    ylabel('Longitude','FontWeight','bold');
    legend({'Coverage','Actual','Computed'},'FontWeight','bold');
    %title('Sensor', sensor_ID);
    saveas(figure,fullfile("plots/Plots_Nov/",sprintf('SensorLoc_%d',Sensors(index).serial)));