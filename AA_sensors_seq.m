clear sensors_seq_ord;
sensors_seq_ord=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%sen_numbers_uni=[0,0];

% 425

%for fly=1:length(Flights)
Flight_ID=425; 
for m=1:length(Flights{Flight_ID,1}.id)
serials = regexp((Flights{Flight_ID,1}.measurements{m}),'],[','split');
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
                               
            end
            % Sort sensors based on Time here
            SensorsIDs=sortrows(SensorsIDs,3,'ascend');
            if length(SensorsIDs(:,1)) < 20
                numRowesToAdd=20-length(SensorsIDs(:,1));
                SensorsIDs_temp=[SensorsIDs(:,1)',zeros(1,numRowesToAdd)];
            end
            sensors_seq_ord(end+1,:)=SensorsIDs_temp;
end 

unique_sens=[unique(sensors_seq_ord(:,1));unique(sensors_seq_ord(:,2));unique(sensors_seq_ord(:,3))];
unique_sens=unique(unique_sens); 
%sen_numbers_uni(end+1,:)=[fly,length(unique_sens)];
%end