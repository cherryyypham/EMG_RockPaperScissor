function [theClassifier] = createClassifier(dataIn, labelsIn)
    % createClassifier - Create a classification model using input data and labels
    %   [theClassifier] = createClassifier(dataIn, labelsIn) creates a
    %   classification model using the input dataIn and corresponding labelsIn.
    %   This function uses k-nearest neighbors as the classification model.
    %
    %   Input:
    %   - dataIn: Input feature matrix for training the classifier
    %   - labelsIn: Labels corresponding to the input data for training
    %
    %   Output:
    %   - theClassifier: Trained classification model
    
    % Uncomment one of the following lines based on the desired classifier
    
    % Linear discriminant analysis
    % theClassifier = fitcdiscr(dataIn, labelsIn);

    % Decision tree
    % theClassifier = fitctree(dataIn, labelsIn);

    % K-nearest neighbors
    theClassifier = fitcknn(dataIn, labelsIn, "NumNeighbors", 3);
end
