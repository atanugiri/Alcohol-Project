% Author: Atanu Giri
% Date: 11/14/2023

function mergedTable = fetchGhrelinData(feature)
%
% This function fetches saline and ghrelin toyrat data and returns
% processed table.
%
% feature = 'logical_approach';

datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('09/12/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('10/31/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);

idList = strjoin(arrayfun(@num2str, dataInRange.id, 'UniformOutput', false), ',');

liveTableQuery = sprintf("SELECT id, subjectid, referencetime, gender, feeder, " + ...
    "trialcontrolsettings, tasktypedone, approachavoid FROM live_table " + ...
    "WHERE id IN (%s) ORDER BY id;", idList);
liveTableData = fetch(conn, liveTableQuery);

if ~strcmpi(feature,'approachavoid')
    featureQuery = sprintf("SELECT id, %s FROM ghrelin_featuretable ORDER BY id;", feature);
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
mergedTable.trialcontrolsettings = string(mergedTable.trialcontrolsettings);
mergedTable.tasktypedone = string(mergedTable.tasktypedone);
mergedTable.(feature) = str2double(mergedTable.(feature));

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
        mergedTable.realFeederId(i) = mergedTable.feeder;
    end
end

close(conn);
end