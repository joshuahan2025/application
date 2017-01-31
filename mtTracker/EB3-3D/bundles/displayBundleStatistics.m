function [handles,hFig]= displayBundleStatistics(varargin)
%Plot and compare building 
ip = inputParser;
ip.CaseSensitive = false;
ip.KeepUnmatched = true;
ip.addParameter('kinBundle',[]);
ip.addParameter('kinBundleName',[]);
ip.addParameter('plotHandleArray',[]);
ip.addParameter('bundleMTRange',[10 35]);
ip.parse(varargin{:});
p=ip.Results;

%%
kinTracksCell=p.kinBundle;

if(isempty(p.plotHandleArray))
    [handles,~,hFig]=setupFigure(1,2,2,'AspectRatio',1,'AxesWidth',4);
else
    handles=p.plotHandleArray;
end

%% Number of fiber at each given frame. 
fiberCount=zeros(length(kinTracksCell),kinTracksCell{1}.numTimePoints);
kinetochoreCount=zeros(length(kinTracksCell),kinTracksCell{1}.numTimePoints);

for i=1:length(kinTracksCell)
    kinTracks=kinTracksCell{i};
    for k=1:length(kinTracks)
        fiberCount(i,kinTracks(k).f)=fiberCount(i,kinTracks(k).f)+double(length(kinTracks(k).fiber));
        kinetochoreCount(i,kinTracks(k).f)=kinetochoreCount(i,kinTracks(k).f)+1;
    end
end
plot(handles(1),linspace(0,kinTracksCell{1}.numTimePoints,kinTracksCell{1}.numTimePoints), fiberCount./kinetochoreCount);
xlabel(handles(1),'Frame count');
ylabel(handles(1),'avg MT per bundle');
ylim(handles(1),p.bundleMTRange);
legend(handles(1),p.kinBundleName);


%%
plot(handles(2),linspace(0,kinTracks.numTimePoints,kinTracks.numTimePoints), kinetochoreCount);
xlabel(handles(2),'Frame count');
ylabel(handles(2),'kinetochore Count');


%%  Kinetochore fiber evolution with time
% Function if Kin average temporal location
% fiberTime=[];
% for i=1:length(kinTracksCell)
%     kinTracks=kinTracksCell{i};
%     kinFiberMask=arrayfun(@(k) isempty(k.fiber),kinTracks);
%     kinTrajTime=arrayfun(@(k) (k.f(ceil(end/2))),kinTracks);
%     fiberTime=[fiberTime; kinTrajTime(kinFiberMask)];
% end
% subplot(1,2,1);
% hist(fiberTime,150);
% legend(p.kinBundleName);


%% Timing of each microtubule
% kinTracks=kinTracksCell{1};
% numTimePoint=zeros(1,2*kinTracks.numTimePoints);
% diffTimingCell=cell(1,length(kinTracks));
% endTimingCell=cell(1,length(kinTracks));
% 
% for k=1:length(kinTracks)
%     bundledMTs=kinTracks(k).catchingMT(kinTracks(k).fiber>0);
%     diffTiming=zeros(1,length(bundledMTs)-2);
%     endTiming=zeros(1,length(bundledMTs)-2);
%     for mtIdx=2:(length(bundledMTs)-1)
%         diffTiming(mtIdx)= bundledMTs(mtIdx+1).t(end) - bundledMTs(mtIdx).t(end);
%         endTiming(mtIdx)= bundledMTs(mtIdx).t(end) - bundledMTs(1).t(end);      
%     end
%     numTimePoint(diffTiming+kinTracks.numTimePoints)=numTimePoint(diffTiming+kinTracks.numTimePoints)+1;
%     diffTimingCell{k}=diffTiming;
%     endTimingCell{k}=endTiming;
% end

% h=setupFigure(1,2,2);
% diffTiming=cell2mat(diffTimingCell);
% endTiming=cell2mat(endTimingCell);
% scatter(h(1),endTiming,diffTiming);
% H=h(1);
% xlim(H,[-5 20])
% xlabel(H,'Frame count after first bundled MT');
% ylabel(H,'Frame count until next bundled MT');
% 
% H=h(2);
% plot(H,linspace(-kinTracks.numTimePoints*MD.timeInterval_,kinTracks.numTimePoints*MD.timeInterval_,2*kinTracks.numTimePoints), numTimePoint);
% xlim(H,[-5 20])
% xlabel(H,'Relative Frame count');
% ylabel(H,'frequency');
% print([outputDirPlot 'timing.png'],'-dpng');
% print([outputDirPlot 'timing.eps'],'-depsc');

