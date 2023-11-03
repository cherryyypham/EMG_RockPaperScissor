% Add function to test data with model

% Add more functions to eval model accuracy and efficiency (past
% assignments)

function [accuracy ] = calculateMetrics(true_labels, predicted_labels)
    
    accuracy = sum(true_labels == predicted_labels) / length(true_labels);
    
end