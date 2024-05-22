function [h_boot, p_boot] = bootstrap_kstest2(array1, array2, numBootstraps)
    % Initialize bootstrap results
    ks_stats = zeros(numBootstraps, 1);
    
    % Get the original KS statistic
    [~,~,ks_stat] = kstest2(array1, array2);
    
    combinedArray = [array1(:); array2(:)];
    n1 = numel(array1);
    n2 = numel(array2);
    
    % Perform bootstrapping
    for i = 1:numBootstraps
        % Resample with replacement
        resample1 = datasample(combinedArray, n1);
        resample2 = datasample(combinedArray, n2);
        
        % Compute KS statistic for resampled data
        [~,~,ks_stats(i)] = kstest2(resample1, resample2);
    end
    
    % Calculate p-value as the proportion of bootstrap KS statistics greater
    % than or equal to the original KS statistic
    p_boot = mean(ks_stats >= ks_stat);
    
    % Hypothesis test result: 0 means fail to reject null hypothesis, 1 means reject
    h_boot = p_boot < 0.05;
end