function res = runMatlabModel(data)
    numCh = 4;
   
    % Load the pre-trained classifier from the 'classifier.mat' file
    load('classifier.mat');

    % Get the predicted class for the input data
    filt_data = zeros(size(data,1),numCh);

    % Filter the data
    for ch = 1:numCh
        filt_data(:,ch) = highpass((:,1+ch), 0 ,1000);
    end
    
    includedFeatures = {'var','std', 'rms', 'mav'};
    feats = extractFeatures(filt_data,includedFeatures,1000);

    % Get the predicted class for the input data
    res = currentClassifier.predict(feats);
end
