function lftHist = getLifetimeHistogram(data, tracks, varargin)

ip = inputParser;
ip.CaseSensitive = false;
ip.addOptional('Nmax', data.movieLength-2);
ip.addParamValue('Cutoff_f', 4, @isscalar);
ip.addParamValue('Buffer', 5);
ip.parse(varargin{:});
Nmax = ip.Results.Nmax;
buffer = ip.Results.Buffer;
cutoff_f = ip.Results.Cutoff_f;

if isempty(tracks)
    load([data.source 'Tracking' filesep 'trackAnalysis.mat']);
end

% Apply cut-off
idx = [tracks.lifetime_s] >= cutoff_f*data.framerate;
tracks = tracks(idx);

% lifetime vector (seconds)
lifetimes_s = [tracks.lifetime_s];

%====================
% Track statistics
%====================
% Categories
% Ia)  Single tracks with valid gaps
% Ib)  Single tracks with invalid gaps
% Ic)  Single tracks cut at beginning or end
% Id)  Single tracks, persistent
% IIa) Compound tracks with valid gaps
% IIb) Compound tracks with invalid gaps
% IIc) Compound tracks cut at beginning or end
% IId) Compound tracks, persistent
if isfield(tracks, 'catIdx')
    idx_Ia = [tracks.catIdx]==1;
    idx_Ib = [tracks.catIdx]==2;
    idx_IIa = [tracks.catIdx]==5;
else
    validGaps = arrayfun(@(t) max([t.gapStatus 4]), tracks)==4;
    singleIdx = [tracks.nSeg]==1;
    vis = [tracks.visibility];
    
    idx_Ia = singleIdx & validGaps & vis==1;
    idx_Ib = singleIdx & ~validGaps & vis==1;
    idx_IIa = ~singleIdx & validGaps & vis==1;
end


% longest observable lifetime (in frames): N = movieLength-2*buffer
N = data.movieLength-2*buffer;
t = (cutoff_f:N)*data.framerate;
lftHist_Iab = hist(lifetimes_s(idx_Ia | idx_Ib), t);
lftHist_Ia = hist(lifetimes_s(idx_Ia), t);
lftHist_Ib = hist(lifetimes_s(idx_Ib), t);
lftHist_IIa = hist(lifetimes_s(idx_IIa), t);


% apply correction
% relative probabilities:
% P(obs. lifetime==1) = N
% P(obs. lifetime==N) = 1
% => weighting:
w = N./(N-cutoff_f+1:-1:1);
lftHist_Iab = lftHist_Iab .* w;
lftHist_Ia = lftHist_Ia .* w;
lftHist_Ib = lftHist_Ib .* w;
lftHist_IIa = lftHist_IIa .* w;


% Pad with trailing zeros
if N<Nmax
    lftHist_Iab = [lftHist_Iab zeros(1,Nmax-N)];
    lftHist_Ia = [lftHist_Ia zeros(1,Nmax-N)];
    lftHist_Ib = [lftHist_Ib zeros(1,Nmax-N)];
    lftHist_IIa = [lftHist_IIa zeros(1,Nmax-N)];
    t = (cutoff_f:Nmax)*data.framerate;
end

% Normalization
lftHist_Iab = lftHist_Iab / sum(lftHist_Iab) / data.framerate;
lftHist_Ia = lftHist_Ia / sum(lftHist_Ia) / data.framerate;
lftHist_Ib = lftHist_Ib / sum(lftHist_Ib) / data.framerate;
lftHist_IIa = lftHist_IIa / sum(lftHist_IIa) / data.framerate;

lftHist.t = t;
lftHist.Ia = lftHist_Ia;
lftHist.Ib = lftHist_Ib;
lftHist.Iab = lftHist_Iab;
lftHist.IIa = lftHist_IIa;

