% Date: 11/01/2023
% Author: Atanu Giri

clear; clc;
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
rangeDates = allDates(allDates.referencetime >= "09/12/2023", :);
idList = strjoin(arrayfun(@num2str, rangeDates.id, 'UniformOutput', false), ',');
query = sprintf("SELECT id, subjectid, referencetime, gender, feeder, " + ...
    "approachavoid, tasktypedone, notes, " + ...
    "coordinatetimes2, xcoordinates2, ycoordinates2 FROM live_table WHERE id IN (%s);", idList);

data = fetch(conn, query);
data.referencetime = datetime(data.referencetime, 'Format', 'MM/dd/yyyy');
data.referencetime = string(data.referencetime);
data.subjectid = string(data.subjectid);
data.approachavoid = str2double(data.approachavoid);
data.tasktypedone = string(data.tasktypedone);
data.notes = string(data.notes);
data.gender = string(data.gender);

% for column = (size(data,2) - 2):size(data,2)
%     pgArrayCell = data.(column);
% 
%     % Initialize an empty cell array to store the converted double arrays
%     doubleArrays = cell(size(pgArrayCell));
% 
%     % Loop through each PgArray in the cell array
%     for i = 1:length(pgArrayCell)
%         pgArray = pgArrayCell{i};
%         doubleArray = str2double(split(regexprep(char(pgArray), '\{|\}', ''), ','));
%         doubleArrays{i} = doubleArray;
%     end
% 
%     data.(column) = doubleArrays;
% end

% Calculate approach rate for each subjectid at each session
uniqueSubjectid = unique(data.subjectid);
appRate = cell(1, length(uniqueSubjectid));
uniqueDatesPerSubjectid = cell(1, length(uniqueSubjectid));
healthLabelsPerSubjectid = cell(1, length(uniqueSubjectid));

for subject = 1:length(uniqueSubjectid)
    currentSubjectidData = data(data.subjectid == uniqueSubjectid(subject), :);
    
    uniqueDates = unique(currentSubjectidData.referencetime);
    appRate{subject} = zeros(1, length(uniqueDates));

    for dateIdx = 1:length(uniqueDates)
        currentDateData = currentSubjectidData(currentSubjectidData.referencetime == uniqueDates(dateIdx), :);
        appAvoidData = currentDateData.approachavoid(isfinite(currentDateData.approachavoid));
        appRate{subject}(dateIdx) = sum(appAvoidData)/length(appAvoidData);

        healthLabelsPerSubjectid{subject}(dateIdx) = currentSubjectidData.tasktypedone( ...
            find(currentSubjectidData.referencetime == uniqueDates(dateIdx),1));
    end

    uniqueDatesPerSubjectid{subject} = uniqueDates';
end

% for subject = 1:length(uniqueSubjectid)
%     healthLabelsPerSubjectid{subject} = [];
% 
%     for dateIdx = 1:length(uniqueDatesPerSubjectid{subject})
%         currentDate = uniqueDatesPerSubjectid{subject}{dateIdx};
%         healthLabelsPerSubjectid{subject}{dateIdx} = 
%     end
% end

% Bar plot for each subjectid
for idx = 1:numel(appRate)
    figure;
    set(gcf, 'Windowstyle', 'docked');
    bar(appRate{idx});
    ylim([0, 1]);
    title(sprintf(uniqueSubjectid(idx)), 'FontSize', 20, 'FontWeight', 'bold');
    set(gca,'xticklabel',healthLabelsPerSubjectid{idx},'TickLabelInterpreter','latex','XTickLabelRotation', 45);

end