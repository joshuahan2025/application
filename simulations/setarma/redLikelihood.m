function redLikeliV = redLikelihood(param,arOrder,maOrder,traj)
%REDLIKELIHOOD calculates the reduced likelihood of the fit of an ARMA model to observed data
%
%SYNOPSIS redLikeliV = redLikelihood(param,arOrder,maOrder,traj)
%
%INPUT  param   : Set of parameters in ARMA model (concat. of arParam and maParam)
%       arOrder : Order of autoregressive part of process.
%       maOrder : Order of moving average part of process.
%       traj    : Observed trajectory.    
%
%OUTPUT redLikeliV: Value of reduced likelihood.
%
%Khuloud Jaqaman, February 2004

%check if correct number of arguments were used when function was called
if nargin ~= nargin('redLikelihood')
    disp('--redLikelihood: Incorrect number of input arguments!');
    errFlag  = 1;
    xPredicted = [];
    innovCoef = [];
    innovErr = [];
    return
end

%check input data
[nRow,nCol] = size(param);
if nRow ~= 1
    disp('--armaConst: "param" should be a row vector!');
    errFlag = 1;
end
if nCol ~= arOrder+maOrder
    disp('--armaConst: Wrong length of vector "param"!');
    errFlag = 1;
end

%distribute parameters
arParam = param(1:arOrder);
maParam = param(arOrder+1:end);

%get 1-step predictions of trajectory using innovations algorithm with
%the current parameters
[trajP,innovCoef,innovErr,errFlag] = innovPredict(traj,...
    arOrder,maOrder,arParam,maParam,0);
if errFlag
    error('redLikeliV: Could not predict trajectory!');
end

%relative square prediction error per time point
relError = (trajP-traj).^2./innovErr(1:end-1);

%reduced likelihood
redLikeliV = log(mean(relError)) + mean(log(innovErr(1:end-1)));
