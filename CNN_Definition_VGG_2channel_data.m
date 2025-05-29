% Define input parameters
inputSize = [512, 1, 2];
numClasses = 4;

% Initialize a layer graph
lgraph_2channel_vgg = layerGraph();

% Define and add the input layer for complex data
inputLayer = imageInputLayer(inputSize, 'Normalization', 'none', 'Name', 'input', 'SplitComplexInputs', true);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, inputLayer);

% Define the VGG blocks
numVGGBlocks = 5;         % Typical VGG models have 5 blocks
numConvsPerBlock = [2, 2, 3, 3, 3]; % Number of conv layers per block
numFilters = [64, 128, 256, 512, 512]; % Number of filters for each block

for i = 1:numVGGBlocks
    if i == 1
        inputLayerName = 'input';
    else
        inputLayerName = sprintf('vggBlock%d_pool', i-1);
    end
    
    % Add VGG block
    lgraph_2channel_vgg = addVGGBlock(lgraph_2channel_vgg, numConvsPerBlock(i), numFilters(i), i, inputLayerName);
end

% Final layers: Fully Connected Layers as per VGG
fullyConnected1 = fullyConnectedLayer(4096, 'Name', 'fc1', 'WeightLearnRateFactor', 10, 'BiasLearnRateFactor', 10);
relu1 = reluLayer('Name', 'relu1');
dropout1 = dropoutLayer(0.5, 'Name', 'dropout1');

fullyConnected2 = fullyConnectedLayer(4096, 'Name', 'fc2', 'WeightLearnRateFactor', 10, 'BiasLearnRateFactor', 10);
relu2 = reluLayer('Name', 'relu2');
dropout2 = dropoutLayer(0.5, 'Name', 'dropout2');

fullyConnected3 = fullyConnectedLayer(numClasses, 'Name', 'fc3', 'WeightLearnRateFactor', 10, 'BiasLearnRateFactor', 10);
softmax = softmaxLayer('Name', 'softmax');
classification = classificationLayer('Name', 'classification');

% Add final fully connected layers to the layer graph
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, fullyConnected1);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, relu1);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, dropout1);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, fullyConnected2);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, relu2);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, dropout2);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, fullyConnected3);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, softmax);
lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, classification);

% Connect the final layers
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, sprintf('vggBlock%d_pool', numVGGBlocks), 'fc1');
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, 'fc1', 'relu1');
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, 'relu1', 'dropout1');
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, 'dropout1', 'fc2');
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, 'fc2', 'relu2');
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, 'relu2', 'dropout2');
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, 'dropout2', 'fc3');
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, 'fc3', 'softmax');
lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, 'softmax', 'classification');

% Helper function to define a VGG block
function lgraph_2channel_vgg = addVGGBlock(lgraph_2channel_vgg, numConvLayers, numFilters, blockIdx, inputLayerName)
    for i = 1:numConvLayers
        convLayerName = sprintf('vggBlock%d_conv%d', blockIdx, i);
        bnLayerName = sprintf('vggBlock%d_bn%d', blockIdx, i);
        reluLayerName = sprintf('vggBlock%d_relu%d', blockIdx, i);
        
        % Convolutional layer, batch normalization, and ReLU
        convLayer = convolution2dLayer([3 1], numFilters, 'Padding', 'same', 'Name', convLayerName);
        bnLayer = batchNormalizationLayer('Name', bnLayerName);
        reluLayerObj = reluLayer('Name', reluLayerName);
        
        % Add each convolutional layer to the layer graph
        lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, convLayer);
        lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, bnLayer);
        lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, reluLayerObj);
        
        % Connect layers within the block
        if i == 1
            lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, inputLayerName, convLayerName);
        else
            prevLayerName = sprintf('vggBlock%d_relu%d', blockIdx, i-1);
            lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, prevLayerName, convLayerName);
        end
        
        % Connect the batch normalization and ReLU layers
        lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, convLayerName, bnLayerName);
        lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, bnLayerName, reluLayerName);
    end
    
    % Add max pooling layer after the convolutional layers in each block
    poolLayer = maxPooling2dLayer(2, 'Stride', 2, 'Padding', 'same', 'Name', sprintf('vggBlock%d_pool', blockIdx));
    lgraph_2channel_vgg = addLayers(lgraph_2channel_vgg, poolLayer);
    
    % Connect the last ReLU layer of the block to the pooling layer
    finalReluLayerName = sprintf('vggBlock%d_relu%d', blockIdx, numConvLayers);
    lgraph_2channel_vgg = connectLayers(lgraph_2channel_vgg, finalReluLayerName, sprintf('vggBlock%d_pool', blockIdx));
end
