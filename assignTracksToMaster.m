
function idx = assignTracksToMaster(slaveTracks, masterTracks, varargin)

ip = inputParser;
ip.CaseSensitive = false;
ip.addRequired('slaveTracks', @isstruct);
ip.addRequired('masterTracks');
ip.addParamValue('MinOverlap', 1, @isscalar);
ip.addParamValue('MaxDistance', 5, @isscalar);
ip.parse(slaveTracks, masterTracks, varargin{:});
minOverlap = ip.Results.MinOverlap;
R = ip.Results.MaxDistance;

% mean positions
mMeans = arrayfun(@(t) [mean(t.x(1,:)) mean(t.y(1,:))], masterTracks, 'UniformOutput', false);
mMeans = vertcat(mMeans{:});
sMeans = arrayfun(@(t) [mean(t.x(1,:)) mean(t.y(1,:))], slaveTracks, 'UniformOutput', false);
sMeans = vertcat(sMeans{:});

idx = KDTreeBallQuery(mMeans, sMeans, R);

% parse each set of assignments and check for overlap
nm = numel(masterTracks);
for k = 1:nm
    if ~isempty(idx{k})
        overlap = min([slaveTracks(idx{k}).end], masterTracks(k).end) - ...
            max([slaveTracks(idx{k}).start], masterTracks(k).start) + 1;
        idx{k} = idx{k}(overlap>=minOverlap);
    end
end
        