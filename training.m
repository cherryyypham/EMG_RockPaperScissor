filesToLoad = {"train_feature_table.mat", "anotherday_feature_table.mat"};
load(filesToLoad)

% Select a subset of features (or all of them)
selected_features = 1:size(feature_table,2); % This selects all features
%selected_features = [1 2]; %This selects the first two features listed above

% Load the feature data and put into X and y matrices
[X_train, y_train, X_test, y_test] = featuresTo_X_y_train_test(filesToLoad, selected_features);

% Perform cross-validation
KFolds = 5;
cvp_kfold = cvpartition(y_train, 'KFold', KFolds);

% Make empty vector to store predictions from k-fold cross-validation
validation_predictions = NaN(length(y_train),1);

% Loop through all the folds
for fold = 1:KFolds
    % Within each partition, assign the data for that fold to the
    % cross-validation training data
    kfold_partial_data_X_train = X_train(cvp_kfold.training(fold), :);
    kfold_partial_data_y_train = y_train(cvp_kfold.training(fold), :);
    
    % Within each partition, assign the data for that fold to the
    % cross-validation validation (testing) data
    kfold_partial_data_X_val = X_train(cvp_kfold.test(fold), :);
    %kfold_partial_data_y_val = y_train(cvp_kfold.test(fold), :);

    % Build a temporary model for this subset of the data (k-1)/k
    kfold_classifier = createClassifier(kfold_partial_data_X_train,kfold_partial_data_y_train);

    % Make predictions with the kfold_classifier  (temporary classifier on
    % subset of data)
    kfold_predictions = kfold_classifier.predict(kfold_partial_data_X_val);

    % Store predictions in the original order
    validation_predictions(cvp_kfold.test(fold), :) = kfold_predictions;
end

% Create a classifier  
currentClassifier = createClassifier(X_train, y_train);

% Use classifier to predict on training data (resubstitution)
y_train_predictions = currentClassifier.predict(X_train);
[train_accuracy ] = calculateMetrics(y_train, y_train_predictions)
% Calculate cross-validation metrics
[validation_accuracy ] = calculateMetrics(y_train, validation_predictions)
function [X_train, y_train, X_test, y_test] = featuresTo_X_y_train_test(filesToLoad, selected_features)


    if size(filesToLoad,2) == 2
        isSeparateTestData = true;
    elseif size(filesToLoad,2) == 1
        isSeparateTestData = false;
    else 
        error("Wrong number of files to load.")
    end
       load(filesToLoad{1})
If separate test data
    if isSeparateTestData   
        % Put the train data into X and y  
        X_train = feature_table(:,selected_features);
        y_train = labels;
    
    
        % If you just want to use your train data again (resubstitution), just
        % get rid of the load part and repeat the step above.
    
        % Load the test data (here, it's the same file.. so fix this)
        load(filesToLoad{2});
    
        % Put the test data into X and y  
        % You might need to change variable names here
        X_test = feature_table(:,selected_features);
        y_test = labels;
    
If split the train / test data from one file
    else
        % If you want to partition your data into train and test
        holdout_proportion_test = 0.25;
        try 
            % If it exists, Load a saved partition from last time (so you don't keep
            % shufflig which dat is your train and test)
            load("lastCVpartition.mat")
            disp("loading prior training-test partition")
            if cvtt.NumObservations ~= length(labels) || cvtt.TestSize/cvtt.NumObservations ~= holdout_proportion_test
                warning('Loaded cv partition does not match number of observations, delete or rename and rerun, making a temporary new one')
                
                cvtt = cvpartition(labels,"HoldOut",holdout_proportion_test); % Decimal is how much to hold out for test
            end
        catch
            cvtt = cvpartition(labels,"HoldOut",holdout_proportion_test); % Decimal is how much to hold out for test
            save("./lastCVpartition.mat","cvtt");
            disp('Making new training-test partiton')
        end
        
        % Train data
        X_train = feature_table(training(cvtt),selected_features);
        y_train = labels(training(cvtt));
    
        %Test datac
        X_test = feature_table(test(cvtt),selected_features);
        y_test = labels(test(cvtt));
    end
end

function [theClassifier] = createClassifier(dataIn, labelsIn)
    
    % Linear discriminant analysis
    theClassifier = fitcdiscr(dataIn,labelsIn);

    % Decision tree
    %theClassifier = fitctree(dataIn,labelsIn)

    % fitcknn does k-nearest neighbors
    %theClassifier = fitcknn(dataIn,labelsIn,...
    %    "NumNeighbors",3);

end
