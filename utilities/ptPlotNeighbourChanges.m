function ptPlotNeighbourChanges (radioButtons, imageName, savePath, xAxis, neighChangeStats, windowSize)
% ptPlotNeighbourChanges plots neighbour change info from MPM. 
%
% SYNOPSIS       ptPlotNeighbourChanges (imageName, savePath, xAxisNeigh, neighChangeStats, windowSize)
%
% INPUT          radioButtons : values of radiobuttons on the gui
%                imageName : Name that will be used as the plot title
%                savePath : directory where plots will be stored
%                xAxisNeigh : vector with x-axis values
%                neighChangeStats : vector with neighbourhood interactions
%                windowSize : size of the averaging window 
%                
% OUTPUT         None (plots are directly shown on the screen) 
%
% DEPENDENCIES   ptPlotNeighbourChanges  uses {nothing}
%                                  
%                ptPlotNeighbourhoodChanges is used by { PolyTrack_PP }
%
% Revision History
% Name                  Date            Comment
% --------------------- --------        --------------------------------------------------------
% Andre Kerstens        Sep 04          Initial version

% Fetch the input data
avgNbChange = neighChangeStats.avgNbChange;

% Calculate average values if we have to
if radioButtons.runningaverage    
    raAvgNbChange = movingAverage (avgNbChange, windowSize, 'median');
end

% Here's where the plotting starts
if ~radioButtons.donotshowplots

    % Generate the neighbour change plot (all cells)
    h_fig2 = figure('Name', imageName);

    % Draw a plot showing average velocity of all cells
    ymax = max (avgNbChange) + (0.1*max (avgNbChange));
    plot (xAxis, avgNbChange); 
        
    if radioButtons.runningaverage
        hold on; plot (xAxis, raAvgNbChange, 'r'); hold off;
    end
        
    title ('Avg Neighbour Interaction Change');
    xlabel ('Frames');
    ylabel ('Avg Neighbour Change');
    if length (xAxis) > 1
       axis ([xAxis(1) xAxis(end) 0 ymax]);
    else
       axis ([xAxis(1) xAxis(1)+1 0 ymax]);
    end

    % Save the figures in fig, eps and tif format  
    hgsave (h_fig2,[savePath filesep [imageName '_avgNeighbourChange.fig']]);
    print (h_fig2, [savePath filesep [imageName '_avgNeighbourChange.eps']],'-depsc2','-tiff');
    print (h_fig2, [savePath filesep [imageName '_avgNeighbourChange.tif']],'-dtiff');      
end

% Save CSV files
csvwrite ([savePath filesep imageName '_avgNeighbourInteractionChange.csv'], [xAxis ; avgNbChange]);

