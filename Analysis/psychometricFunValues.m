%% Description of psychometricFunValues
function [featureForEach, avFeature, stdErr] = psychometricFunValues(dataTable, feature)
uniqueSubjectid = unique(dataTable.subjectid);
featureForEach = zeros(length(uniqueSubjectid), 4);
stdErr = zeros(1,4);

for subject = 1:length(uniqueSubjectid)
    for conc = 1:4
        feederToFetch = 5 - conc;
        dataFilter = dataTable.subjectid == uniqueSubjectid(subject) ...
            & dataTable.realFeederId == feederToFetch;
        featureArray = dataTable.(feature)(dataFilter, :);
        featureArray = featureArray(isfinite(featureArray));
        featureForEach(subject, conc) = sum(featureArray)/length(featureArray);
    end
end

avFeature = mean(featureForEach);

for conc = 1:4
    stdErr(conc) = std(featureForEach(:,conc))/sqrt(length(featureForEach(:,conc)));
end

end % end of psychometricFunValues