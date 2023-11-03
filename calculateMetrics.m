function [accuracy] = calculateMetrics(true_labels, predicted_labels)
    accuracy = sum(true_labels == predicted_labels) / length(true_labels);
end