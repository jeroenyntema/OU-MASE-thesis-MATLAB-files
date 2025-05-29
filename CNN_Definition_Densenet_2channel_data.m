% Define input parameters
inputSize = [512, 1, 2];
numClasses = 4;

% Initialize a layer graph
lgraph_2channel_densenet = layerGraph();

% Define and add the input layer for complex data
inputLayer = imageInputLayer(inputSize, 'Normalization', 'none', 'Name', 'input', 'SplitComplexInputs', true);
lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, inputLayer);

% Initial convolutional layer
conv1 = convolution2dLayer([3 1], 64, 'Padding', 'same', 'Name', 'conv1');
bn1 = batchNormalizationLayer('Name', 'bn1');
relu1 = reluLayer('Name', 'relu1');
lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, conv1);
lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, bn1);
lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, relu1);

% Connect initial layers
lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, 'input', 'conv1');
lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, 'conv1', 'bn1');
lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, 'bn1', 'relu1');

% Add dense blocks
growthRate = 32; % Growth rate, i.e., number of feature maps added per layer within dense blocks
numDenseBlocks = 3;
numLayersPerBlock = 4;

% Connect each transition layer's output to the next dense block or final layers
for i = 1:numDenseBlocks
    % Define the input layer for the current block
    if i == 1
        inputLayerName = 'relu1';
    else
        inputLayerName = sprintf('transition%d_pool', i-1); % Connect to previous transition pool layer
    end

    % Add the dense block and get the name of the last concatenation layer
    lgraph_2channel_densenet = addDenseBlock(lgraph_2channel_densenet, numLayersPerBlock, growthRate, i, inputLayerName);
    lastConcatLayerName = sprintf('denseBlock%d_concat%d', i, numLayersPerBlock);

    % Add transition layer after each dense block, except the last one
    if i < numDenseBlocks
        % Adjust pooling size dynamically
        lgraph_2channel_densenet = addTransitionLayer(lgraph_2channel_densenet, growthRate * numLayersPerBlock, i, lastConcatLayerName, inputSize);
    else
        % The final dense block's last concat layer will connect to the globalAvgPool layer later
    end
end

% Final layers
globalAvgPool = globalAveragePooling2dLayer('Name', 'globalAvgPool');
fc = fullyConnectedLayer(numClasses, 'Name', 'fc');
softmax = softmaxLayer('Name', 'softmax');
classification = classificationLayer('Name', 'classification');

% Add final layers to the graph
lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, globalAvgPool);
lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, fc);
lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, softmax);
lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, classification);

% Connect final layers
lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, lastConcatLayerName, 'globalAvgPool'); % Connect last dense block to global average pooling
lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, 'globalAvgPool', 'fc');
lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, 'fc', 'softmax');
lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, 'softmax', 'classification');

function lgraph_2channel_densenet = addTransitionLayer(lgraph_2channel_densenet, numChannels, transIdx, lastConcatLayerName, currentInputSize)
    convLayer = convolution2dLayer(1, numChannels, 'Padding', 'same', 'Name', sprintf('transition%d_conv', transIdx));
    bnLayer = batchNormalizationLayer('Name', sprintf('transition%d_bn', transIdx));
    reluLayerObj = reluLayer('Name', sprintf('transition%d_relu', transIdx));
    
    % Set pool size to a fixed small value (e.g., 1) to avoid dimension issues
    poolSize = 1;
    poolLayer = averagePooling2dLayer(poolSize, 'Stride', poolSize, 'Name', sprintf('transition%d_pool', transIdx));
    
    % Add layers to the graph
    lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, convLayer);
    lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, bnLayer);
    lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, reluLayerObj);
    lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, poolLayer);

    % Connect layers
    lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, lastConcatLayerName, sprintf('transition%d_conv', transIdx));
    lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, sprintf('transition%d_conv', transIdx), sprintf('transition%d_bn', transIdx));
    lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, sprintf('transition%d_bn', transIdx), sprintf('transition%d_relu', transIdx));
    lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, sprintf('transition%d_relu', transIdx), sprintf('transition%d_pool', transIdx));
end

% Updated helper function to define a Dense Block with corrected variable naming
function lgraph_2channel_densenet = addDenseBlock(lgraph_2channel_densenet, numLayers, growthRate, blockIdx, inputLayerName)
    % Loop through each layer in the Dense Block
    for layerIdx = 1:numLayers
        % Define unique names for each layer in the Dense Block
        convLayerName = sprintf('denseBlock%d_conv%d', blockIdx, layerIdx);
        bnLayerName = sprintf('denseBlock%d_bn%d', blockIdx, layerIdx);
        reluLayerName = sprintf('denseBlock%d_relu%d', blockIdx, layerIdx);
        
        % Create the convolution, batch normalization, and ReLU layers
        convLayer = convolution2dLayer([3 1], growthRate, 'Padding', 'same', 'Name', convLayerName);
        bnLayer = batchNormalizationLayer('Name', bnLayerName);
        reluLayerObj = reluLayer('Name', reluLayerName);  % Rename variable to avoid conflict

        % Add layers to the layer graph
        lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, convLayer);
        lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, bnLayer);
        lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, reluLayerObj);

        % Connect the layers within the Dense Block
        lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, inputLayerName, bnLayerName);
        lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, bnLayerName, reluLayerName);
        lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, reluLayerName, convLayerName);

        % Concatenate output with input for next layer
        concatLayerName = sprintf('denseBlock%d_concat%d', blockIdx, layerIdx);
        concatLayer = concatenationLayer(3, 2, 'Name', concatLayerName);
        lgraph_2channel_densenet = addLayers(lgraph_2channel_densenet, concatLayer);

        lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, inputLayerName, [concatLayerName '/in1']);
        lgraph_2channel_densenet = connectLayers(lgraph_2channel_densenet, convLayerName, [concatLayerName '/in2']);

        % Update input for next layer in Dense Block
        inputLayerName = concatLayerName;
    end
end