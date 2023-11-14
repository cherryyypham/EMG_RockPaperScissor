function res = runMatlabModel(data)
    % runMatlabModel - Process live data using a pre-trained classifier
    %   res = runMatlabModel(data) takes in live data and uses a
    %   pre-trained classifier (loaded from 'classifier.mat') to predict
    %   the class of the input data.
    %
    %   Input:
    %   - data: Input data matrix with multiple channels (columns).
    %
    %   Output:
    %   - res: Predicted class label for the input data.

    % Load the pre-trained classifier from the 'classifier.mat' file
    load('./helpers/matFiles/classifier.mat');

    % Filter the data using a highpass filter 0-1000Hz
    numCh = 4; % Number of channels
    filt_data = zeros(size(data, 1), numCh);
    for ch = 1:numCh
        filt_data(:, ch) = highpass(data(:, 1 + ch), 5, 1000);
    end
    
    % Extract features from the filtered data
    includedFeatures = {'var', 'std', 'rms', 'mav'};
    % Sampling frequency for feature extraction is set to 1000 Hz
    feats = extractFeatures(filt_data, includedFeatures, 1000);

    % Get the predicted class for the input data using the pre-trained classifier
    res = currentClassifier.predict(feats);
end
