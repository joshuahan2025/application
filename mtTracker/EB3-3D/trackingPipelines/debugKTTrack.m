function debugKTTrack()
%% a Script/function for systematic refinement of KT tracks

%% loading timing based movie table
allMovieToAnalyse=readtable('/project/bioinformatics/Danuser_lab/externBetzig/analysis/proudot/anaProject/phaseProgression/analysis/movieTables/allMovieToAnalyse.xlsx');
blurrPoleCheckedMoviesIdx=(~(allMovieToAnalyse.blurred|allMovieToAnalyse.doubleCell));
blurrPoleCheckedMovies=allMovieToAnalyse(blurrPoleCheckedMoviesIdx,:);
goodAndOKSNRIdx=ismember(allMovieToAnalyse.EB3SNR,'OK')|ismember(allMovieToAnalyse.EB3SNR,'Good');
blurrPoleCheckedMoviesHighSNR=allMovieToAnalyse(goodAndOKSNRIdx&blurrPoleCheckedMoviesIdx,:);

% Loading a selected cell of interest
MD=MovieData.loadMatFile(blurrPoleCheckedMovies.analPath{ismember(blurrPoleCheckedMovies.Cell,'cell1_12_halfvol2time')&ismember(blurrPoleCheckedMovies.Setup_min_,'1')});

%% Debug Crop
if(isempty(MD.findProcessTag('Crop3D_shorter_Amira_comp','safeCall',true)))
	MDCropRepair=crop3D(MD,(MD.getChannel(1).loadStack(1)),'keepFrame',1:5,'name','shorter_Amira_comp');
	MDCropRepair.sanityCheck();
	MD.save();
else
	MDCropRepair=MovieData.loadMatFile(MD.findProcessTag('Crop3D_shorter_Amira_comp').outFilePaths_{1});
end

MD=MDCropRepair;
outputFolder='/project/bioinformatics/Danuser_lab/externBetzig/analysis/proudot/anaProject/phaseProgression/analysis/debugCell12-crop/';

%%
buildAndProjectSpindleRef(MD);

pack=MD.searchPackageName('trackKT','selectIdx','last');
%pack.eraseProcess(3)
trackKT(MD,'package',pack,'debug',true, ...
                         'dynROIView',MD.searchPackageName('dynROIView','selectIdx','last'));
pack=MD.searchPackageName('trackKT','selectIdx','last');
MD.save();
%printProcMIPArray(singleTrackOverlays,[outputFolder 'SingleTracks'],'MIPIndex',4,'MIPSize',400);

tic
processTrackKT=TrackingProcess(MD, [MD.outputDirectory_ filesep 'KT' filesep 'debug'],UTrackPackage3D.getDefaultTrackingParams(MD,[MD.outputDirectory_ filesep 'KT' filesep 'debug']));
MD.addProcess(processTrackKT);    
funParams = processTrackKT.funParams_;
[gapCloseParam,costMatrices,kalmanFunctions,probDim,verbose]=debugKinTrackingParam();
funParams.gapCloseParam=gapCloseParam;
funParams.costMatrices=costMatrices;
funParams.kalmanFunctions=kalmanFunctions;
funParams.probDim=probDim;
processTrackKT.setPara(funParams);
paramsIn.ChannelIndex=2;
paramsIn.DetProcessIndex=pack.getProcess(2).getIndex();
processTrackKT.run(paramsIn);
newPack=GenericPackage([pack.processes_(1:2) {processTrackKT} pack.processes_([4])]); 
trackKT(MD,'name','debug','packPID',1610,'debug',true, ...
                                'dynROIView', MD.searchPackageName('dynROIView','selectIdx','last'), ...
                                'package',newPack);
packDebug=MD.searchPackageName('trackKTdebug_backup');
toc
MD.save();

%printProcMIPArray([singleTrackOverlays,singleTrackOverlaysDebug],[outputFolder 'SingleTracksDebug'],'MIPIndex',4,'MIPSize',400);


printProcMIPArray({pack.getProcess(6),packDebug.getProcess(6)},[outputFolder 'tracks'],'MIPIndex',4,'MIPSize',800,'maxWidth',2000);
%printProcMIPArray({pack.getProcess(4),packDebug.getProcess(4)},[outputFolder 'detection'],'MIPIndex',4,'MIPSize',800,'maxWidth',2000);
