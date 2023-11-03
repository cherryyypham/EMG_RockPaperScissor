function [accuracy, confusion] = calculateMetrics(true_labels, predicted_labels)
    % Calculate accuracy
    accuracy = sum(true_labels == predicted_labels) / numel(true_labels);

    % Compute confusion matrix
    confusion = confusionmat(true_labels, predicted_labels);
end