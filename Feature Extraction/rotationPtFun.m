% Author: Atanu Giri
% Date: 12/26/2023
% This function returns the total total number of rotation pts in trajectory

function rotationPts = rotationPtFun(id)
% id = 206523;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, playstarttrialtone, coordinatetimes2, " + ...
    "truedirection FROM live_table WHERE id = %d;", id); %id
subject_data = fetch(conn,query);

% convert char to double in playstarttrialtone column
subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
% Accessing PGArray data as double
for column = 3:4
    stringAllRows = string(subject_data.(column));
    regAllRows = regexprep(stringAllRows,'{|}','');
    splitAllRows = split(regAllRows,',');
    doubleData = str2double(splitAllRows);
    subject_data.(column){1} = doubleData;
end

% includes the data before playstarttrialtone
badDataWithTone = table(subject_data.coordinatetimes2{1}, ...
    subject_data.truedirection{1},'VariableNames',{'t','direction'});
cleanedDataWithTone = badDataWithTone;

idx = all(isfinite(cleanedDataWithTone{:,:}),2);
cleanedDataWithTone = cleanedDataWithTone(idx,:);

startingCoordinatetimes = cleanedDataWithTone.t(1);

mask = cleanedDataWithTone.t > startingCoordinatetimes & cleanedDataWithTone.t <= 15;
direction = cleanedDataWithTone.direction(mask);

% Apply sliding window to find stopping points
% User-adjustable parameters
windowSize = 15; % Window to scan the array with.
directionChange = 180;

% Scan array looking for clustered points all within the defined box width.
bulbIndexes = false(numel(direction), 1);
for k = 2 : numel(direction) - windowSize
    % See if all x and y points in the window are within the box.
    DirectionWindow = direction(k : k + windowSize - 1);
    if range(DirectionWindow) > directionChange
        bulbIndexes(k : k + windowSize - 1) = true;
    end
end

[labeledBulb, rotationPts] = bwlabel(bulbIndexes);
% 
% 
% %% Plot rotation points
% rotationIndex = ones(max(labeledBulb),1);
% for kk = 1:max(labeledBulb)
%     rotationIndex(kk) = find(labeledBulb == kk, 1);
% end
% h = figure;
% time = cleanedDataWithTone.t(mask);
% quiver(time,zeros(size(time)),cosd(direction),sind(direction), ...
%     'LineWidth',1.5,'MaxHeadSize',0.5,'AutoScale','on');
% hold on;
% plot(time(rotationIndex),zeros(length(rotationIndex),1),'r.','MarkerSize',20);
% quiver(time(rotationIndex), zeros(size(time(rotationIndex))), ...
%     cosd(direction(rotationIndex)), sind(direction(rotationIndex)), ...
%     'Color','r','LineWidth',1.5);
% xlabel('Time','Interpreter','latex',FontSize=14);
% ylabel('Magnitude','Interpreter','latex',FontSize=14);
% %     xlim([-2 22]); ylim([-5 5]);
% title('Rotation Points in Female',Interpreter='latex');
% figName = sprintf('rotation_points_%d',id);
%     savefig(h,sprintf('%s.fig',figName));
%     print(h,figName,'-dpng','-r400');

end