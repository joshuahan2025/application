classdef BackgroundMasksProcess < SegmentationProcess
  %INHERITANCE OF SEGMENTATIONPROCESS IS TEMPORARY - NEED TO MOVE TO OWN CLASS. HLE  
    methods(Access = public)
        
        function obj = BackgroundMasksProcess(owner,funParams)
            if nargin == 0
                super_args = {};
            else
                nChan = numel(owner.channelPath_);
                
                super_args{1} = owner;
                super_args{2} = 'Background Mask Creation';
                super_args{3} = @createMovieBackgroundMasksNEW;                               
                
                if nargin < 2 || isempty(funParams)                                       
                    
                    %----Defaults----%
                    funParams.OutputDirectory = ...
                        [owner.outputDirectory_  filesep 'BackgroundMasks'];                       
                    funParams.ChannelIndex = 1:nChan; %Default is to attempt to creat background masks for all channels
                    funParams.GrowthRadius = 20;
                    funParams.BatchMode = false;                                              
                end
                %Make sure the input parameters are legit??
                super_args{4} = funParams;                    
            end
            
            obj = obj@SegmentationProcess(super_args{:});
            
        end        
    end
end