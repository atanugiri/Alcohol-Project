% Author: Atanu Giri
% Date: 02/11/2024

% function pcaAnalysis

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

[P2L1_sal_id, ~, ~, ~] = extract_sal_ghr_ids; % Use correct function to extract ids
[~, P2L1_ghr_id, ~, ~] = extract_sal_ghr_ids; % Use correct function to extract ids

P2L1_sal_data = extractTable(P2L1_sal_id, conn);
P2L1_ghr_data = extractTable(P2L1_ghr_id, conn);


% Perform PCA
[coeff_P2L1_sal,score_P2L1_sal,latent_P2L1_sal,tsquared_P2L1_sal,...
    explained_P2L1_sal,mu_P2L1_sal] = pca(P2L1_sal_data);
[coeff_P2L1_ghr,score_P2L1_ghr,latent_P2L1_ghr,tsquared_P2L1_ghr,...
    explained_P2L1_ghr,mu_P2L1_ghr] = pca(P2L1_ghr_data);

idx_P2L1_sal = kmeans(P2L1_sal_data, size(P2L1_sal_data, 2));
idx_P2L1_ghr = kmeans(P2L1_ghr_data, size(P2L1_ghr_data, 2));


pc1_P2L1_sal = score_P2L1_sal(:,1);
pc2_P2L1_sal = score_P2L1_sal(:,2);

pc1_P2L1_ghr = score_P2L1_ghr(:,1);
pc2_P2L1_ghr = score_P2L1_ghr(:,2);

figure;
subplot(1,2,1);
gscatter(pc1_P2L1_sal, pc2_P2L1_sal, idx_P2L1_sal);
hold on;
subplot(1,2,2);
gscatter(pc1_P2L1_ghr, pc2_P2L1_ghr, idx_P2L1_ghr);


%% Description of extract table
function idList_data = extractTable(idList, conn)
% idList = P2L1_sal_id; % For testing
idList = strjoin(arrayfun(@num2str, idList, 'UniformOutput', false), ',');
idList_query = sprintf("SELECT distance_until_limiting_time_stamp_old, " + ...
    "acc_outlier_move_median, stoppingpts_per_unittravel_method6, " + ...
    "rotationpts_per_unittravel_method4 FROM ghrelin_featuretable WHERE id IN " + ...
    "(%s) ORDER BY id", idList);
idList_data = fetch(conn, idList_query);

for col = 1:size(idList_data,2)
    idList_data.(col) = str2double(idList_data.(col));
    idList_data.(col) = (idList_data.(col) - mean(idList_data.(col),'omitnan'))/std(idList_data.(col),'omitnan');
end
% idList_data = arrayfun(@(x) str2double, idList_data, UniformOutput, 'false'); % Vectorized approach


% Preprocess the data to handle missing values
idList_data = fillmissing(table2array(idList_data),"linear");

end

%% Description of pca_1
function [coefforth, b, r] = pca_1(a)
[m, n]= size(a);
a_mean = mean(a);
a_std = std(a);
b = (a - repmat(a_mean,[m 1])) ./ repmat(a_std,[m 1]);
[V, D] = eig(cov(b));
coefforth = V;
r = b*V;
end
% end