function m_8_2channel_createLabeledSignalDataSets(dsNames)
    % Function to create labeledSignalSet objects for the given signalDatastore names
    % dsNames: Cell array of signalDatastore variable names (as strings)
    % example command createLabeledSignalSets({'dsHue', 'dsInnr'});

    % Loop through each datastore name provided
    for i = 1:length(dsNames)
        % Get the name of the current datastore and labeled signal set
        dsName = dsNames{i};
        lssName = ['lss' dsName(3:5) '2Channel']; % Create labeledSignalSet variable name

        % Retrieve the datastore from the base workspace
        ds = evalin('base', dsName);

        labelName = 'DeviceType';  % Name of the label to add
        sld = signalLabelDefinition(labelName, 'LabelType', 'attribute', 'LabelDataType', 'categorical', Categories=["Hue" "Inn" "Aeo" "WHa"]);

        % Create a labeledSignalSet for the current datastore
        lss = labeledSignalSet(ds, sld);

        labelValue = dsName(3:5);

        for i = 1:numel(lss.Labels) % Loop through the number of files or elements in the datastore
            setLabelValue(lss, i, labelName, labelValue); % Set the label for each element
        end

        % Assign the labeledSignalSet to the base workspace
        assignin('base', lssName, lss);

        % Display a message indicating success
        fprintf('Created labeledSignalSet %s for %s.\n', lssName, dsName);
    end
end