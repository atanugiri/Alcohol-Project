% Author: Atanu Giri
% date: 12/31/2023

function reactionTime = reactionTimeFun(id)
%
% This algorithm calculates the reaction time by movemedian method.
%

% id = 265215;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, norm_t, norm_x, norm_y " + ...
    "FROM ghrelin_featuretable WHERE id = %d", id);
subject_data = fetch(conn,query);

liveTableQuery = sprintf("SELECT id, playstarttrialtone " + ...
    "FROM live_table WHERE id = %d", id);
liveTableData = fetch(conn, liveTableQuery);

subject_data = innerjoin(liveTableData, subject_data, 'Keys', 'id');

try
    subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
    if isnan(subject_data.playstarttrialtone)
        subject_data.playstarttrialtone = 2;
    end

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

    startingCoordinatetimes = subject_data.playstarttrialtone;
    limitingTimeIndex = 20;
    X = X(t >= startingCoordinatetimes & t <= limitingTimeIndex);
    Y = Y(t >= startingCoordinatetimes & t <= limitingTimeIndex);
    t = t(t >= startingCoordinatetimes & t <= limitingTimeIndex);

    % Calculate velocity
    Vx = diff(X) ./ diff(t); % velocity in the X direction
    Vy = diff(Y) ./ diff(t); % velocity in the Y direction

    % Append a zero at the beginning to make the size of V match the size of t
    Vx = [0; Vx];
    Vy = [0; Vy];

    % Calculate acceleration
    Ax = diff(Vx) ./ diff(t); % acceleration in the X direction
    Ay = diff(Vy) ./ diff(t); % acceleration in the Y direction

    % Append a zero at the beginning to make the size of A match the size of t
    Ax = [0; Ax];
    Ay = [0; Ay];

    % Total acceleration magnitude
    A = sqrt(Ax.^2 + Ay.^2);

    % Calculate acceleration outlier
    accOutlierFilter = isoutlier(A(2:end),"movmedian",5);

    index_of_first_one = find(accOutlierFilter, 1);
    reactionTime = t(index_of_first_one+1);

catch
    sprintf("An error occured for id = %d\n", id);
end

end