
function Create_2channel_data(sds)

    % This function takes a signalDatastore as input and converts
    % .mat files with complex doubles to a 3D array with real + imag values
    % The new files are saved with '_segment_complex_normalized' replaced by '_segment_complex_normalized_2channel' in their names.

    % BE SURE TO RUN script #2 (again) FIRST to make sure the correct files
    % are loaded in the data stores

    % Get the list of files from the signalDatastore
    files = sds.Files;

    % Loop through each file in the signalDatastore
    for fileIdx = 1:length(files)
        % Get the current file name
        currentFile = files{fileIdx};
        
        % Check if the file name contains '_segment_complex_normalized'
        if contains(currentFile, '_segment_complex_normalized') && ~contains(currentFile, 'real')
            % Load the current file
            data = load(currentFile);

            varName = fieldnames(data);
            normalizedIQ = data.(varName{1});

			% Separate real and imaginary parts
			real_part = real(normalizedIQ);
			imag_part = imag(normalizedIQ);
			
			% Combine them into a 2D array or as two separate channels
			data_3d = cat(3, real_part, imag_part); % Concatenate real and imaginary parts
            
            % Create a new file name with '_segment_' replaced by '_segment_complex_'
            newFileName = strrep(currentFile, '_segment_complex_normalized', '_segment_complex_normalized_2channel');
            
            % Save the complex data to the new MAT file
            save(newFileName, 'data_3d');
        end
    end
    
    disp('Finished converting and saving real data files.');
end

% Custom function to read the .mat files
function data = matRead(filename)
    loadedData = load(filename);
    data = {loadedData.binaryData};
end
