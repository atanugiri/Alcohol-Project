% Author: Atanu Giri
% Date: 11/12/2023

% function featureBySessionBarPlot(feature)
%
% This function returns bar plot of a feature for each session as
% an avergare of all animal
%
feature = 'passing_center_40';

mergedTable = fetchGhrelinData(feature);
mergedTable(mergedTable.subjectid == "none",:) = [];

ghrToyratData = mergedTable(mergedTable.tasktypedone == 'ghr toyrat', :);
salToyratData = mergedTable(mergedTable.tasktypedone == 'sal toyrat', :);

numberOfsession = 5;
ghrSessionData = fetchSessionData(ghrToyratData, numberOfsession);
salSessionData = fetchSessionData(salToyratData, numberOfsession);

% Remove sessions where toy is not fastened
for session = 1:numberOfsession
    ghrSessionData{session}(ismember(ghrSessionData{session}.referencetime, ["09/12/2023", "09/13/2023"]),:) = [];
    salSessionData{session}(ismember(salSessionData{session}.referencetime, ["09/12/2023", "09/13/2023"]),:) = [];
end

% Minimum time required to be present in the center
time_filter = 0;

for session = 1:numberOfsession
    figure(session);

    if isequal(feature, 'passing_center_40')
        ghrSessionData{session} = featureWithTimeFilter(ghrSessionData{session});
        ghrFeatureArray = ghrSessionData{session}.(feature)(ghrSessionData{session}.time_in_center_40 >= time_filter, :);
    else
        ghrFeatureArray = ghrSessionData{session}.(feature);
    end

    avGhrFeature = sum(ghrFeatureArray)/length(ghrSessionData{session}.(feature));
    sdErrGhr = std(ghrSessionData{session}.(feature))/sqrt(length(ghrSessionData{session}.(feature)));

    if isequal(feature, 'passing_center_40')
        salSessionData{session} = featureWithTimeFilter(salSessionData{session});
        salFeatureArray = salSessionData{session}.(feature)(salSessionData{session}.time_in_center_40 >= time_filter, :);
    else

        salFeatureArray = salSessionData{session}.(feature);
    end

    avSalFeature = sum(salFeatureArray)/length(salSessionData{session}.(feature));
    sdErrSal = std(salSessionData{session}.(feature))/sqrt(length(salSessionData{session}.(feature)));

    bar(1:2, [avGhrFeature, avSalFeature]);
    hold on;
    errorbar(1:2, [avGhrFeature, avSalFeature], [sdErrGhr, sdErrSal], ...
        'LineStyle','none', 'LineWidth',2, 'Color','k');
    %     ylim([0, 1]);
    ylabel(sprintf('%s', feature), "FontSize", 20, 'Interpreter','latex');
    xticklabels({sprintf('Ghrelin%s',session), sprintf('Saline%s',session)});
    set(gcf, 'Windowstyle', 'docked');

    % Statistics
    [~, p] = ttest2(ghrSessionData{session}.(feature), salSessionData{session}.(feature));
    text(1.5, 0.5, string(p));
end


%% Description of fetchSessionData
function sessionData = fetchSessionData(healthData, numberOfsession)
% healthData = ghrToyratData; % for testing

sessionData = cell(1,numberOfsession);
animalList = unique(healthData.subjectid);

for animal = 1:length(animalList)
    try
        animalData = healthData(healthData.subjectid == animalList(animal), :);
        sessionList = unique(animalData.referencetime);
        for session = 1:numberOfsession
            sessionData{session} = [sessionData{session}; animalData(animalData.referencetime == sessionList(session), :)];
        end
    catch
        sprintf("No data found for animal %s \n", animalList(animal));
    end % end of try-catch

end % End of animal 1
end

%% Description of featureWithTimeFilter
function updatedTable = featureWithTimeFilter(sessionData)

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

idList = strjoin(arrayfun(@num2str, sessionData.id, 'UniformOutput', false), ',');
ticQuery = sprintf("SELECT id, time_in_center_40 FROM ghrelin_featuretable " + ...
    "WHERE id IN (%s) ORDER BY id;", idList);
ticData = fetch(conn,ticQuery);
ticData.time_in_center_40 = str2double(ticData.time_in_center_40);
updatedTable = innerjoin(sessionData, ticData);
end

% end