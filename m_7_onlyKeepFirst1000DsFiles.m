function m_7_onlyKeepFirst1000DsFiles(ds, numFilesToKeep)

    % Function to update the signalDatastore by keeping only the first 'numFilesToKeep' files
    % ds: The original signalDatastore object (passed by reference)
    % numFilesToKeep: The number of files to keep in the datastore

    % The filePath and matfilename variables are not updated
    % with new numbers, but the script works on the Files property

    % Get the list of files from the original signalDatastore
    originalFiles = ds.Files;

    % Determine the number of files to keep (minimum of numFilesToKeep or total files)
    numFiles = min(numFilesToKeep, numel(originalFiles));

    % Select the files
    limitedFiles = originalFiles(1:numFiles);

    % Update the Files property of the original signalDatastore
    ds.Files = limitedFiles;

    % Print success and how many files were removed
    fprintf('Updated signalDatastore: Retained %d files out of %d available files.\n', numFiles, numel(originalFiles));
end

