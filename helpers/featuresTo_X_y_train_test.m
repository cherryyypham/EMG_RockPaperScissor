function [X_train, y_train, X_test, y_test] = featuresTo_X_y_train_test(filesToLoad, selected_features)
    % featuresTo_X_y_train_test - Load and partition data into training and testing sets
    %   [X_train, y_train, X_test, y_test] = featuresTo_X_y_train_test(filesToLoad, selected_features)
    %   loads data from specified files, partitions it into training and
    %   testing sets, and returns feature matrices and corresponding labels.
    %
    %   Input:
    %   - filesToLoad: Cell array containing file paths for training and testing data
    %   - selected_features: Indices of selected features for training and testing
    %
    %   Output:
    %   - X_train: Feature matrix for training data
    %   - y_train: Labels for training data
    %   - X_test: Feature matrix for testing data
    %   - y_test: Labels for testing data

    % Check if separate test data or a single file is provided
    if size(filesToLoad, 2) == 2
        isSeparateTestData = true;
    elseif size(filesToLoad, 2) == 1
        isSeparateTestData = false;
    else
        error("Wrong number of files to load.")
    end
    
    % Load the first file
    load(filesToLoad{1})

    % If separate test data
    if isSeparateTestData   
        % Put the train data into X and y  
        X_train = feature_table(:, selected_features);
        y_train = labels;
    
        % Load the test data
        load(filesToLoad{2});
    
        % Put the test data into X and y  
        X_test = feature_table(:, selected_features);
        y_test = labels;
    
    % If split the train/test data from one file
    else
        % If you want to partition your data into train and test
        holdout_proportion_test = 0.25;
        try 
            % Load a saved partition from last time
            load("lastCVpartition.mat")
            disp("loading prior training-test partition")
            if cvtt.NumObservations ~= length(labels) || cvtt.TestSize/cvtt.NumObservations ~= holdout_proportion_test
                warning('Loaded cv partition does not match number of observations, delete or rename and rerun, making a temporary new one')
                
                cvtt = cvpartition(labels, "HoldOut", holdout_proportion_test); % Decimal is how much to hold out for test
            end
        catch
            % Create a new partition if none exists
            cvtt = cvpartition(labels, "HoldOut", holdout_proportion_test); % Decimal is how much to hold out for test
            save("lastCVpartition.mat", "cvtt");
            disp('Making new training-test partiton')
        end
        
        % Train data
        X_train = feature_table(training(cvtt), selected_features);
        y_train = labels(training(cvtt));
    
        % Test data
        X_test = feature_table(test(cvtt), selected_features);
        y_test = labels(test(cvtt));
    end
end
