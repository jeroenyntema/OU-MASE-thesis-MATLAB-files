% Define input parameters
inputSize = [512, 1, 1];
numClasses = 4;

% Initialize a layer graph
lgraph_complex_inception = layerGraph();

% Define and add the input layer
inputLayer = imageInputLayer(inputSize, 'Normalization', 'none', 'Name', 'input', 'SplitComplexInputs', true);
lgraph_complex_inception = addLayers(lgraph_complex_inception, inputLayer);

% Initial convolution layer
conv1 = convolution2dLayer([3 1], 64, 'Padding', 'same', 'Name', 'conv1');
bn1 = batchNormalizationLayer('Name', 'bn1');
relu1 = reluLayer('Name', 'relu1');
lgraph_complex_inception = addLayers(lgraph_complex_inception, conv1);
lgraph_complex_inception = addLayers(lgraph_complex_inception, bn1);
lgraph_complex_inception = addLayers(lgraph_complex_inception, relu1);

% Connect initial layers
lgraph_complex_inception = connectLayers(lgraph_complex_inception, 'input', 'conv1');
lgraph_complex_inception = connectLayers(lgraph_complex_inception, 'conv1', 'bn1');
lgraph_complex_inception = connectLayers(lgraph_complex_inception, 'bn1', 'relu1');

% Add Inception blocks
numInceptionBlocks = 3; % Adjust the number of inception blocks as needed

for i = 1:numInceptionBlocks
    if i == 1
        inputLayerName = 'relu1';
    else
        inputLayerName = sprintf('inceptionBlock%d_concat', i-1);
    end
    
    % Add an Inception block
    lgraph_complex_inception = addInceptionBlock(lgraph_complex_inception, i, inputLayerName);
end

% Final layers
globalAvgPool = globalAveragePooling2dLayer('Name', 'globalAvgPool');
fc = fullyConnectedLayer(numClasses, 'Name', 'fc');
softmax = softmaxLayer('Name', 'softmax');
classification = classificationLayer('Name', 'classification');

lgraph_complex_inception = addLayers(lgraph_complex_inception, globalAvgPool);
lgraph_complex_inception = addLayers(lgraph_complex_inception, fc);
lgraph_complex_inception = addLayers(lgraph_complex_inception, softmax);
lgraph_complex_inception = addLayers(lgraph_complex_inception, classification);

% Connect final layers
lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_concat', numInceptionBlocks), 'globalAvgPool');
lgraph_complex_inception = connectLayers(lgraph_complex_inception, 'globalAvgPool', 'fc');
lgraph_complex_inception = connectLayers(lgraph_complex_inception, 'fc', 'softmax');
lgraph_complex_inception = connectLayers(lgraph_complex_inception, 'softmax', 'classification');

% Helper function to define an Inception block
function lgraph_complex_inception = addInceptionBlock(lgraph_complex_inception, blockIdx, inputLayerName)
    % Define names for each path in the Inception block
    conv1x1 = convolution2dLayer([1 1], 32, 'Padding', 'same', 'Name', sprintf('inceptionBlock%d_conv1x1', blockIdx));
    bn1x1 = batchNormalizationLayer('Name', sprintf('inceptionBlock%d_bn1x1', blockIdx));
    relu1x1 = reluLayer('Name', sprintf('inceptionBlock%d_relu1x1', blockIdx));
    
    conv3x3 = convolution2dLayer([3 1], 32, 'Padding', 'same', 'Name', sprintf('inceptionBlock%d_conv3x3', blockIdx));
    bn3x3 = batchNormalizationLayer('Name', sprintf('inceptionBlock%d_bn3x3', blockIdx));
    relu3x3 = reluLayer('Name', sprintf('inceptionBlock%d_relu3x3', blockIdx));
    
    conv5x5 = convolution2dLayer([5 1], 32, 'Padding', 'same', 'Name', sprintf('inceptionBlock%d_conv5x5', blockIdx));
    bn5x5 = batchNormalizationLayer('Name', sprintf('inceptionBlock%d_bn5x5', blockIdx));
    relu5x5 = reluLayer('Name', sprintf('inceptionBlock%d_relu5x5', blockIdx));
    
    pool3x3 = maxPooling2dLayer([3 1], 'Padding', 'same', 'Stride', 1, 'Name', sprintf('inceptionBlock%d_pool', blockIdx));
    convPool = convolution2dLayer([1 1], 32, 'Padding', 'same', 'Name', sprintf('inceptionBlock%d_convPool', blockIdx));
    bnPool = batchNormalizationLayer('Name', sprintf('inceptionBlock%d_bnPool', blockIdx));
    reluPool = reluLayer('Name', sprintf('inceptionBlock%d_reluPool', blockIdx));
    
    % Concatenation layer
    concatLayer = concatenationLayer(3, 4, 'Name', sprintf('inceptionBlock%d_concat', blockIdx));
    
    % Add all layers to the graph
    lgraph_complex_inception = addLayers(lgraph_complex_inception, conv1x1);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, bn1x1);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, relu1x1);
    
    lgraph_complex_inception = addLayers(lgraph_complex_inception, conv3x3);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, bn3x3);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, relu3x3);
    
    lgraph_complex_inception = addLayers(lgraph_complex_inception, conv5x5);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, bn5x5);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, relu5x5);
    
    lgraph_complex_inception = addLayers(lgraph_complex_inception, pool3x3);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, convPool);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, bnPool);
    lgraph_complex_inception = addLayers(lgraph_complex_inception, reluPool);
    
    lgraph_complex_inception = addLayers(lgraph_complex_inception, concatLayer);
    
    % Connect the paths
    % Path 1: 1x1 Convolution
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, inputLayerName, sprintf('inceptionBlock%d_conv1x1', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_conv1x1', blockIdx), sprintf('inceptionBlock%d_bn1x1', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_bn1x1', blockIdx), sprintf('inceptionBlock%d_relu1x1', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_relu1x1', blockIdx), sprintf('inceptionBlock%d_concat/in1', blockIdx));
    
    % Path 2: 3x3 Convolution
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, inputLayerName, sprintf('inceptionBlock%d_conv3x3', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_conv3x3', blockIdx), sprintf('inceptionBlock%d_bn3x3', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_bn3x3', blockIdx), sprintf('inceptionBlock%d_relu3x3', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_relu3x3', blockIdx), sprintf('inceptionBlock%d_concat/in2', blockIdx));
    
    % Path 3: 5x5 Convolution
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, inputLayerName, sprintf('inceptionBlock%d_conv5x5', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_conv5x5', blockIdx), sprintf('inceptionBlock%d_bn5x5', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_bn5x5', blockIdx), sprintf('inceptionBlock%d_relu5x5', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_relu5x5', blockIdx), sprintf('inceptionBlock%d_concat/in3', blockIdx));
    
    % Path 4: Pooling
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, inputLayerName, sprintf('inceptionBlock%d_pool', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_pool', blockIdx), sprintf('inceptionBlock%d_convPool', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_convPool', blockIdx), sprintf('inceptionBlock%d_bnPool', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_bnPool', blockIdx), sprintf('inceptionBlock%d_reluPool', blockIdx));
    lgraph_complex_inception = connectLayers(lgraph_complex_inception, sprintf('inceptionBlock%d_reluPool', blockIdx), sprintf('inceptionBlock%d_concat/in4', blockIdx));
end
