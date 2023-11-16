function featureForEachSubjectId = masterPsychometricFunctionPlot(feature)
%
% This function takes 'feature' as input from 'ghrelin_featuretable' and
% returns psychometric plot for that feature as an average of all animals
% at 4 different concentration.
%

feature = 'approachavoid';
mergedTable = fetchGhrelinData(feature);

ghrToyratData = mergedTable(mergedTable.tasktypedone == 'ghr toyrat', :);
salToyratData = mergedTable(mergedTable.tasktypedone == 'sal toyrat', :);
ghrToystickData = mergedTable(mergedTable.tasktypedone == 'ghr toystick', :);
salToystickData = mergedTable(mergedTable.tasktypedone == 'sal toystick', :);

[~, avFeatureGhrTR, stdErrGhrTR] = psychometricFunValues(ghrToyratData);
[~, avFeatureSalTR, stdErrSalTR] = psychometricFunValues(salToyratData);
[~, avFeatureGhrTS, stdErrGhrTS] = psychometricFunValues(ghrToystickData);
[~, avFeatureSalTS, stdErrSalTS] = psychometricFunValues(salToystickData);

% Plot data
yData = [avFeatureGhrTR; avFeatureSalTR; avFeatureGhrTS; avFeatureSalTS];
stdErr = [stdErrGhrTR; stdErrSalTR; stdErrGhrTS; stdErrSalTS];
x = 1:4;
xData = repmat(x, size(yData, 1), 1);
figure;
plot(xData', yData', 'LineWidth', 2);
hold on;
errorbar(xData', yData', stdErr', 'LineStyle', 'none', 'LineWidth', 1.5, ...
    'CapSize', 0);
legend({'ghr toyrat', 'sal toyrat', 'ghr toystick', 'sal toystick'});
label = [0.5 "" 2 "" 5 "" 9];
set(gca,'xticklabel',label,'TickLabelInterpreter','latex');
xlabel("sucrose concentration","Interpreter","latex",'FontSize',15);
ylabel(string(feature), "Interpreter","latex",'FontSize',15);


%% Description of psychometricFunValues
    function [featureForEach, avFeature, stdErr] = psychometricFunValues(dataTable)
        uniqueSubjectid = unique(dataTable.subjectid);
        featureForEach = zeros(length(uniqueSubjectid), 4);
        stdErr = zeros(1,4);

        for subject = 1:length(uniqueSubjectid)
            for conc = 1:4
                feederToFetch = 5 - conc;
                dataFilter = dataTable.subjectid == uniqueSubjectid(subject) & dataTable.feeder == feederToFetch;
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
end % end of masterPsychometricFunctionPlot