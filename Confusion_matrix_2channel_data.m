
% Reset because else there are issues with the counter
reset(cds2ChannelTest)

% Step 1: Read all the test data from the combined datastore
YPred = [];
YTrue = [];

while hasdata(cds2ChannelTest)
    % Read a batch of data from the test datastore
    miniBatchData = read(cds2ChannelTest);
    data = miniBatchData{1};
    labels = miniBatchData{2};
    
    % Step 2: Classify the data using the trained network
    predictedLabels = classify(net_inception_2channel, data); % Predictions
    
    % Append predictions and true labels to arrays
    YPred = [YPred; predictedLabels];
    YTrue = [YTrue; labels];
end

% Step 3: Create a confusion matrix
confusionchart(YTrue, YPred);

% Step 4: Calculate and display accuracy
correctPredictions = (YPred == YTrue);
accuracy = sum(correctPredictions) / numel(YTrue) * 100;
fprintf('Test Accuracy: %.2f%%\n', accuracy);