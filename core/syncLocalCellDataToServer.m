function [] = syncLocalCellDataToServer()
global ANALYSIS_FOLDER;

if exist([filesep 'Volumes' filesep 'SchwartzLab'  filesep 'CellDataMaster']) == 7
    cellDataMasterFolder = [filesep 'Volumes' filesep 'SchwartzLab'  filesep 'CellDataMaster'];
else
    disp('Could not connect to CellDataMaster');
    return;
end

%get all cellData names in local cellData folder
cellDataNames = ls([ANALYSIS_FOLDER filesep 'cellData' filesep '*.mat']);
cellDataNames = strsplit(cellDataNames); %this will be different on windows - see doc ls
cellDataNames = sort(cellDataNames);

cellDataBaseNames = cell(length(cellDataNames), 1);

for i=1:length(cellDataNames)
    [~, basename, ~] = fileparts(cellDataNames{i});
    if ~isempty(basename)
        fileinfo = dir([ANALYSIS_FOLDER 'cellData' filesep basename '.mat']);
        localModDate = fileinfo.datenum;
        try
            fileinfo = dir([filesep 'Volumes' filesep 'SchwartzLab'  filesep 'CellDataMaster'  filesep basename '.mat']);
            serverModDate = fileinfo.datenum;
        catch
            serverModDate = 0;
        end
        if localModDate > serverModDate + 60 %more than 60 seconds newer
           fprintf('Found newer local copy of %s, by %d sec. Copying to server...', basename, round(localModDate - serverModDate));
           load([ANALYSIS_FOLDER 'cellData' filesep basename '.mat']); %loads cellData
           saveAndSyncCellData(cellData);
        end
    end
end

