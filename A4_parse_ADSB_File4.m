% Parse ADS-B data to get all ADS-B data that we want

function [ ADSB ] = parse_ADSB_4( day )
%PARSE ADSB File
% Open File
file = fopen(strcat('path',num2str(day),'.txt'),'r');
% Search for Start

line = fgetl(file);
while isempty(line) || line(1) ~= '+'
    line = fgetl(file);
end

%%%%%%%%%%%%%%%%%%%%%%%
%%%%% IMPORT DATA %%%%%
%%%%%%%%%%%%%%%%%%%%%%%


time = [];              %  (1) time | int | unix (aka POSIX or epoch) timestamp
icao24 = [];            %  (2) icao24 | string | 24-bit ICAO transponder ID
lat = [];               %  (3) lat | double | last known latitude
lon = [];               %  (4) lon | double | last known longitude
% velocity = [];          %  (5) velocity | double | speed over ground [m/s]
% heading = [];           %  (6) heading | double | direction of movement (track angle) as the clockwise angle from the geographic north
% vertrate = [];          %  (7) vertrate | double | vertical speed [m/s]
% callsign = string([]);  %  (8) callsign | string | callsign that was broadcast by the aircraft
% onground = logical([]); %  (9) onground | boolean | surface positions (true) or airborne positions (false)
% alert = logical([]);    % (10) alert | boolean | special indicator
% spi = logical([]);      % (11) spi | boolean | special indicator
% squawk = string([]);    % (12) squawk | string | transponder code which is used by ATC and pilots for identification
baroaltitude = [];      % (13) baroaltitude | double | altitude measured by the barometer
geoaltitude = [];       % (14) geoaltitude | double | altitude determined using the GNSS (GPS) sensor
%lastposupdate = [];     % (15) lastposupdate | double | age of the position
%lastcontact = [];       % (16) lastcontact | double | time at which OpenSky received the last signal of the aircraft
serials = string([]);  % (17) serials | array<int> | list of sensors that received the message
%hour = [];              % (18) hour | int | partition key for Impala
msgID= [];              %  (0) time | int 
% Read File


for i=1:height(file)
    Read Data
    data = textscan(file,'| %f %6s %f %f %f %f %f %*s %1c %s %1c %4s %f %f %f %f %f %f', ...
        'Delimiter','|','TreatAsEmpty','NULL','CommentStyle','+','HeaderLines',2);
    data = textscan(file,'| %f %6s %f %f %f %f %s %f', ...
       'Delimiter','|','TreatAsEmpty','NULL','CommentStyle','+','HeaderLines',2);
    
    % Store Data
    time= file(1:end,2);
    icao24= file(1:end,3);
    lat= file(1:end,4);
    lon= file(1:end,5);
    %velocity(end+1:end+length(data{5}),:) = data{5};
    %heading(end+1:end+length(data{6}),:) = data{6};
    %vertrate(end+1:end+length(data{7}),:) = data{7};
    %callsign(end+1:end+length(data{8}),:) = string(data{8});
    %onground(end+1:end+length(data{9}),:) = logical(data{9} == 't');
    %alert(end+1:end+length(data{10}),:) = logical(data{10} == 't');
    %spi(end+1:end+length(data{11}),:) = logical(data{11} == 't');
    %squawk(end+1:end+length(data{12}),:) = string(data{12});
    baroaltitude= file(1:end,6);
    geoaltitude= file(1:end,7);
    %lastposupdate(end+1:end+length(data{14}),:) = data{14};
    %lastcontact(end+1:end+length(data{15}),:) = data{15};
    serials= file(1:end,9);
    %hour(end+1:end+length(data{16}),:)=file{16};
    msgID= file(1:end,1);
%end

% Close File
%fclose(file);

% Create Struct
ADSB = struct('time', time, ...
    'icao24', icao24, ...
    'lat', lat, ...
    'lon', lon, ...    
    'baroaltitude',baroaltitude,...
    'geoaltitude',geoaltitude,...    
    'serials',serials,... %'hour',hour,...    
    'msgID',msgID);
end