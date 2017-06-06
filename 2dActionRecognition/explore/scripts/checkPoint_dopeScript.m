export_dir = '/work/bioinformatics/shared/dope/export/';
Save_dir = '/work/bioinformatics/shared/dope/data/OMETIFF/';
OriginalDataSet = '/work/bioinformatics/shared/dope/data/OMETIFF/Gen2n3_May15_ALL.mat';

listMats = {};
% loadMat = true;
% i = 1;
% 
% while loadMat == true
%     choice = questdlg('Load annotations .MAT file?', ...
%                       'Load MAT file','Yes','No','No');
%     if string(choice) == 'Yes'
%         % saveFolder = uigetdir(export_dir, 'Directory to from which to load annotation .mat file');
%         [filename, pathname] = ...
%          uigetfile({'*.mat'},'.MAT dopeANnotator File Selector', [export_dir '/example_dopeAnnotator_date.mat']);
%         listMats{i} = [pathname filesep filename];       
%         i = i + 1;
%     else
%         loadMat = false;
%     end
% end

% Load sets of previously completed annotation sessions
% load([export_dir '/backup_dopeAnnotator_output_22May2017_0157-anevarez.mat']);
% load([export_dir '/backup_dopeAnnotator_output_01Jun2017_0139-anevarez.mat']);

listMats{1} = [export_dir '/backup_dopeAnnotator_output_22May2017_0157-anevarez.mat'];
listMats{2} = [export_dir '/backup_dopeAnnotator_output_01Jun2017_0139-anevarez.mat'];

doneKeys = {};
listAnnos = {};
i = 1;
for iMat = listMats
    load(iMat{:});
    doneAnnotations = cellAnnotations;
    listAnnos{i} = doneAnnotations;
    tempDoneKeys = {doneAnnotations.cellData.key};
    doneKeys = union(doneKeys, tempDoneKeys);
    i = 1 + i;
end

% Grab all keys info 
load(OriginalDataSet);
cellDataSetAll = cellDataSet;
cellMat = cell2mat(cellDataSetAll);
allCell_Keys = {cellMat.key};
allCellKeys = unique(allCell_Keys);

remainingKeys = setxor(allCellKeys, doneKeys);
subSetData = cell(1, length(remainingKeys));

j = 1;
for i = 1:length(allCellKeys)
   if ismember({cellDataSetAll{i}.key}, remainingKeys)
    subSetData{j} = cellDataSetAll{i};
    j = j + 1;
   end
end

cellDataSet = subSetData;
checkPointDateStr = ['_dopeCheckPoint_Anno' char(datetime('now','Format','ddMMMyyyy_hhmm'))];

exportVarName = ['dopeCheckPoint_Anno' char(datetime('now','Format','ddMMMyyyy_hhmm'))];
saveFolder = uigetdir(Save_dir, 'Directory to save annotation .mat file');
varname = inputdlg('Input where to export modified cellData to ....', ' ',1, {exportVarName});


save([fullfile([saveFolder filesep varname{:}]) '.mat'],...
    'cellDataSet', 'annotationSet','checkPointDateStr',...
    'allCellKeys','doneKeys','listMats','remainingKeys','-v7.3');