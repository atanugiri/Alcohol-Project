% Author: Atanu Giri
% Date: 01/14/2025
%

function treatment_data = extractTreatmentData(feature, splitType, treatmentGroup)

datasource = 'live_database';
conn = database(datasource, 'postgres', '1234');

treatmentIDs = treatmentIDfun(treatmentGroup, conn);

% Generate the idList from the filtered data
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);
treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions

% Sort the data depending upon splitting criteria
if strcmpi(splitType, 'trial')
    % Sort by trialname
    treatment_data = sortrows(treatment_data, 'trialname');

elseif strcmpi(splitType, 'session')
    % Convert referencetime to datetime format
    treatment_data.referencetime = datetime(treatment_data.referencetime, ...
        'InputFormat', 'MM/dd/yyyy');
    % Sort the table by referencetime
    treatment_data = sortrows(treatment_data, 'referencetime');
    % Close the connection after use
else
    % Handle invalid splitType with an informative error message
    error('Invalid splitType: "%s". Valid options are "trial" or "session".', splitType);
end

close(conn);