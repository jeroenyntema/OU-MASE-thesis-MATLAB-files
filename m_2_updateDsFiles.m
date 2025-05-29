function m_2_updateDsFiles()
    % This function updates the files for the ds. It registers ALL .mat
    % files in a signal folder to the corresponding datastore

    dataDirHue = 'C:\Users\jeroe\MATLAB\Projects\MainThesisDataProjectJeroen\Isolated_signals\Hue';
            assignin('base', 'dataDirHue', dataDirHue);
    matFilesHue = dir(fullfile(dataDirHue, '*.mat'));
            assignin('base', 'matFilesHue', matFilesHue);
    filePathsHue = fullfile({matFilesHue.folder},{matFilesHue.name});
            assignin('base', 'filePathsHue', filePathsHue);
    dsHue = signalDatastore(filePathsHue);
            assignin('base', 'dsHue', dsHue);

    dataDirInnr = 'C:\Users\jeroe\MATLAB\Projects\MainThesisDataProjectJeroen\Isolated_signals\Innr';
            assignin('base', 'dataDirInnr', dataDirInnr);
    matFilesInnr = dir(fullfile(dataDirInnr, '*.mat'));
            assignin('base', 'matFilesInnr', matFilesInnr);
    filePathsInnr = fullfile({matFilesInnr.folder},{matFilesInnr.name});
            assignin('base', 'filePathsInnr', filePathsInnr);
    dsInnr = signalDatastore(filePathsInnr);
            assignin('base', 'dsInnr', dsInnr);

    dataDirAeotec = 'C:\Users\jeroe\MATLAB\Projects\MainThesisDataProjectJeroen\Isolated_signals\Aeotec';
            assignin('base', 'dataDirAeotec', dataDirAeotec);
    matFilesAeotec = dir(fullfile(dataDirAeotec, '*.mat'));
            assignin('base', 'matFilesAeotec', matFilesAeotec);
    filePathsAeotec = fullfile({matFilesAeotec.folder},{matFilesAeotec.name});
            assignin('base', 'filePathsAeotec', filePathsAeotec);
    dsAeotec = signalDatastore(filePathsAeotec);
            assignin('base', 'dsAeotec', dsAeotec);

    dataDirWHart = 'C:\Users\jeroe\MATLAB\Projects\MainThesisDataProjectJeroen\Isolated_signals\WHart';
            assignin('base', 'dataDirWHart', dataDirWHart);
    matFilesWHart = dir(fullfile(dataDirWHart, '*.mat'));
            assignin('base', 'matFilesWHart', matFilesWHart);
    filePathsWHart = fullfile({matFilesWHart.folder},{matFilesWHart.name});
            assignin('base', 'filePathsWHart', filePathsWHart);
    dsWHart = signalDatastore(filePathsWHart);
            assignin('base', 'dsWHart', dsWHart);
