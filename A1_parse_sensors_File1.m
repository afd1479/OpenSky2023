
%%%%% Parse ADS-B message to get the sensors and its data %%%%%
%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;
clc;
format long;
rng('default'); %for debugging purposes

% Date and Time
day=1;
file = readtable(strcat('/path',num2str(day),'.csv'));


%%%%%%%%%%%%%%%%%%%
%%% SENSOR LIST %%%


%%% Sensors that we need 
 Sensors = struct('serial', [], ...
                  'lat', [], ...
                  'lon', [], ...
                  'baroaltitude', [], ...
                  'geoaltitude', [], ...    
                  'boundary', []);

   
    for i = 1:height(file)
        % Struct of ADS-B Message
        ADSB_Message = struct('time', table2cell(file(i,2)), ...
                              'icao24', table2cell(file(i,3)), ...
                              'lat', table2cell(file(i,4)), ...
                              'lon', table2cell(file(i,5)), ...                              
                              'baroaltitude', table2cell(file(i,6)), ...
                              'geoaltitude', table2cell(file(i,7)), ...
                              'serials', table2cell(file(i,9)),...
                              'msgID', table2cell(file(i,1)));
        
        
       
        

        %%%%%%%%%%%%%%%%%%%%%
        %%% SENSOR CHECKS %%%
        %%%%%%%%%%%%%%%%%%%%%
        % Parse Sensors
        serials = regexp((ADSB_Message.serials),'],[','split');
        serials(1,1)=regexprep(serials(1,1),'[','');
        serials(1,end)=regexprep(serials(1,end),']','');
        [SenM,SenN]=size(serials);
        for j = 1:SenN
            % FIND SENSOR
            sensorData=regexp((serials(1,j)),',','split');
            currentsensor=struct('ID', str2double(sensorData{1,1}(1,1)),...
                                 'Time',str2double(sensorData{1,1}(1,2)),...
                                 'RSS',str2double(sensorData{1,1}(1,3)));
        
            % Get sensor Index
            index = find([Sensors.serial] == currentsensor.ID);
   
            % New Sensor
            if isempty(index)
                % Init Sensor
                if isempty(Sensors(1).serial)
                    Sensors(end).serial = currentsensor.ID;
                else
                    Sensors(end+1).serial = currentsensor.ID;
                end
            
                % New Track
                Sensors(end).time = ADSB_Message.time;               
                Sensors(end).lat = ADSB_Message.lat;
                Sensors(end).lon = ADSB_Message.lon;
                Sensors(end).baroaltitude = ADSB_Message.baroaltitude;
                Sensors(end).geoaltitude = ADSB_Message.geoaltitude;

               
        
            % Old Sensor
            else            
                % Store ADS-B Data
                Sensors(index).time(end+1) = ADSB_Message.time;                
                Sensors(index).lat(end+1) = ADSB_Message.lat;
                Sensors(index).lon(end+1) = ADSB_Message.lon;
                Sensors(index).baroaltitude(end+1) = ADSB_Message.baroaltitude;
                Sensors(index).geoaltitude(end+1) = ADSB_Message.geoaltitude;
            
               
            end
        end
        clear currentsensor ADSB_Message;
       end
   