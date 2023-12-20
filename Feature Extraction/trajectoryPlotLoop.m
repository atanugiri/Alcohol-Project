% Author: Atanu Giri
% Date: 11/20/2023

datasource = 'live_database';
conn = database(datasource, 'postgres', '1234');
subjectDataQ = "SELECT id, subjectid, referencetime, trialname FROM live_table WHERE " + ...
    "referencetime LIKE '%09/25/2023%' AND subjectid = 'teddy' ORDER BY id";
subjectData = fetch(conn, subjectDataQ);

for index = 1:height(subjectData)
    try
        % Create a new figure for every 8 subplots
        if mod(index - 1, 8) == 0
            % Create a new figure
            mainFigure = figure;
            set(mainFigure, 'WindowStyle', 'docked');
            
            % Reset the subplot index
            subplotIndex = 1;
        end

        % Create a 2x4 subplot grid
        s = subplot(2, 4, subplotIndex);
        id = subjectData.id(index);
        title(sprintf("id: %d, %s",id, string(subjectData.trialname(index))));
        
        h = trajectoryPlot(id);
        ax = h.CurrentAxes;
        currentFig = get(ax,'Children');
        copyobj(currentFig,s);

        % Close the trajectoryPlot figure
        close(h);

        % Increment the subplot index
        subplotIndex = subplotIndex + 1;

    catch
        fprintf('Error in plotting for index %d\n', index);
    end
end

close(conn);
