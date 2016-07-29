function [dataTable,allData,meas] = extractFeatureNA(tracksNA,idGroupSelected, normalizationMethods)
if nargin<3
    normalizationMethods=1;
end
% normalizationMethods=1 means no-normalization
% normalizationMethods=2 means normalization with maxIntensity 
% normalizationMethods=3 means normalization with maxIntensity and
% maxEdgeAdvance
% normalizationMethods=4 means normalization with maxIntensity and
% maxEdgeAdvance*pixSize
% normalizationMethods=5 means normalization with maxIntensity and
% maxEdgeAdvance*pixSize and lifeTime in frames.
% normalizationMethods=6 means normalization with maxIntensity and
% maxEdgeAdvance and lifeTime in sec (using tInterval).
% normalizationMethods=7  means normalization per each feature min and max

%#1
maxIntensityNAs = arrayfun(@(x) nanmax(x.ampTotal),tracksNA); %this should be high for group 2

% startingIntensityNAs = arrayfun(@(x) x.ampTotal(x.startingFrameExtra),tracksNA); %this should be high for group 2 and low for both g1 and g2
endingIntensityNAs = arrayfun(@(x) x.ampTotal(x.endingFrameExtra),tracksNA); %this should be high for group 2

decayingIntensityNAs = maxIntensityNAs-endingIntensityNAs; % this will differentiate group 1 vs group 2.
%#2
edgeAdvanceDistNAs = arrayfun(@(x) x.edgeAdvanceDist(x.endingFrameExtra),tracksNA); %this should be also low for group 3
%#3
advanceDistNAs = arrayfun(@(x) x.advanceDist(x.endingFrameExtra),tracksNA); %this should be also low for group 3
%#4
lifeTimeNAs = arrayfun(@(x) x.lifeTime,tracksNA); %this should be low for group 6
%#5
meanIntensityNAs = arrayfun(@(x) nanmean(x.amp),tracksNA); %this should be high for group 2
%#6
distToEdgeFirstNAs = arrayfun(@(x) x.distToEdge(x.startingFrameExtra),tracksNA); %this should be low for group 3
%#7
startingIntensityNAs = arrayfun(@(x) x.ampTotal(x.startingFrameExtra),tracksNA); %this should be high for group 5 and low for both g1 and g2
%#8
distToEdgeChangeNAs = arrayfun(@(x) x.distToEdgeChange,tracksNA); %this should be low for group 3 and group 5
%#9
distToEdgeLastNAs = arrayfun(@(x) x.distToEdge(x.endingFrameExtra),tracksNA); %this should be low for group 3 and group 7
%#10
edgeAdvanceDistFirstChangeNAs =  arrayfun(@(x) x.advanceDistChange2min(min(x.startingFrameExtra+30,x.endingFrameExtra)),tracksNA); %this should be negative for group 5 and for group 7
%#11
edgeAdvanceDistLastChangeNAs =  arrayfun(@(x) x.advanceDistChange2min(x.endingFrameExtra),tracksNA); %this should be negative for group 5 and for group 7
%#12
maxEdgeAdvanceDistChangeNAs =  arrayfun(@(x) x.maxEdgeAdvanceDistChange,tracksNA); %This is to see if 
% this adhesion once had fast protruding edge, thus crucial for
% distinguishing group 3 vs 7. For example, group 7 will show low value for
% this quantity because edge has been stalling for entire life time.

% Some additional features - will be commented out eventually
% asymTracks=arrayfun(@(x) asymDetermination([x.xCoord(logical(x.presence))', x.yCoord(logical(x.presence))']),tracksNA);
% MSDall=arrayfun(@(x) sum((x.xCoord(logical(x.presence))'-mean(x.xCoord(logical(x.presence)))).^2+...
%     (x.yCoord(logical(x.presence))'-mean(x.yCoord(logical(x.presence)))).^2),tracksNA());
%% All the maxima
% maxIntensity = max(maxIntensityNAs(:)); %Now I started to normalize these things SH 16/07/06
% maxEdgeAdvance = max(edgeAdvanceDistNAs(:));
% edgeAdvanceDistNAs = edgeAdvanceDistNAs/maxEdgeAdvance;
% maxIntensityNAs = maxIntensityNAs/maxIntensity; 
endingIntensityNAs = endingIntensityNAs; %/maxIntensity; % normalizing

% MSDrate = MSDall./lifeTimeNAs;
advanceSpeedNAs = advanceDistNAs./lifeTimeNAs; %this should be also low for group 3
edgeAdvanceSpeedNAs = edgeAdvanceDistNAs./lifeTimeNAs; %this should be also low for group 3
% relMovWRTEdge = distToEdgeChangeNAs./lifeTimeNAs;
% decayingIntensityNAs = decayingIntensityNAs/maxIntensity;
% advanceDistNAs = advanceDistNAs/maxEdgeAdvance;
% meanIntensityNAs = meanIntensityNAs/maxIntensity;
% startingIntensityNAs = startingIntensityNAs/maxIntensity;
% edgeAdvanceDistFirstChangeNAs = edgeAdvanceDistFirstChangeNAs/maxEdgeAdvance;
% edgeAdvanceDistLastChangeNAs = edgeAdvanceDistLastChangeNAs/maxEdgeAdvance;

switch normalizationMethods
    case 1
        disp('Use unnormalized')
    case 2 % normalizationMethods=2 means normalization with maxIntensity 
    case 3 % normalizationMethods=2 means normalization with maxIntensity and maxEdgeAdvance
    case 4 % normalizationMethods=2 means normalization with maxIntensity and maxEdgeAdvance*pixSize
    case 5 % normalizationMethods=2 means normalization with maxIntensity and maxEdgeAdvance*pixSize
    case 6 % normalizationMethods=2 means normalization with maxIntensity 
    case 7 % normalizationMethods=2 means normalization with maxIntensity 
       
end
%% Building classifier...
if nargin>1
    nGroups = numel(idGroupSelected);
    meas = [];
    nTotalG = 0;
    nG = zeros(nGroups,1);
    for ii=1:nGroups
%         if numel(idGroupSelected{ii})>=5
            meas = [meas; decayingIntensityNAs(idGroupSelected{ii}) edgeAdvanceSpeedNAs(idGroupSelected{ii}) advanceSpeedNAs(idGroupSelected{ii}) ...
                 lifeTimeNAs(idGroupSelected{ii}) meanIntensityNAs(idGroupSelected{ii}) distToEdgeFirstNAs(idGroupSelected{ii}) ...
                 startingIntensityNAs(idGroupSelected{ii}) distToEdgeChangeNAs(idGroupSelected{ii}) distToEdgeLastNAs(idGroupSelected{ii}) ...
                 edgeAdvanceDistFirstChangeNAs(idGroupSelected{ii}) edgeAdvanceDistLastChangeNAs(idGroupSelected{ii}) ...
                 maxEdgeAdvanceDistChangeNAs(idGroupSelected{ii})];
            nCurG=length(idGroupSelected{ii}); %sum(idGroupSelected{ii}); %
            nG(ii)=nCurG;
            nTotalG = nTotalG+nCurG;
%         else
%             disp(['The quantity of the labels for group ' num2str(ii) ' is less than 5. Skipping this group for training...'])
%             nG(ii)=0;
%         end
    end
    % meas = [decayingIntensityNAs(idGroup1Selected) edgeAdvanceSpeedNAs(idGroup1Selected) advanceSpeedNAs(idGroup1Selected) ...
    %      lifeTimeNAs(idGroup1Selected) meanIntensityNAs(idGroup1Selected) distToEdgeFirstNAs(idGroup1Selected) ...
    %      startingIntensityNAs(idGroup1Selected) distToEdgeChangeNAs(idGroup1Selected) distToEdgeLastNAs(idGroup1Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup1Selected) maxEdgeAdvanceDistChangeNAs(idGroup1Selected);
    %      decayingIntensityNAs(idGroup2Selected) edgeAdvanceSpeedNAs(idGroup2Selected) advanceSpeedNAs(idGroup2Selected) ...
    %      lifeTimeNAs(idGroup2Selected) meanIntensityNAs(idGroup2Selected) distToEdgeFirstNAs(idGroup2Selected) ...
    %      startingIntensityNAs(idGroup2Selected) distToEdgeChangeNAs(idGroup2Selected) distToEdgeLastNAs(idGroup2Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup2Selected) maxEdgeAdvanceDistChangeNAs(idGroup2Selected);
    %      decayingIntensityNAs(idGroup3Selected) edgeAdvanceSpeedNAs(idGroup3Selected) advanceSpeedNAs(idGroup3Selected) ...
    %      lifeTimeNAs(idGroup3Selected) meanIntensityNAs(idGroup3Selected) distToEdgeFirstNAs(idGroup3Selected) ...
    %      startingIntensityNAs(idGroup3Selected) distToEdgeChangeNAs(idGroup3Selected) distToEdgeLastNAs(idGroup3Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup3Selected) maxEdgeAdvanceDistChangeNAs(idGroup3Selected);
    %      decayingIntensityNAs(idGroup4Selected) edgeAdvanceSpeedNAs(idGroup4Selected) advanceSpeedNAs(idGroup4Selected) ...
    %      lifeTimeNAs(idGroup4Selected) meanIntensityNAs(idGroup4Selected) distToEdgeFirstNAs(idGroup4Selected) ...
    %      startingIntensityNAs(idGroup4Selected) distToEdgeChangeNAs(idGroup4Selected) distToEdgeLastNAs(idGroup4Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup4Selected) maxEdgeAdvanceDistChangeNAs(idGroup4Selected);
    %      decayingIntensityNAs(idGroup5Selected) edgeAdvanceSpeedNAs(idGroup5Selected) advanceSpeedNAs(idGroup5Selected) ...
    %      lifeTimeNAs(idGroup5Selected) meanIntensityNAs(idGroup5Selected) distToEdgeFirstNAs(idGroup5Selected) ...
    %      startingIntensityNAs(idGroup5Selected) distToEdgeChangeNAs(idGroup5Selected) distToEdgeLastNAs(idGroup5Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup5Selected) maxEdgeAdvanceDistChangeNAs(idGroup5Selected);
    %      decayingIntensityNAs(idGroup6Selected) edgeAdvanceSpeedNAs(idGroup6Selected) advanceSpeedNAs(idGroup6Selected) ...
    %      lifeTimeNAs(idGroup6Selected) meanIntensityNAs(idGroup6Selected) distToEdgeFirstNAs(idGroup6Selected) ...
    %      startingIntensityNAs(idGroup6Selected) distToEdgeChangeNAs(idGroup6Selected) distToEdgeLastNAs(idGroup6Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup6Selected) maxEdgeAdvanceDistChangeNAs(idGroup6Selected);
    %      decayingIntensityNAs(idGroup7Selected) edgeAdvanceSpeedNAs(idGroup7Selected) advanceSpeedNAs(idGroup7Selected) ...
    %      lifeTimeNAs(idGroup7Selected) meanIntensityNAs(idGroup7Selected) distToEdgeFirstNAs(idGroup7Selected) ...
    %      startingIntensityNAs(idGroup7Selected) distToEdgeChangeNAs(idGroup7Selected) distToEdgeLastNAs(idGroup7Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup7Selected) maxEdgeAdvanceDistChangeNAs(idGroup7Selected);
    %      decayingIntensityNAs(idGroup8Selected) edgeAdvanceSpeedNAs(idGroup8Selected) advanceSpeedNAs(idGroup8Selected) ...
    %      lifeTimeNAs(idGroup8Selected) meanIntensityNAs(idGroup8Selected) distToEdgeFirstNAs(idGroup8Selected) ...
    %      startingIntensityNAs(idGroup8Selected) distToEdgeChangeNAs(idGroup8Selected) distToEdgeLastNAs(idGroup8Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup8Selected) maxEdgeAdvanceDistChangeNAs(idGroup8Selected);
    %      decayingIntensityNAs(idGroup9Selected) edgeAdvanceSpeedNAs(idGroup9Selected) advanceSpeedNAs(idGroup9Selected) ...
    %      lifeTimeNAs(idGroup9Selected) meanIntensityNAs(idGroup9Selected) distToEdgeFirstNAs(idGroup9Selected) ...
    %      startingIntensityNAs(idGroup9Selected) distToEdgeChangeNAs(idGroup9Selected) distToEdgeLastNAs(idGroup9Selected) ...
    %      edgeAdvanceDistLastChangeNAs(idGroup9Selected) maxEdgeAdvanceDistChangeNAs(idGroup9Selected)];
    % meas = [advanceDistNAs(idGroup4Selected) edgeAdvanceDistNAs(idGroup4Selected);
    %     advanceDistNAs(nonGroup24Selected) edgeAdvanceDistNAs(nonGroup24Selected)];
    species = cell(nTotalG,1);
    for ii=1:nTotalG
        if ii<=nG(1)
            species{ii} = 'Group1';
        elseif ii<=sum(nG(1:2))
            species{ii} = 'Group2';
        elseif ii<=sum(nG(1:3))
            species{ii} = 'Group3';
        elseif ii<=sum(nG(1:4))
            species{ii} = 'Group4';
        elseif ii<=sum(nG(1:5))
            species{ii} = 'Group5';
        elseif ii<=sum(nG(1:6))
            species{ii} = 'Group6';
        elseif ii<=sum(nG(1:7))
            species{ii} = 'Group7';
        elseif ii<=sum(nG(1:8))
            species{ii} = 'Group8';
        elseif ii<=nTotalG
            species{ii} = 'Group9';
        end
    end
    dataTable = table(meas(:,1),meas(:,2),meas(:,3),meas(:,4),meas(:,5),meas(:,6),meas(:,7),meas(:,8),meas(:,9),meas(:,10),meas(:,11),meas(:,12),species,...
        'VariableNames',{'decayingIntensityNAs', 'edgeAdvanceSpeedNAs', 'advanceSpeedNAs', ...
        'lifeTimeNAs', 'meanIntensityNAs', 'distToEdgeFirstNAs', ...
        'startingIntensityNAs', 'distToEdgeChangeNAs', 'distToEdgeLastNAs', 'edgeAdvanceDistFirstChangeNAs',...
        'edgeAdvanceDistLastChangeNAs','maxEdgeAdvanceDistChangeNAs','Group'});
else
    dataTable = [];
end
allData = [decayingIntensityNAs edgeAdvanceSpeedNAs advanceSpeedNAs ...
     lifeTimeNAs meanIntensityNAs distToEdgeFirstNAs ...
     startingIntensityNAs distToEdgeChangeNAs distToEdgeLastNAs ...
     edgeAdvanceDistFirstChangeNAs edgeAdvanceDistLastChangeNAs maxEdgeAdvanceDistChangeNAs];


    