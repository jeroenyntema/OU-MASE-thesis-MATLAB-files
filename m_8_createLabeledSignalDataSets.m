function m_8_createLabeledSignalDataSets(dsNames)
    % Function to create MATLAB labeledSignalSet objects for a set of signalDatastore names
    % dsNames: Cell array of signalDatastore variable names (as strings)
    % example command: createLabeledSignalSets({'dsHue', 'dsInnr'});

    % Loop through each datastore name provided
    for i = 1:length(dsNames)
        % Get the name of the current datastore and labeled signal set
        dsName = dsNames{i};
        lssName = ['lss' dsName(3:5)];

        % Retrieve the relevant datastore
        ds = evalin('base', dsName);

        labelName = 'DeviceType'; 
        sld = signalLabelDefinition(labelName, 'LabelType', 'attribute', 'LabelDataType', 'categorical', Categories=["Hue" "Inn" "Aeo" "WHa"]);

        % Create a labeledSignalSet for the current datastore
        lss = labeledSignalSet(ds, sld);

        labelValue = dsName(3:5);

        % Loop through datastore and set label value
        for i = 1:numel(lss.Labels)
            setLabelValue(lss, i, labelName, labelValue);
        end

        % Store labeledSignalSet
        assignin('base', lssName, lss);

        % Print if successful
        fprintf('Successfully created labeledSignalSet %s for %s.\n', lssName, dsName);
    end
end