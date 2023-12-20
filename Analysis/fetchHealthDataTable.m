% Author: Atanu Giri
% Date: 11/14/2023

function mergedTable = fetchHealthDataTable(feature, idList)
%
% This function takes the dates as user input and returns a table of all 
% id's and corresponding columns from live_table and featuretable
%
% feature = 'entry_time_20';

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

liveTableQuery = sprintf("SELECT id, subjectid, referencetime, gender, feeder, " + ...
    "health, trialcontrolsettings, tasktypedone, approachavoid FROM live_table " + ...
    "WHERE id IN (%s) ORDER BY id;", idList);
liveTableData = fetch(conn, liveTableQuery);

if ~strcmpi(feature,'approachavoid')
    featureQuery = sprintf("SELECT id, distance_until_limiting_time_stamp, %s FROM ghrelin_featuretable ORDER BY id;", feature);
    featureData = fetch(conn, featureQuery);
end

if strcmpi(feature,'approachavoid')
    mergedTable = liveTableData;
else
    mergedTable = innerjoin(liveTableData,featureData,'Keys','id');
end

mergedTable.referencetime = datetime(mergedTable.referencetime, 'Format', 'MM/dd/yyyy');
mergedTable.referencetime = string(mergedTable.referencetime);
mergedTable.subjectid = string(mergedTable.subjectid);
mergedTable.gender = string(mergedTable.gender);
mergedTable.feeder = str2double(mergedTable.feeder);
mergedTable.health = string(mergedTable.health);
mergedTable.trialcontrolsettings = string(mergedTable.trialcontrolsettings);
mergedTable.tasktypedone = string(mergedTable.tasktypedone);
mergedTable.(feature) = str2double(mergedTable.(feature));
mergedTable.distance_until_limiting_time_stamp = str2double(mergedTable.distance_until_limiting_time_stamp);

mergedTable.realFeederId = nan(height(mergedTable),1);

for i = 1:height(mergedTable)
    if contains(mergedTable.trialcontrolsettings(i), "Diagonal","IgnoreCase",true)
        mergedTable.realFeederId(i) = 1;
    elseif contains(mergedTable.trialcontrolsettings(i), "Grid","IgnoreCase",true)
        mergedTable.realFeederId(i) = 2;
    elseif contains(mergedTable.trialcontrolsettings(i), "Horizontal","IgnoreCase",true)
        mergedTable.realFeederId(i) = 3;
    elseif contains(mergedTable.trialcontrolsettings(i), "Radial","IgnoreCase",true)
        mergedTable.realFeederId(i) = 4;
    else
        mergedTable.realFeederId(i) = mergedTable.feeder(i);
    end
end

close(conn);
end