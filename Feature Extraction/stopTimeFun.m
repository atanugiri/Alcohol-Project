% Author: Atanu Giri
% Date: 12/25/2023

function stoppingPts = stopTimeFun(id)
% This function returns the total stoptime in trajectory

% id = 265215;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, distance_until_limiting_time_stamp, norm_t, norm_x, norm_y " + ...
    "FROM ghrelin_featuretable WHERE id = %d", id);
subject_data = fetch(conn,query);

try
    subject_data.distance_until_limiting_time_stamp = str2double(subject_data.distance_until_limiting_time_stamp);
    % Accessing PGArray data as double
    for column = size(subject_data,2) - 2:size(subject_data,2)
        stringAllRows = string(subject_data.(column));
        regAllRows = regexprep(stringAllRows,'{|}','');
        splitAllRows = split(regAllRows,',');
        doubleData = str2double(splitAllRows);
        subject_data.(column){1} = doubleData;
    end

    X = subject_data.norm_x{1};
    Y = subject_data.norm_y{1};
    t = subject_data.norm_t{1};

    limitingTimeIndex = find(t <= 15);
    X = X(1:length(limitingTimeIndex));
    Y = Y(1:length(limitingTimeIndex));
    t = t(1:length(limitingTimeIndex));

    % Apply sliding window to find stopping points
    windowSize = 30;
    xBoxWidth = 0.1;
    yBoxWidth = 0.1;
    stoppingPts = [];

    bulbIndexes = false(numel(X), 1);
    for k = 2 : numel(X) - windowSize
        % See if all x and y points in the window are within the box.
        xWindow = X(k : k + windowSize - 1);
        yWindow = Y(k : k + windowSize - 1);
        if range(xWindow) < xBoxWidth && range(yWindow) < yBoxWidth
            bulbIndexes(k : k + windowSize - 1) = true;
        end
    end

    stoppingPts = sum(bulbIndexes);

    catch
    sprintf("An error occured for id = %d\n", id);
end
end