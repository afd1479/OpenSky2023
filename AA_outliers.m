% Remove the outliers of the sensors boundary 

for index=1:length(Sensors)

% % % ixnonan = find( not(isnan(Sensors(index).lat) & isnan(Sensors(index).lon)) );
% % % 
% % % x=Sensors(index).lat(ixnonan);
% % % y=Sensors(index).lon(ixnonan); 
% % % z_score=zscore([x,y]);
% % % z_threshold =3;
% % % valid_indices=abs(z_score(:,1)) < z_threshold & abs(z_score(:,2)) < z_threshold;
% % % x=x(valid_indices);
% % % y=y(valid_indices);

% figure;
% scatter(x,y, 'filled');
% xlabel('Lat');
% ylabel('Lon');
% title('Sensor', 320);
% Sensors(index).lat(ixnonan)=x;
% Sensors(index).lon(ixnonan)=y;
ixnonan = find( not(isnan(Sensors(index).lat) & isnan(Sensors(index).lon)) );
x=Sensors(index).lat(ixnonan);
y=Sensors(index).lon(ixnonan);
z_score=zscore([x,y]);
z_threshold =3;
valid_indices=abs(z_score(:,1)) < z_threshold & abs(z_score(:,2)) < z_threshold;
x=x(valid_indices);
y=y(valid_indices);
K = convhull(x,y);
    %boundary_convhull = [Sensors(sen).lat(tmp), Sensors(sen).lon(tmp)];
    %scatter(Sensors(sen).lat(ixnonan), Sensors(sen).lon(ixnonan), 'filled' );  
    plot(x(K),y(K),'lineWidth',2);

K = convhull(x,y);    
% Predict the sensor Location" 
mean_x=mean(x(K));
mean_y=mean(y(K));
figure;
plot(x(K),y(K),'lineWidth',2);
hold on;
scatter(mean_x,mean_y,'DisplayName','Computed');
index=477;
scatter(Sensors_Locations(index).lat,Sensors_Locations(index).lon,'DisplayName','Actual Location')
xlabel('Lat');
ylabel('Lon');
title('Sensor', index);


end 

 