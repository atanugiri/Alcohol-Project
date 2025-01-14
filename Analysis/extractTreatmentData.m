% Author: Atanu Giri
% Date: 01/14/2025
%

function treatment_data = extractTreatmentData(feature, splitType, varargin)

datasource = 'live_database';
treatmentGroups = varargin;
treatmentIDs = cell(1, numel(treatmentGroups));

parfor i = 1:numel(treatmentGroups)
    % Create a new database connection for each worker
    conn = database(datasource, 'postgres', '1234');
    treatmentIDs{i} = treatmentIDfun(treatmentGroups{i}, conn);
    % Close the connection after use
    close(conn);
end

% Generate the idList from the filtered data
treatmentIDs_str = cellfun(@(x) strjoin(arrayfun(@num2str, x, 'UniformOutput', ...
    false), ','), treatmentIDs, 'UniformOutput', false);
treatment_data = cell(1, numel(treatmentIDs_str));

parfor i = 1:numel(treatment_data)

    % Create a new database connection for each worker
    conn = database(datasource, 'postgres', '1234');

    treatment_data{i} = fetchHealthDataTable(feature, treatmentIDs_str{i}, conn);
    treatment_data{i} = cleanBadSessionsFromTable(treatment_data{i}, feature); % Remove bad sessions

    % Sort the data depending upon splitting criteria
    if strcmpi(splitType, 'trial')
        % Sort by trialname
        treatment_data{i} = sortrows(treatment_data{i}, 'trialname');

    elseif strcmpi(splitType, 'session')
        % Convert referencetime to datetime format
        treatment_data{i}.referencetime = datetime(treatment_data{i}.referencetime, ...
            'InputFormat', 'MM/dd/yyyy');
        % Sort the table by referencetime
        treatment_data{i} = sortrows(treatment_data{i}, 'referencetime');
        % Close the connection after use
    else
        % Handle invalid splitType with an informative error message
        error('Invalid splitType: "%s". Valid options are "trial" or "session".', splitType);
    end

    close(conn);
end
end