%% Description of barPlotValues
function [featureForEach, avFeature, stdErr] = barPlotValues(dataTable, feature)
% dataTable = femaleData; % for testing
uniqueSubjectid = unique(dataTable.subjectid);
featureForEach = zeros(length(uniqueSubjectid),1);

for subject = 1:length(uniqueSubjectid)
    featureArray = dataTable.(feature)(dataTable.subjectid == uniqueSubjectid(subject), :);
    featureArray = featureArray(isfinite(featureArray));
    featureForEach(subject) = sum(featureArray)/length(featureArray);
end

avFeature = mean(featureForEach);
stdErr = std(featureForEach)/sqrt(length(featureForEach));
end