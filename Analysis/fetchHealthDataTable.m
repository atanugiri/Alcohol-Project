% Author: Atanu Giri
% Date: 11/14/2023

function mergedTable = fetchHealthDataTable(feature, idList, varargin)
%
% This function takes the dates as user input and returns a table of all 
% id's and corresponding columns from live_table and featuretable
%
% feature = 'approachavoid';

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
   conn =  varargin{1};
end

liveTableQuery = sprintf("SELECT id, subjectid, referencetime, gender, feeder, " + ...
    "health, trialcontrolsettings, tasktypedone, approachavoid FROM live_table " + ...
    "WHERE id IN (%s) ORDER BY id;", idList);
liveTableData = fetch(conn, liveTableQuery);

if ~strcmpi(feature,'approachavoid')
    featureQuery = sprintf("SELECT id, distance_until_limiting_time_stamp_old, %s " + ...
        "FROM ghrelin_featuretable WHERE id IN (%s) ORDER BY id", feature, idList);
    featureData = fetch(conn, featureQuery);
end

if strcmpi(feature,'approachavoid')
    mergedTable = liveTableData;
else
    mergedTable = innerjoin(liveTableData,featureData,'Keys','id');
end

mergedTable.referencetime = datetime(mergedTable.referencetime, 'Format', 'MM/dd/yyyy');
mergedTable = sortrows(mergedTable, 'referencetime');
mergedTable.referencetime = string(mergedTable.referencetime);
mergedTable.subjectid = string(mergedTable.subjectid);
mergedTable.gender = string(mergedTable.gender);
mergedTable.feeder = str2double(mergedTable.feeder);
mergedTable.health = string(mergedTable.health);
mergedTable.trialcontrolsettings = string(mergedTable.trialcontrolsettings);
mergedTable.tasktypedone = string(mergedTable.tasktypedone);
if ~strcmpi(feature,'approachavoid')
    mergedTable.distance_until_limiting_time_stamp_old = str2double(mergedTable.distance_until_limiting_time_stamp_old);
end
if ~strcmpi(feature, 'distance_until_limiting_time_stamp_old')
    mergedTable.(feature) = str2double(mergedTable.(feature));
end
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

end