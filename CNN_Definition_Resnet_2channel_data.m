% changed on 9/6/2025 to have 8 main blocks instead of 3

inputSize = [512, 1, 2];
numClasses = 4;

% Initialize a layer graph
lgraph_2channel_resnet = layerGraph();

% Define and add the input layer for complex data
inputLayer = imageInputLayer(inputSize, 'Normalization', 'none', 'Name', 'input', 'SplitComplexInputs', true);
lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, inputLayer);

% Define and add the initial convolutional layers
conv1 = convolution2dLayer([3 1], 64, 'Padding', 'same', 'Name', 'conv1');
bn1 = batchNormalizationLayer('Name', 'bn1');
relu1 = reluLayer('Name', 'relu1');
lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, conv1);
lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, bn1);
lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, relu1);

% Connect the initial layers
lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, 'input', 'conv1');
lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, 'conv1', 'bn1');
lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, 'bn1', 'relu1');

% Add residual blocks with appropriate naming
for i = 1:8
    if i == 1
        inputLayerName = 'relu1';
    else
        inputLayerName = sprintf('resBlock%d_final_relu', i-1);
    end
    
    lgraph_2channel_resnet = addResidualBlock(lgraph_2channel_resnet, 64, sprintf('resBlock%d', i), inputLayerName);
end

% Add the final layers
globalAvgPool = globalAveragePooling2dLayer('Name', 'globalAvgPool');
fc = fullyConnectedLayer(numClasses, 'Name', 'fc');
softmax = softmaxLayer('Name', 'softmax');
classification = classificationLayer('Name', 'classification');

lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, globalAvgPool);
lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, fc);
lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, softmax);
lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, classification);

% Connect the final layers
lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, 'resBlock8_final_relu', 'globalAvgPool');
lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, 'globalAvgPool', 'fc');
lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, 'fc', 'softmax');
lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, 'softmax', 'classification');

% Helper function to define a residual block
function lgraph_2channel_resnet = addResidualBlock(lgraph_2channel_resnet, numFilters, blockName, inputLayerName)
    % Define unique names for residual block layers
    conv1 = convolution2dLayer([3 1], numFilters, 'Padding', 'same', 'Name', [blockName, '_conv1']);
    bn1 = batchNormalizationLayer('Name', [blockName, '_bn1']);
    relu1 = reluLayer('Name', [blockName, '_relu1']);
    
    conv2 = convolution2dLayer([3 1], numFilters, 'Padding', 'same', 'Name', [blockName, '_conv2']);
    bn2 = batchNormalizationLayer('Name', [blockName, '_bn2']);
    
    % Define the addition layer
    addLayer = additionLayer(2, 'Name', [blockName, '_add']);
    
    % Add layers to the layer graph
    lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, conv1);
    lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, bn1);
    lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, relu1);
    lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, conv2);
    lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, bn2);
    lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, addLayer);
    
    % Add ReLU layer after addition
    finalRelu = reluLayer('Name', [blockName, '_final_relu']);
    lgraph_2channel_resnet = addLayers(lgraph_2channel_resnet, finalRelu);

    % Connect the layers
    lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, inputLayerName, [blockName, '_conv1']);
    lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, [blockName, '_conv1'], [blockName, '_bn1']);
    lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, [blockName, '_bn1'], [blockName, '_relu1']);
    lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, [blockName, '_relu1'], [blockName, '_conv2']);
    lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, [blockName, '_conv2'], [blockName, '_bn2']);
    
    % Connect the skip connection
    lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, inputLayerName, [blockName, '_add/in2']);
    lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, [blockName, '_bn2'], [blockName, '_add/in1']);
    lgraph_2channel_resnet = connectLayers(lgraph_2channel_resnet, [blockName, '_add'], [blockName, '_final_relu']);
end