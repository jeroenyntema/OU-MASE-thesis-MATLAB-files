% Specify the folder containing the .complex files
folderPath = 'C:\etc';

% Get a list of all .complex files in the folder
filePattern = fullfile(folderPath, '*.complex');
complexFiles = dir(filePattern);

% Loop over each .complex file
for k = 1:length(complexFiles)
    % Get the full file name of the .complex file
    baseFileName = complexFiles(k).name;
    fullFileName = fullfile(folderPath, baseFileName);
    
    % Open the .complex file and read its data
    fid = fopen(fullFileName, 'rb');
    if fid == -1
        fprintf('Failed to open file: %s\n', fullFileName);
        continue;
    end
    binaryData = fread(fid, 'float32');
    fclose(fid);
    
    % Create the .mat file name by replacing the .complex extension with .mat
    [~, name, ~] = fileparts(baseFileName);
    matFileName = fullfile(folderPath, [name, '.mat']);
    
    % Save the binary data as a .mat file
    save(matFileName, 'binaryData');
    
    % Print success
    fprintf('Converted %s to %s\n', baseFileName, [name, '.mat']);
end

disp('All files have been processed.');
