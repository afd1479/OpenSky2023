%%% Get the trajectories of ADS-B data after organizng them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PROCESS 1 DAY %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for hour = day:3600:day+0*3600 %24*3600 %%% This line just if we want onw hour
%for hour = day:3600:day+0*3600 %24*3600  % If we want to work only by hours    
% Time and Day Here I have csv file with numbers from 1 to 7. 
day = 1; 
%hour = 1486944000;

%%%%%%%%%%%%%%%%%%%%%%%
%%%% Get Flights %%%%%%

clear Flights datatable;
%%%%%%%%%%%%%%%%%%%
%%% FLIGHT LIST %%%
%%%%%%%%%%%%%%%%%%%
   
 % Parse 1 hour of ADSB Data
 ADSB = parse_ADSB_4(day);   

datatable=struct2table(ADSB);

groupFlights=findgroups(datatable.icao24);

Flights=cell(max(groupFlights),1);

for i=1:max(groupFlights)
    Flights{i,1}=table2array(datatable(groupFlights == i,:));
end


