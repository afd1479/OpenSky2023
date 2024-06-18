%%% Get the expected sensors Locations based on their coverage (boundary)
Sensors_locations_actual_computed=[];

for s=1:length(Sensors)
    sensor_ID=Sensors(s).serial;
    index=sensor_ID;
    ixnonan = find( not(isnan(Sensors(s).lat) & isnan(Sensors(s).lon)) );
    x=Sensors(s).lat(ixnonan);
    y=Sensors(s).lon(ixnonan); 
    z_score=zscore([x,y]);
    z_threshold =3;
    valid_indices=abs(z_score(:,1)) < z_threshold & abs(z_score(:,2)) < z_threshold;
    x=x(valid_indices);
    y=y(valid_indices); 
    K = convhull(x,y);    
    

% Predicted Locations of Sensors
    mean_x=mean(x);
    mean_y=mean(y); 

% Actual Locations
  clear x y;
  x=Sensors_Locations(index).lat;
  y=Sensors_Locations(index).lon;

 dis_diff = haversine(x, y, mean_x, mean_y);
 Sensors_locations_actual_computed(end+1,:)=[x,y,mean_x,mean_y,dis_diff];
 %std(Sensors_locations_actual_computed(:,5));
end

%scatter(Sensors_locations_actual_computed(:,1),Sensors_locations_actual_computed(:,2));




