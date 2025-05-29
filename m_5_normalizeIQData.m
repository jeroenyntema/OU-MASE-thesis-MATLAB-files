function normalizedIQ = m_5_normalizeIQData(sds)

 % This function takes a signalDatastore as input and (z score) normalizes
 % values in MAT files with (non-interleaved) IQ data 
 % The new files are saved with '_segment_complex_' replaced by '_segment_complex_normalized' in their names.

 % BE SURE TO RUN script m_2 FIRST to make sure the correct files are
 % loaded in the data stores after step 4

 % Get the list of files from the signalDatastore
    files = sds.Files;

    % Loop through each file in the signalDatastore
    for fileIdx = 1:length(files)
        % Get the current file name
        currentFile = files{fileIdx};
        
        % Check if the file name contains '_segment_'
        if contains(currentFile, '_segment_complex_')
            
            data = load(currentFile);
            
            % Extract the variable name of the mat file
            varName = fieldnames(data);
            iqData = data.(varName{1});
            
            %normalize (z-score)
            meanIQ = mean(iqData);
            varIQ = var(iqData);
        
            normalizedIQ = (iqData - meanIQ) / sqrt(varIQ);
        
            assignin('base', 'normalizedIQ', normalizedIQ);

            % Create a new file name with '_segment_' replaced by '_segment_complex_'
            newFileName = strrep(currentFile, '_segment_complex_', '_segment_complex_normalized_');
            
            % Save the complex data to the new .mat file
            save(newFileName, 'normalizedIQ');
        end
    end
    
    disp('Finished converting and saving complex data files.');
end
