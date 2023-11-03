function [theClassifier] = createClassifier(dataIn, labelsIn)
    
    % % Linear discriminant analysis
    % theClassifier = fitcdiscr(dataIn,labelsIn);

    % Decision tree
    %theClassifier = fitctree(dataIn,labelsIn)

    % fitcknn does k-nearest neighbors
    theClassifier = fitcknn(dataIn,labelsIn,...
       "NumNeighbors",3);

end