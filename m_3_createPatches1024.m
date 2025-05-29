function m_3_createPatches1024(sds)
    % This function takes a signalDatastore as input and splits the
    % MAT files in it into individual MAT files of size 1024 x 1.
    % Any remaining data that doesn't fit into a complete segment is
    % removed

    % Define the segment length
    segmentLength = 1024;
    
    % Get the list of files from the signalDatastore
    files = sds.Files;

    % Loop through each file in the signalDatastore
    for fileIdx = 1:length(files)
        % Load the current file
        data = load(files{fileIdx});
        
        % Extract the variable name
        varName = fieldnames(data);
        signal = data.(varName{1});
        
        % Get the length of the signal array
        arrayLength = length(signal);
        
        % Calculate the number of full segments of size 1024
        numSegments = floor(arrayLength / segmentLength);
        
        % Get the directory of the current file
        [fileDir, name, ~] = fileparts(files{fileIdx});
        
        % Loop over each segment and save it to a new mat file
        for segmentIdx = 1:numSegments
            % Extract the current segment
            segment = signal((segmentIdx-1)*segmentLength + 1 : segmentIdx*segmentLength);
            
            % Create a file name for the current segment
            % Use the original file name and append the segment index
            fileName = sprintf('%s_segment_%d.mat', name, segmentIdx);
            
            % Save the current segment to a new .mat file
            fullFilePath = fullfile(fileDir, fileName);
            save(fullFilePath, 'segment');
        end
    end
    
    disp('Finished splitting and saving segments.');
end

% Custom function to read the .mat files
function data = matRead(filename)
    loadedData = load(filename);
    data = {loadedData.binaryData};
end