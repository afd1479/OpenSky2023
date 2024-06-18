%%%%%%% This file compute the expected location based on 
% central Location method
% mesh network method
%%%% Classical way - Central Point inside the intersection area

clear Computed_Flights Computed_Flights_m2 Computed_Flights_m3;

Computed_Flights=Flights;
Computed_Flights_m2=Flights;
Computed_Flights_m3=Flights;
empty_counter=0;
for index = 1:length(Flights)
    for m=1:length(Flights{index,1}.id)
    %%%% All the code should come here %%%%
    
            %%%%% 1. Get the senosrs that receive the message.         
            serials = regexp((Flights{index,1}.measurements{m}),'],[','split');
            serials(1,1)=regexprep(serials(1,1),'[','');
            serials(1,end)=regexprep(serials(1,end),']','');
            [SenM,SenN]=size(serials);
            SensorsIDs=[];
            for j = 1:SenN
                % FIND SENSOR
                sensorData=regexp((serials(1,j)),',','split');
                currentsensor=struct('ID', str2double(sensorData{1,1}(1,1)),...
                                     'Time',str2double(sensorData{1,1}(1,2)),...
                                     'RSS',str2double(sensorData{1,1}(1,3)));
                   SensorsIDs(end+1,:)= [currentsensor.ID, currentsensor.RSS,currentsensor.Time ] ;     
                   %SensorsIDs(end+1)= currentsensor.ID;             
            end

            %%% Sorting sensors for weights purposese %%%
            %%% We did not use this for the first method %%%
            % Sort sensors based on RSS
            % SensorsIDs=sortrows(SensorsIDs,2,'ascend'); 

            % Sort sensors based on Time here
            SensorsIDs=sortrows(SensorsIDs,3,'ascend');

            %%% Start getting the expected locations %%%
            sensorsCounter=0;           
            % Handel the situation where only one sensor receive the message
                if size(SensorsIDs,1)==1   %CASE1
                    Sensor_index = find([Sensors.serial] == SensorsIDs(1,1));                    
                    C = [Sensors(Sensor_index).boundary(:,1),Sensors(Sensor_index).boundary(:,2)]; 
%                     [x,y]=centroid(polyshape(C));  
                    
                % Handel situation where two sensors receive the message.  
%                 sensorsCounter=1;
                elseif size(SensorsIDs,1)==2   %CASE2
                    Sensor_index = find([Sensors.serial] == SensorsIDs(1,1));
                    Sensor_index2 = find([Sensors.serial] == SensorsIDs(2,1));
                    %%% polyshape is one method -1
                    %%% intersect function method -2 (clost to the most area)
                    %%% Define barycentric weight method 3 This is could be for the one who receive it first.
                    
                    
                    A = [Sensors(Sensor_index).boundary(:,1),Sensors(Sensor_index).boundary(:,2)]; 
                    B = [Sensors(Sensor_index2).boundary(:,1),Sensors(Sensor_index2).boundary(:,2)]; 
                    
                    C = intersect(polyshape(A),polyshape(B));

%                     % check if two boundaries has only 2 vertices
%                     sensorsCounter=2;
%                     if length(C.Vertices)<=2
%                         % Right code to take the middle point of two
%                         % boundaries. 
%                         % midpointX= /2;
%                         % midpointY= /2;
%                         % C= [midpointX,midpointY];
%                         C=A;
%                         sensorsCounter=1;
%                     end

                    % Get the predicted point
%                     [x,y]=centroid(polyshape(C)); 
                   

                    
                elseif size(SensorsIDs,1)>=3  %CASE3
                    
                    Sensor_index = find([Sensors.serial] == SensorsIDs(1,1));
                    Sensor_index2 = find([Sensors.serial] == SensorsIDs(2,1));
                    
                    A = [Sensors(Sensor_index).boundary(:,1),Sensors(Sensor_index).boundary(:,2)]; 
                    B = [Sensors(Sensor_index2).boundary(:,1),Sensors(Sensor_index2).boundary(:,2)]; 
                    
                    C = intersect(polyshape(A),polyshape(B));
%                     sensorsCounter=2;
                    %%% Here if only we have two points we can take midpointof the two points
% 
%                     if length(C.Vertices)<=2
%                         % Right code to take the middle point of two
%                         % boundaries. 
%                         % midpointX= /2;
%                         % midpointY= /2;
%                         % C= [midpointX,midpointY];
%                         C=A;
%                         sensorsCounter=1;
%                     end
%                     
                      counter=size(SensorsIDs,1)-2;
                                          
                    ii=3;
                    while counter>0                        
                        Sensor_index3 = find([Sensors.serial] == SensorsIDs(ii,1));
%                         %M=polyshape(Sensors(Sensor_index3).boundary(:,1),Sensors(Sensor_index3).boundary(:,2),'Simplify',false);
                        M=[Sensors(Sensor_index3).boundary(:,1),Sensors(Sensor_index3).boundary(:,2)];
%                         backup_C=C;
                        C = intersect(C,polyshape(M));
                        ii=ii+1;
                        counter=counter-1;
%                         sensorsCounter=sensorsCounter+1;
% %                         if length(C.Vertices)<=2
% %                            C= backup_C;
% %                            sensorsCounter=sensorsCounter-1;
% %                         end
                    end

                        %[x,y]=centroid(polyshape(C));
                       
                        
                end 
%      if length(C.Vertices)<=2
%                         % Right code to take the middle point of two
%                         % boundaries. 
%                         % midpointX= /2;
%                         % midpointY= /2;
%                         % C= [midpointX,midpointY];
%                         C=A;
%                         sensorsCounter=1;
%     end           
    
    %%% Method 1 - Central Location %%%
    %[x,y]= Predict_central(C);  
    [x,y]=centroid(C);
    Computed_Flights{index,1}.latitude(m)=x;
    Computed_Flights{index,1}.longitude(m)=y;

    %%% Method 2 - Random Locations and selected based on its distnace from sensors %%%
    %%% [x,y]= Predict_random(C, SensorsIDs);  

if ~isempty(C.Vertices)

%%%%%%%%%%%%%%%% TEMP CODE - Start %%%%%%%
% Extract the x-axis and y-axis bounds

      intersectionX=[min(C.Vertices(:,1)),max(C.Vertices(:,1))];
      intersectionY=[min(C.Vertices(:,2)),max(C.Vertices(:,2))];

% Extract the location of the sensor with the First TOA 

      Sensor_index = find([Sensors_Locations.serial] == SensorsIDs(1,1));

% Define the coordinates of the specific sensor you want to be close to
      specificSensorX = Sensors_Locations(Sensor_index).lat; % Replace with the actual coordinates
      specificSensorY = Sensors_Locations(Sensor_index).lon; % Replace with the actual coordinates

% Generate random points within the intersection
      numPoints = 100; % Number of random points to generate
      randomPointsX = intersectionX(1) + rand(1, numPoints) * (intersectionX(2) - intersectionX(1));
      randomPointsY = intersectionY(1) + rand(1, numPoints) * (intersectionY(2) - intersectionY(1));

% Calculate distances from each random point to the specific sensor
      distancesToSensor = sqrt((randomPointsX - specificSensorX).^2 + (randomPointsY - specificSensorY).^2);

% Choose a point that is closest to the specific sensor (customize this selection criterion)
      minDistanceIndex = find(distancesToSensor == min(distancesToSensor));
      selectedPointX = randomPointsX(minDistanceIndex);
      selectedPointY = randomPointsY(minDistanceIndex);

      x=selectedPointX;
      y=selectedPointY;


%%%%%%%%%%%%%%%%%%% TEMP CODE - End %%%%%%%%%
    Computed_Flights_m2{index,1}.latitude(m)=x;
    Computed_Flights_m2{index,1}.longitude(m)=y;


    %%% Method 3 - Grid of Locations and Weights for each based on distnace from sensors %%%
    %%%% [x,y]= Predict_mesh(C, SensorsIDs);   
%%%%%%%%%%%%%%%% TEMP CODE - Start %%%%%%%
    
% Extract the x-axis and y-axis bounds

   intersectionX=[min(C.Vertices(:,1)),max(C.Vertices(:,1))];
   intersectionY=[min(C.Vertices(:,2)),max(C.Vertices(:,2))];


% Extract the location of the sensor with the First TOA 

   Sensor_index = find([Sensors_Locations.serial] == SensorsIDs(1,1));

% Define the coordinates of the specific sensor you want to be close to
   specificSensorX = Sensors_Locations(Sensor_index).lat; % Replace with the actual coordinates
   specificSensorY = Sensors_Locations(Sensor_index).lon; % Replace with the actual coordinates

% Define grid/mesh parameters
   xStep = 0.1; % X-axis grid spacing
   yStep = 0.1; % Y-axis grid spacing


% Generate a grid of points within the intersection
   [xGrid, yGrid] = meshgrid(intersectionX(1):xStep:intersectionX(2), intersectionY(1):yStep:intersectionY(2));


% Define the reference point
    xRef = specificSensorX;
    yRef = specificSensorY;

% Calculate distances from the reference point to each grid point
    distancesToSensor = sqrt((xGrid - xRef).^2 + (yGrid - yRef).^2);

% Define a function to calculate weights based on distances (you can customize this)
    weightFunction = @(d) 1./(d + 0.1); % Example: Inverse distance with a small offset

% Calculate weights based on distances
    weights = weightFunction(distancesToSensor);

    max_value= max(weights(:));
    [row_index,col_index]=find(weights == max_value);

% Choose a point that with spesifc weight 

    x=xGrid(row_index,col_index);
    y=yGrid(row_index,col_index); 

%%%%%%%%%%%%%%% TEMP CODE - End %%%%%%%%%


    Computed_Flights_m3{index,1}.latitude(m)=x;
    Computed_Flights_m3{index,1}.longitude(m)=y;
else
    Computed_Flights_m3{index,1}.latitude(m)=-1000;
    Computed_Flights_m3{index,1}.longitude(m)=-1000;
    empty_counter=empty_counter+1;
    Computed_Flights_m2{index,1}.latitude(m)=x;
    Computed_Flights_m2{index,1}.longitude(m)=y;
end 
    end
end

