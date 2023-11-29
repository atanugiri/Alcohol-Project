% Author: Atanu Giri
% Date: 11/19/2022
% This function generates plots of trajectory when id is provided. The plot
% is normalized for uniform representation of all trials.

%% This function call coordinateNormalization and mazeMethods functions.

function h = trajectoryPlot(id)
% id = 265942;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, mazenumber, feeder, trialcontrolsettings, coordinatetimes2, " + ...
    "xcoordinates2, ycoordinates2 FROM live_table WHERE id = %d;", id);
subject_data = fetch(conn,query);

% convert all table entries from string to usable format
subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
if isnan(subject_data.playstarttrialtone)
        subject_data.playstarttrialtone = 2;
end
subject_data.feeder = str2double(subject_data.feeder);
subject_data.trialcontrolsettings = string(subject_data.trialcontrolsettings);

if contains(subject_data.trialcontrolsettings, "Diagonal","IgnoreCase",true)
    feeder = 1;
elseif contains(subject_data.trialcontrolsettings, "Grid","IgnoreCase",true)
    feeder = 2;
elseif contains(subject_data.trialcontrolsettings, "Horizontal","IgnoreCase",true)
    feeder = 3;
elseif contains(subject_data.trialcontrolsettings, "Radial","IgnoreCase",true)
    feeder = 4;
else
    feeder = subject_data.feeder;
end
% remove space from mazenumber
subject_data.mazenumber = char(lower(strrep(subject_data.mazenumber,' ','')));

% Accessing PGArray data as double
for column = size(subject_data,2) - 2:size(subject_data,2)
    stringAllRows = string(subject_data.(column));
    regAllRows = regexprep(stringAllRows,'{|}','');
    splitAllRows = split(regAllRows,',');
    doubleData = str2double(splitAllRows);
    subject_data.(column){1} = doubleData;
end

% includes the data before playstarttrialtone
rawData = table(subject_data.coordinatetimes2{1}, subject_data.xcoordinates2{1}, ...
    subject_data.ycoordinates2{1}, 'VariableNames',{'t','X','Y'});

% remove nan entries
validIdx = all(isfinite(rawData{:,:}),2);
cleanedData = rawData(validIdx,:);

% invoke coordinateNormalization function to normalize the coordinates
maze = {'maze2','maze1','maze3','maze4'};
mazeIndex = find(ismember(maze,subject_data.mazenumber));

% if ismember(mazeIndex, [1, 3, 4])
[normX, normY] = coordinateNormalization_hard_coded(cleanedData.X, ...
    cleanedData.Y, mazeIndex);
% else
%     [normX, normY] = coordinateNormalization(cleanedData.X, cleanedData.Y, id);
% end
cleanedDataWithTone = table(cleanedData.t, normX, normY, 'VariableNames',{'t','X','Y'});

%% Data for plotting after playstarttrialtone
startingCoordinatetimes = subject_data.playstarttrialtone;
toneFilter = cleanedDataWithTone.t >= startingCoordinatetimes;
xNormalized = cleanedDataWithTone.X(toneFilter);
yNormalized = cleanedDataWithTone.Y(toneFilter);

%% Data for plotting during present cost (pc) range
pcFilter = cleanedDataWithTone.t >= 2 & cleanedDataWithTone.t <= 15;
xPCrange = cleanedDataWithTone.X(pcFilter); % pc = present cost
yPCrange = cleanedDataWithTone.Y(pcFilter);

% plot normalized data
h = figure;
% subplot(1,2,1);
% plot(cleanedData.X(toneFilter), cleanedData.Y(toneFilter), 'LineWidth',1.5);
% title("Raw trajectory plot");
%
% subplot(1,2,2);
p1 = plot(xPCrange,yPCrange,'k','MarkerSize',10,'LineWidth',2);
hold on;
mrkr1 = plot(xPCrange(1),yPCrange(1),'g.','MarkerSize',30);
mrkr2 = plot(xPCrange(end),yPCrange(end),'r.','MarkerSize',30);
plot(xNormalized,yNormalized,'b','MarkerSize',10,'LineWidth',1);

% set figure limit
figureLimit = {{[-0.2 1.2],[-0.2 1.2]},{[-1.2 0.2],[-0.2 1.2]}, ...
    {[-1.2 0.2],[-1.2 0.2]},{[-0.2 1.2],[-1.2 0.2]}};
% get the index in maze array
xlim(figureLimit{mazeIndex}{1}); ylim(figureLimit{mazeIndex}{2});

% shade feeder zones by calling mazeMethods
mazeMethods(mazeIndex,0.20,0.4,feeder); % Check parameters

% patch objects
grayPatch = patch(nan,nan,'k');grayPatch.FaceColor = [0.3 0.3 0.3];
grayPatch.FaceAlpha = 0.3;grayPatch.EdgeColor = "none";

yellowPatch = patch(nan,nan,'k');yellowPatch.FaceColor = [1 1 0];
yellowPatch.FaceAlpha = 0.3;yellowPatch.EdgeColor = "none";

redPatch = patch(nan,nan,'k');redPatch.FaceColor = [1 0 0];
redPatch.FaceAlpha = 0.2;redPatch.EdgeColor = "none";

% Add legend and labels
legend([p1,mrkr1,mrkr2,grayPatch,yellowPatch,redPatch], ...
    {'trajectory','initial location','final location', ...
    'feeders','offer','central zone'},'Location','best','Interpreter','latex');

xlabel('x(Normalized)',Interpreter='latex',FontSize=14);
ylabel('y(Normalized)',Interpreter='latex',FontSize=14);

% title of graph
sgtitle(sprintf('trajectory id:%d',id));
% fig_name = sprintf('trajectory id_%d',id);
% print(h,fig_name,'-dpng','-r400');
% savefig(h,sprintf('%s.fig',fig_name));
end