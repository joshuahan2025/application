function [arParam,trajP,noiseSigma,errFlag] = arLsGapEstim(traj,arOrder,arParam0)
%ARLSGAPESTIM estimates parameters of an AR model when there are missing points
%
%SYNOPSIS [arParam,trajP,noiseSigma,errFlag] = arLsGapEstim(traj,arOrder)
%
%INPUT  traj    : Trajectory to be modeled (with measurement uncertainty).
%                 Missing points should be indicated with Inf.
%       arOrder : Order of proposed AR model.
%       arParam0: Initial value of parameters.
%
%OUTPUT arParam   : Estimated parameters in model.
%       trajP     : Measurement error-free predicted trajectory.
%       noiseSigma: Estimated standard deviation of white noise.
%       errFlag   : 0 if function executes normally, 1 otherwise.
%
%Khuloud Jaqaman, February 2004

errFlag = 0;

%check if correct number of arguments were used when function was called
if nargin ~= nargin('arLsGapEstim')
    disp('--arLsGapEstim: Incorrect number of input arguments!');
    errFlag  = 1;
    arParam = [];
    return
end

%check input data
if arOrder < 1
    disp('--arLsGapEstim: Variable "arOrder" should be >= 1!');
    errFlag = 1;
end
[trajLength,nCol] = size(traj);
if trajLength < 5*arOrder
    disp('--arLsGapEstim: Length of trajectory should be at least 5 times larger than model order!');
    errFlag = 1;
end
if nCol ~= 2
    disp('--arLsGapEstim: "traj" should have one column for measurement and one for measurement uncertainty!');
    errFlag = 1;
end
[nRow,nCol] = size(arParam0)
if nRow ~= 1
    disp('--arLsGapEstim: "arParam0" should be a row vector!');
    errFlag = 1;
else
    if nCol ~= arOrder
        disp('--arLsGapEstim: Wrong length of "arParam0"!');
        errFlag = 1;
    end
    r = abs(roots([-arParam0(end:-1:1) 1]));
    if ~isempty(find(r<=1))
        disp('--arLsGapEstim: Causality requires the polynomial defining the autoregressive part of the model not to have any zeros for z <= 1!');
        errFlag = 1;
    end
end
if errFlag
    disp('--arLsGapEstim: please fix input data!');
    return
end
    
%initial set of AR parameters and error-free measurements
unknown0 = [arParam0'; traj(:,1)];
indx = find(unknown0 == Inf); %find missing points
indxLow = indx(find(indx <= 2*arOrder)); %missing points at times <= arOrder
indx = indx(find(indx > 2*arOrder)); %missing points at times > arOrder
for i = indxLow %fill missing points at times <= arOrder
    unknown0(i) = arParam0(1:i-arOrder-1)*unknown0(i-1:-1:arOrder+1);
end
for i = indx %fill missing points at times > arOrder
    unknown0(i) = arParam0*unknown0(i-1:-1:i-arOrder);
end
    
%define optimization options.
options = optimset('Display','iter');

%minimize the sum of square errors to get best set of parameters.
[unkowns,minFunc,exitFlag,output] = fmincon(@sumSquareErr,unkown0,[],[],[],[],...
    [-10*ones(arOrder,1); -Inf*ones(trajLength,1)],[10*ones(arOrder,1); Inf*ones(trajLength,1)],...
    [],options,arOrder,traj);

%assign parameters obtained through minimization
arParam = params(1:arOrder);
maParam = params(arOrder+1:end);

%check for causality of estimated model
r = abs(roots([-arParam0(end:-1:1) 1]));
if ~isempty(find(r<=1))
    disp('--innovPredict: Warning: Predicted model not causal!');
    errFlag = 1;
    noiseSigma = [];
    return
end
 
trajWithErr = [traj(arOder+1:end,1); traj];

