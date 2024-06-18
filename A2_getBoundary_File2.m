
%%%% Get the boundray for the sensors - BOUNDARY Function -


function [ boundary ] = getBoundary( Sensors )

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% UPDATE SENSOR COVERAGE %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Mkae this a function!
    for i = 1:length(Sensors)
        % Compute 2-D Boundaries (shrink factor = 1)
        Sensors(i).lat = reshape( Sensors(i).lat, [], 1 );
        Sensors(i).lon = reshape( Sensors(i).lon, [], 1 );
        ixnonan = find( not(isnan(Sensors(i).lat)|isnan(Sensors(i).lon)) );
        tmp = boundary([Sensors(i).lat(ixnonan), Sensors(i).lon(ixnonan)]);
        
        
        % Store Boundary
        Sensors(i).boundary = [Sensors(i).lat(tmp), Sensors(i).lon(tmp)];

        % Store convhull
        tmp = convhull([Sensors(i).lat(ixnonan), Sensors(i).lon(ixnonan)],1);
        Sensors(i).boundary_convhull = [Sensors(i).lat(tmp), Sensors(i).lon(tmp)];
    end

end