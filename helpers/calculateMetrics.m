function [accuracy, confusion] = calculateMetrics(true_labels, predicted_labels)
    % calculateMetrics - Calculate accuracy and confusion matrix
    %   [accuracy, confusion] = calculateMetrics(true_labels, predicted_labels)
    %   calculates the accuracy and confusion matrix based on the true_labels
    %   and predicted_labels.
    %
    %   Input:
    %   - true_labels: True labels for the data
    %   - predicted_labels: Predicted labels obtained from a classifier
    %
    %   Output:
    %   - accuracy: Accuracy of the predictions
    %   - confusion: Confusion matrix
    
    % Calculate accuracy
    accuracy = sum(true_labels == predicted_labels) / numel(true_labels);

    % Compute confusion matrix
    confusion = confusionmat(true_labels, predicted_labels);
end
