%%%%% Get the sensors coverage that shows where 
%%%% the sensor receive an ADS-B message- 
%%%% This only one time for all sensors that we have.

Sensors_Locations = struct('serial', [], ...
                 'lat', [], ...
                 'lon', [],...
                 'height',[]);
   clear file; 
   file = readtable(strcat('/home/afd8/Downloads/sensors',num2str(1),'.csv'));          
             
   for i = 1:height(file)
        % Struct of 1 ADS-B Message
        ADSB_Message = struct('serial', table2cell(file(i,1)),...
                              'lat', table2cell(file(i,2)), ...
                              'lon', table2cell(file(i,3)), ...                              
                              'height', table2cell(file(i,4)));          
             
             
             index = find([Sensors_Locations.serial] == ADSB_Message.serial);
   
            % New Sensor
            if isempty(index)
                % Init Sensor
                if isempty(Sensors_Locations(1).serial)
                    Sensors_Locations(end).serial = ADSB_Message.serial;
                else
                    Sensors_Locations(end+1).serial = ADSB_Message.serial;
                end
            
                % New Track
                         
                Sensors_Locations(end).lat = ADSB_Message.lat;
                Sensors_Locations(end).lon = ADSB_Message.lon;
                Sensors_Locations(end).height = ADSB_Message.height;
               

               
        
            % Old Sensor
            else            
                % Store ADS-B Data
                            
                Sensors_Locations(index).lat(end+1) = ADSB_Message.lat;
                Sensors_Locations(index).lon(end+1) = ADSB_Message.lon;
                Sensors_Locations(index).height = ADSB_Message.height;
               
               
            end
    
   end
            
   
   