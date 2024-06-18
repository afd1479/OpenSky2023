%%% Get the Frechet Dist between the reported ones and estimated ones.
clear frechet_dist;
frechet_dist=struct('icao', [], ...
                    'number_of_messages_with',[], ...                           
                    'Dist_with_null',[], ...
                    'number_of_messages_without',[], ...
                    'Dist_without_null',[]);
for fly=1:length(Flights)
    Flights_ID=fly;
    number_of_messages=height(Flights{Flights_ID,1});
    if  number_of_messages >100
    tra1=[Flights{Flights_ID,1}.latitude(1:number_of_messages),Flights{Flights_ID,1}.longitude(1:number_of_messages)];
    tra2=[Computed_Flights_m2{Flights_ID,1}.latitude(1:number_of_messages),Computed_Flights_m2{Flights_ID,1}.longitude(1:number_of_messages)];
    
    if ~isnan(Flights{Flights_ID,1}.latitude) & ~isnan(Flights{Flights_ID,1}.longitude)
    frechet_dist_1=frechet(tra1(:,1),tra1(:,2),tra2(:,1),tra2(:,2));   

    x=[Flights{Flights_ID,1}.latitude];
    y=[Flights{Flights_ID,1}.longitude];

    x2=[Computed_Flights_m2{Flights_ID,1}.latitude];
    y2=[Computed_Flights_m2{Flights_ID,1}.longitude];

    valid_indices2 = x2(x2 ~= -1000) & y2(y2 ~= -1000);

    x_valid = x(valid_indices2);
    y_valid = y(valid_indices2);


    x2_valid = x2(valid_indices2);
    y2_valid = y2(valid_indices2);
    frechet_dist_2=frechet(x_valid,y_valid,x2_valid,y2_valid); 



                % Init 
                if isempty(frechet_dist(1).icao)
                    frechet_dist(end).icao = fly;
                    
                else
                    frechet_dist(end+1).icao = fly;
                    
                end
            
                % New Track

                frechet_dist(end+1).number_of_messages_with=number_of_messages;
                    frechet_dist(end+1).Dist_with_null=frechet_dist_1;
                    frechet_dist(end+1).number_of_messages_without=length(valid_indices2);
                  frechet_dist(end+1).Dist_without_null=frechet_dist_2;
    end 
    end        
                
end

% logicalindex=[Frechet_dist_work(:,1)];
% 
% temp=table2array(logicalindex);
% temp=temp(~cellfun('isempty',temp));
% logicalindex_2=[Frechet_dist_work(:,2)];
% temp2=table2array(logicalindex_2);
% temp2=temp2(~cellfun('isempty',temp2));

% logicalindex_3=[Frechet_dist_work(:,3)];
% temp3=table2array(logicalindex_3);
% temp3=temp3(~cellfun('isempty',temp3));
% temp4=[temp,temp2,temp3];
