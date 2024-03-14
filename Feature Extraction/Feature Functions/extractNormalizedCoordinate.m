% Author: Atanu Giri
% Date: 12/07/2023

%% Invokes coordinateNormalization

function [normT, normX, normY] = extractNormalizedCoordinate(id, varargin)

% id = 10988;

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
    conn =  varargin{1};
end

% write query
query = sprintf("SELECT id, coordinatetimes2, xcoordinates2, " + ...
    "ycoordinates2 FROM live_table WHERE id = %d", id);
subject_data = fetch(conn,query);
% close(conn);

try
    % Accessing PGArray data as double
    for column = size(subject_data,2) - 2:size(subject_data,2)
        % vectorization approach
        strData = cellfun(@(x) string(x), subject_data.(column));
        regData = arrayfun(@(x) regexprep(x,'{|}',''), strData);
        splitData = arrayfun(@(x) split(x, ','), regData, 'UniformOutput', false);
        subject_data.(column) = cellfun(@(x) str2double(x), splitData, 'UniformOutput', false);
    end

    rawData = table(subject_data.coordinatetimes2{1}, subject_data.xcoordinates2{1}, ...
        subject_data.ycoordinates2{1}, 'VariableNames',{'t','X','Y'});

    % remove bad entries
    validIdx = all(isfinite(rawData{:,:}),2);
    cleanedData = rawData(validIdx,:);
    normT = cleanedData.t;

    % invoke coordinateNormalization function to normalize the coordinates
    [normX, normY] = coordinateNormalization(cleanedData.X, cleanedData.Y, id, conn);
catch
    sprintf("An error occured for id = %d\n", id);
end

end