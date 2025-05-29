function m_6_onlyKeepNormalizedDsFiles_2channel()

% This function updates the files for the ds (not the physical files on disk).
% It removes all files except those with the string "segment_complex_normalized"
% In order to keep only the correct files for the labeling

%################################################### for Hue

dataDirHue = 'C:\Users\jeroe\MATLAB\Projects\MainThesisDataProjectJeroen\Isolated_signals\Hue';
assignin('base', 'dataDirHue', dataDirHue);

% Get a list of all .mat files in the directory
matFilesHue = dir(fullfile(dataDirHue, '*.mat'));

% Filter the files to only include those with "segment_complex_normalized_2channel" in the name
filteredFilesHue = matFilesHue(contains({matFilesHue.name}, 'segment_complex_normalized_2channel'));

% Generate full file paths for the filtered files
filePathsHue = fullfile({filteredFilesHue.folder}, {filteredFilesHue.name});
assignin('base', 'filePathsHue', filePathsHue);

% Create a new signal datastore with the filtered files
dsHue2Channel = signalDatastore(filePathsHue);
assignin('base', 'dsHue2Channel', dsHue2Channel);

%################################################### for Innr

dataDirInnr = 'C:\Users\jeroe\MATLAB\Projects\MainThesisDataProjectJeroen\Isolated_signals\Innr';
assignin('base', 'dataDirInnr', dataDirInnr);

matFilesInnr = dir(fullfile(dataDirInnr, '*.mat'));

filteredFilesInnr = matFilesInnr(contains({matFilesInnr.name}, 'segment_complex_normalized_2channel'));

filePathsInnr = fullfile({filteredFilesInnr.folder}, {filteredFilesInnr.name});
assignin('base', 'filePathsInnr', filePathsInnr);

dsInnr2Channel = signalDatastore(filePathsInnr);
assignin('base', 'dsInnr2Channel', dsInnr2Channel);

%################################################### for Aeotec

dataDirAeotec = 'C:\Users\jeroe\MATLAB\Projects\MainThesisDataProjectJeroen\Isolated_signals\Aeotec';
assignin('base', 'dataDirAeotec', dataDirAeotec);

matFilesAeotec = dir(fullfile(dataDirAeotec, '*.mat'));

filteredFilesAeotec = matFilesAeotec(contains({matFilesAeotec.name}, 'segment_complex_normalized_2channel'));

filePathsAeotec = fullfile({filteredFilesAeotec.folder}, {filteredFilesAeotec.name});
assignin('base', 'filePathsAeotec', filePathsAeotec);

dsAeotec2Channel = signalDatastore(filePathsAeotec);
assignin('base', 'dsAeotec2Channel', dsAeotec2Channel);


%################################################### for WHart

dataDirWHart = 'C:\Users\jeroe\MATLAB\Projects\MainThesisDataProjectJeroen\Isolated_signals\WHart';
assignin('base', 'dataDirWHart', dataDirWHart);

matFilesWHart = dir(fullfile(dataDirWHart, '*.mat'));

filteredFilesWHart = matFilesWHart(contains({matFilesWHart.name}, 'segment_complex_normalized_2channel'));

filePathsWHart = fullfile({filteredFilesWHart.folder}, {filteredFilesWHart.name});
assignin('base', 'filePathsWHart', filePathsWHart);

dsWHart2Channel = signalDatastore(filePathsWHart);
assignin('base', 'dsWHart2Channel', dsWHart2Channel);
