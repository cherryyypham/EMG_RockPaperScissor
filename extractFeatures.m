function [feature_table] = extractFeatures(dataChTimeTr,includedFeatures, Fs)
    % List of channels to include (can change to only use some)
    includedChannels = 1:size(dataChTimeTr,1);
    
    % Empty feature table
    feature_table = table();

    for f = 1:length(includedFeatures)
        switch includedFeatures{f}
            case 'var'
                fvalues = squeeze(var(dataChTimeTr,0,2))';
            case 'std'
                fvalues = squeeze(std(dataChTimeTr, 0, 2))';
            case 'rms'
                fvalues = squeeze(sqrt(mean(dataChTimeTr.^2, 2)))';
            case 'mav'
                fvalues = squeeze(mean(abs(dataChTimeTr), 2))';
            otherwise
                disp(strcat('Unknown feature: ', includedFeatures{f}, ...
                     ', skipping....'))
                break
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Put feature values (fvalues) into a table with appropriate names
        % fvalues should have rows = number of trials
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % If there is only one feature, just name it the feature name
        if size(fvalues,2) == 1
            feature_table = [feature_table table(fvalues,...
                'VariableNames',string(strcat(includedFeatures{f})))];
        
        % If the number of features matches the number of included
        % channels, then assume each column is a channel
        elseif size(fvalues,2) == length(includedChannels)
            %Put data into a table with the feature name and channel number
            for  ch = includedChannels
                feature_table = [feature_table table(fvalues(:,ch),...
                    'VariableNames',string(strcat(includedFeatures{f}, '_' ,'Ch',num2str(ch))))];
            end
        
        else
        % Otherwise, loop through each one and give a number name 
            for  v = 1:size(fvalues,2)
                feature_table = [feature_table table(fvalues(:,v),...
                    'VariableNames',string(strcat(includedFeatures{f}, '_' ,'val',num2str(v))))];
            end
        end
    end
end
