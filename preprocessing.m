function [dataChTimeTr, labels] = preprocessing(finaldataset, finaldataset_size)
    % Initilize variables
    dataChTimeTr = [];
    labels = [];
    for i = 1:finaldataset_size 
        % Loads the data
        load(fullfile(finaldataset(i).folder,finaldataset(i).name));

        % Epoch data to cut into time chunks using preprocessData

        % Not completely sure what that function does bc there's no
        % documentation but my guess is it takes out extra data entries
        % (ones that are not 1, 2, 3, i.e. 0 and 99) and then combine
        % lsl_data and marker_data of every data file into an Epoch var
        % that contains timed datapoints of 4 channels for 300 trials and a
        % gesturelist variable that contains correct gesture data.
        [Epoch, gesturelist] = preprocessData(lsl_data, marker_data);

        % Concatenate new epoch data into final a 3-dim array
        dataChTimeTr = cat(3,dataChTimeTr,Epoch);

        % Add the new items in gesturelist into the final list of labels
        labels = [labels; gesturelist];
    end
end

