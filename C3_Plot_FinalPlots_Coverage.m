% Sensors coverage as scatter points with -outliers
    index=33; 
    ixnonan = find( not(isnan(Sensors(index).lat) & isnan(Sensors(index).lon)) );
    x=Sensors(index).lat(ixnonan);
    y=Sensors(index).lon(ixnonan); 
    figure;
    figure1=scatter(x,y, 'filled');
    %title('Title','FontSize',20);
    % Customize xy-axis labels with sensor names
    %yticks(abs(min(y)):abs(max(y)));
    %xticks(abs(min(x)):abs(max(x)));
    xlim([abs(min(x)) abs(max(x))]);
    ylim([abs(min(y)) abs(max(y))]);
    % yticklabels(sensorNames);

    % Set labels for the x and y axes
    xlabel('Latitude','FontWeight','bold');
    ylabel('Longitude','FontWeight','bold');
    %saveas(figure,sprintf('Sensor_%d',index));
    saveas(figure1,fullfile('plots/Plots_Nov/',sprintf('SensorWith_%d',Sensors(index).serial)));
    %fullfile("plots/Plots_Nov/)

%%%%% Sensors coverage as scatter points without -outliers %%%%%%% 

    z_score=zscore([x,y]);
    z_threshold =3;
    valid_indices=abs(z_score(:,1)) < z_threshold & abs(z_score(:,2)) < z_threshold;
    x_v=x(valid_indices);
    y_v=y(valid_indices); 
   
    figure;
    figure2=scatter(x_v,y_v, 'filled');
    
    xlim([abs(min(x)) abs(max(x))]);
    ylim([abs(min(y)) abs(max(y))]);
    % yticklabels(sensorNames);

    % Set labels for the x and y axes
    xlabel('Latitude','FontWeight','bold');
    ylabel('Longitude','FontWeight','bold');

    saveas(figure2,fullfile("plots/Plots_Nov/",sprintf('SensorOut_%d',Sensors(index).serial)));
