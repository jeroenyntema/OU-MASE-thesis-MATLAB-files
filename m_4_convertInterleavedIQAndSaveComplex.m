function m_4_convertInterleavedIQAndSaveComplex(sds)
    % This function takes a signalDatastore as input and converts
    % MAT files with interleaved IQ data into complex doubles.
    % The new files are saved with '_segment_' replaced by '_segment_complex_' in their names.

    % BE SURE TO RUN script #2 (again) FIRST to make sure all files from
    % step 3 are loaded in the data stores

    % Get the list of files from the signalDatastore
    files = sds.Files;

    % Loop through each file in the signalDatastore
    for fileIdx = 1:length(files)
        % Get the current file name
        currentFile = files{fileIdx};
        
        % Check if the file name contains '_segment_'
        if contains(currentFile, '_segment_')
            % Load the current file
            data = load(currentFile);
            
            % Extract the variable name (assuming only one variable per MAT file)
            varName = fieldnames(data);
            iqData = data.(varName{1});
            
            % Make sure the data length is even
            if mod(length(iqData), 2) ~= 0
                error('The length of the interleaved IQ data must be even.');
            end
            
            % Convert interleaved IQ data to complex doubles
            I = iqData(1:2:end);
            Q = iqData(2:2:end);
            complexData = I + 1i * Q;
            
            % Create a new file name with '_segment_' replaced by '_segment_complex_'
            newFileName = strrep(currentFile, '_segment_', '_segment_complex_');
            
            % Save the complex data to the new .mat file
            save(newFileName, 'complexData');
        end
    end
    
    disp('Finished converting and saving complex data files.');
end

% Function to read the .mat files
function data = matRead(filename)
    loadedData = load(filename);
    data = {loadedData.binaryData};
end


