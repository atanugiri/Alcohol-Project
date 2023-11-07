clear; clc;
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('06/16/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('06/23/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);

idList = strjoin(arrayfun(@num2str, dataInRange.id, 'UniformOutput', false), ',');
query = sprintf("SELECT id, subjectid, referencetime, gender, feeder, " + ...
    "approachavoid, tasktypedone, notes, health " + ...
    "FROM live_table WHERE id IN (%s) ORDER BY id;", idList);
data = fetch(conn, query);

data.referencetime = datetime(data.referencetime, 'Format', 'MM/dd/yyyy');

data.subjectid = string(data.subjectid);
data.approachavoid = str2double(data.approachavoid);
data.tasktypedone = string(data.tasktypedone);
data.notes = string(data.notes);
data.gender = string(data.gender);
data.feeder = str2double(data.feeder);
data.health = string(data.health);

BLdata = data(data.health == 'N/A', :);
[featureForEachGhrTR, avFeatureGhrTR, stdErrGhrTR] = psychometricFunValues(BLdata);
figure;
plot(1:4, avFeatureGhrTR, 'LineWidth', 2);
set(gcf, 'Windowstyle', 'docked');
hold on;
errorbar(1:4, avFeatureGhrTR, stdErrGhrTR);
ylim([0 1]);


%% Description of psychometricFunValues
function [featureForEach, avFeature, stdErr] = psychometricFunValues(dataTable)
uniqueSubjectid = unique(dataTable.subjectid);
featureForEach = zeros(length(uniqueSubjectid), 4);
stdErr = zeros(1,4);

for subject = 1:length(uniqueSubjectid)
    for conc = 1:4
        feederToFetch = 5 - conc;
        dataFilter = dataTable.subjectid == uniqueSubjectid(subject) & dataTable.feeder == feederToFetch;
        feature = dataTable.approachavoid(dataFilter, :);
        feature = feature(isfinite(feature));
        featureForEach(subject, conc) = sum(feature)/length(feature);
    end
end

avFeature = mean(featureForEach);

for conc = 1:4
    stdErr(conc) = std(featureForEach(:,conc))/sqrt(length(featureForEach(:,conc)));
end

end