function p_downsample = downsampling_kstest2(array1, array2, numDownsamples)

% Set random seed for reproducibility
rng(0);

n = length(array2);
downsample_p_values = zeros(numDownsamples, 1);

for i = 1:numDownsamples
    % Randomly select a subset of control group
    downsampled_control = datasample(array1, n);
    
    % Perform KS test on the downsampled data
    [~, p_value] = kstest2(downsampled_control, array2);
    
    % Store the p-value
    downsample_p_values(i) = p_value;
end

% Calculate the mean p-value from the downsampling
p_downsample = mean(downsample_p_values);