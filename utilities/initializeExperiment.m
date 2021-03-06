function initializeExperiment(expname, myname)
    fprintf('Initializing experiment %s\n', expname);

    parseRawDataFiles(expname);
    
    projFolder = makeTempFolderForExperiment(expname);

    addRecordedByToProject(projFolder, myname);
    correctAnglesForProject(projFolder);
    
    LabDataGUI(projFolder);
end