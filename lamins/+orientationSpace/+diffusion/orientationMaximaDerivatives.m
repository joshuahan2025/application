function [ dnm_dKn ] = orientationMaximaDerivatives( rho, lm, K, derivOrder )
%ORIENTATIONMAXIMADERIVATIVES Find the K derivatives of local maxima
%
% INPUT
% rho - regularly spaced samples of orientation response at K,
%       nSamples x numel(K)
% lm  - orientation local maxima of rho, via interpft_extrema
%       maxNLocalMaxima x numel(K)
% K - angular order, vector of K values correpsond to rho and lm
% derivOrder - highest derivative desired
%
% OUTPUT
% derivatives
    
    % For period of 2*pi
    D = 2*pi^2;
    % For period of pi
    % D = pi^2/2;

%% Calculate derivative in terms of t
%t = 1./(2*K+1).^2;

% n = derivOrder
% m = theta_{m} (local maxima location)

rho_derivs = interpft1_derivatives(rho,lm,2:derivOrder*2+1);

[dnm_dtn,maximaDerivatives] = dqm_dtq(derivOrder,D,rho_derivs);
    
% if(derivOrder == 1)
% %     rho_derivs = interpft1_derivatives(rho,lm,[2 3]);
%     dnm_dtn = -D.*rho_derivs(:,:,2)./rho_derivs(:,:,1);
% else
% end

%% Calculate derivatives of t by K

n = shiftdim(1:derivOrder,-1);
dnt_dKn = factorial(n+1) .* (-2).^(n );
dnt_dKn = bsxfun(@times,dnt_dKn, ...
    bsxfun(@power,1./(2*K+1),n+2));
% keyboard

%% Translate derivative with respect to t to with respect to K

% if(derivOrder == 1)
% %     keyboard;
%     dnm_dKn = bsxfun(@times,dnm_dtn,dnt_dKn(:,:,1));
% else
%     dnm_dKn = dnm_dtn;
% end

dnm_dKn = translate_from_t_to_K(derivOrder,cat(3,maximaDerivatives{:}),K);


end

function deriv = total_dq_dtq_partial_dnrho_dmn(q,n,D,rho_derivs,maximaDerivatives)
    assert(q >= 0);
    assert(n > 0);
    if(n == 1)
        % Total derivative of 1st partial derivative with respect to
        % orientation. Always zero by definition of orientation local
        % maxima.
        deriv = 0;
%         fprintf('GET   total q=%d, n=%d\n',q,n);
%         fprintf('END total q=%d, n=%d\n',q,n);
        return;
    end
    if(q == 0)
        % No total derivative, answer is just the nth partial derivative with
        % respect to orientation
        deriv = rho_derivs(:,:,n-1);
%         fprintf('END total q=%d, n=%d\n',q,n);
%         fprintf('GET   total q=%d, n=%d\n',q,n);
        return;
    end
%     fprintf('START total q=%d, n=%d\n',q,n);

    deriv = 0;
    for l = 1:q
        binom = nchoosek(q-1,l-1);
%         deriv = deriv + binom.*total_dq_dtq_partial_dnrho_dmn(q-l,n+1,D,rho_derivs).*dqm_dtq(l,D,rho_derivs);
        deriv = deriv + binom.*total_dq_dtq_partial_dnrho_dmn(q-l,n+1,D,rho_derivs,maximaDerivatives).*maximaDerivatives{l};
    end
    deriv = deriv +  D * total_dq_dtq_partial_dnrho_dmn(q-1,n+2,D,rho_derivs,maximaDerivatives);
%     fprintf('END   total q=%d, n=%d\n',q,n);
end

function [deriv,maximaDerivatives] = dqm_dtq(q,D,rho_derivs,maximaDerivatives)
    % order of the partial derivative is 1
    % need rho_derivs up to 1+q*2;
%     fprintf('START dqm_dtq q=%d\n',q);
    assert(q > 0);
    n = 1;
    deriv = 0;
    if(nargin < 4)
        maximaDerivatives = cell(1,q);
        for l=1:q-1
            maximaDerivatives{l} = dqm_dtq(l,D,rho_derivs,maximaDerivatives);
        end
    end
    for l=1:q-1
        binom = nchoosek(q-1,l-1);
        deriv = deriv + binom.*total_dq_dtq_partial_dnrho_dmn(q-l,n+1,D,rho_derivs,maximaDerivatives).*maximaDerivatives{l};
    end
    deriv = deriv + D * total_dq_dtq_partial_dnrho_dmn(q-1,n+2,D,rho_derivs,maximaDerivatives);
    % Divide by second partial derivative with respect to orientation
    deriv = -deriv./rho_derivs(:,:,1);
    maximaDerivatives{q} = deriv;
%     fprintf('END dqm_dtq q=%d\n',q);
end

function tpm = total_partial_matrix()
end

function dqm_dKq = translate_from_t_to_K(q,dqm_dtq_v,K)
    %% Calculate Faa di Bruno coefficients
    part = partitions(q);
    faa_di_bruno = factorial(q);
    faa_di_bruno = faa_di_bruno./prod(bsxfun(@power,factorial(1:q),part).');
    faa_di_bruno = faa_di_bruno./prod(factorial(part).');
    %% Calculate order of the local maxima derivative
    derivOrder = sum(part.');
    %% Calculate derivatives of t with respect to K
    n = shiftdim(1:q,-1);
    dnt_dKn = factorial(n+1) .* (-2).^(n );
    dnt_dKn = bsxfun(@times,dnt_dKn, ...
        bsxfun(@power,1./(2*K+1),n+2));
    dnt_dKn_pow = bsxfun(@power,dnt_dKn,shiftdim(part.',-2));
    dnt_dKn_pow = prod(dnt_dKn_pow,4);
    dqm_dKq = bsxfun(@times,dnt_dKn_pow,shiftdim(faa_di_bruno,-1));
    dqm_dKq = bsxfun(@times,dqm_dKq,dqm_dtq_v(:,:,derivOrder));
    dqm_dKq = sum(dqm_dKq,3);
end

function dqm_dKq = translate_from_t_to_K_hard(q,dqm_dtq_v,K)
% Translate derivatives with respect to t to derivatives with respect to K
% Hardcoded version for efficiency
% q - scalar, order of the derivative with respect to K
% dqm_dtq - derivatives with respect to t
% K - 
    if(q < 7)
        % dtn_dkn = @(n) factorial(n+1) .* (-2).^(n );
        dnt_dKn = [-4,24,-192,1920,-23040,322560];
        qv = 1:q;
        dnt_dKn = dnt_dKn(qv).*(2*K+1).^(qv);
    else
        dqm_dKq = translate_from_t_to_K(q,dqm_dtq_v,K);
        return;
    end
    
    switch(q)
        case 1
            % partitions(1)
            % 
            % ans =
            % 
            %      1
            dqm_dKq = dqm_dtq_v(:,:,1) .* dnt_dKn(1);
        case 2
            % partitions(2)
            % 
            % ans =
            % 
            %      2     0
            %      0     1
            dqm_dKq = dqm_dtq_v(:,:,2).* dnt_dKn(1).^2 ... 
                    + dqm_dtq_v(:,:,1).* dnt_dKn(2);
        case 3
            % partitions(3)
            % 
            % ans =
            % 
            %      3     0     0
            %      1     1     0
            %      0     0     1
            dqm_dKq =   dqm_dtq_v(:,:,3) .* dnt_dKn(1).^3 ...
                    + 3*dqm_dtq_v(:,:,2) .* dnt_dKn(1)     .* dnt_dKn(2) ...
                    +   dqm_dtq_v(:,:,1) .* dnt_dKn(3);
        case 4
            % partitions(4)
            % 
            % ans =
            % 
            %      4     0     0     0
            %      2     1     0     0
            %      0     2     0     0
            %      1     0     1     0
            %      0     0     0     1
            dqm_dKq =   dqm_dtq_v(:,:,4) .* dnt_dKn(1).^4 ...
                    + 6*dqm_dtq_v(:,:,3) .* dnt_dKn(1).^2 .* dnt_dKn(2) ...
                    + 3*dqm_dtq_v(:,:,2) .* dnt_dKn(2).^2 ...
                    + 4*dqm_dtq_v(:,:,2) .* dnt_dKn(1)    .* dnt_dKn(3) ...
                    +   dqm_dtq_v(:,:,1) .* dnt_dKn(4);
        case 5
            % partitions(5)
            % 
            % ans =
            % 
            %      5     0     0     0     0
            %      3     1     0     0     0
            %      1     2     0     0     0
            %      2     0     1     0     0
            %      0     1     1     0     0
            %      1     0     0     1     0
            %      0     0     0     0     1
            dqm_dKq =   dqm_dtq_v(:,:,5) .* dnt_dKn(1).^5 ...
                    +10*dqm_dtq_v(:,:,4) .* dnt_dKn(1).^3 .* dnt_dKn(2) ...
                    +15*dqm_dtq_v(:,:,3) .* dnt_dKn(1)    .* dnt_dKn(2).^2 ...
                    +10*dqm_dtq_v(:,:,3) .* dnt_dKn(1).^2 .* dnt_dKn(3) ...
                    +10*dqm_dtq_v(:,:,2) .* dnt_dKn(2)    .* dnt_dKn(3) ...
                    + 5*dqm_dtq_v(:,:,2) .* dnt_dKn(1)    .* dnt_dKn(4) ...
                    +   dqm_dtq_v(:,:,1) .* dnt_dKn(5);
        case 6
            % partitions(6)
            % 
            % ans =
            % 
            %      6     0     0     0     0     0
            %      4     1     0     0     0     0
            %      2     2     0     0     0     0
            %      0     3     0     0     0     0
            %      3     0     1     0     0     0
            %      1     1     1     0     0     0
            %      0     0     2     0     0     0
            %      2     0     0     1     0     0
            %      0     1     0     1     0     0
            %      1     0     0     0     1     0
            %      0     0     0     0     0     1
            dqm_dKq =   dqm_dtq_v(:,:,6) .* dnt_dKn(1).^6 ...
                    +15*dqm_dtq_v(:,:,5) .* dnt_dKn(1).^4 .* dnt_dKn(2) ...
                    +45*dqm_dtq_v(:,:,4) .* dnt_dKn(1).^2 .* dnt_dKn(2).^2 ...
                    +15*dqm_dtq_v(:,:,3) .* dnt_dKn(2).^3  ...
                    +20*dqm_dtq_v(:,:,4) .* dnt_dKn(1).^3 .* dnt_dKn(3) ...
                    +60*dqm_dtq_v(:,:,3) .* prod(dnt_dKn(1:3)) ...
                    +10*dqm_dtq_v(:,:,2) .* dnt_dKn(3).^2 ...
                    +15*dqm_dtq_v(:,:,3) .* dnt_dKn(1).^2 .* dnt_dKn(4) ...
                    +15*dqm_dtq_v(:,:,2) .* dnt_dKn(2) .* dnt_dKn(4) ...
                    + 6*dqm_dtq_v(:,:,2) .* dnt_dKn(1) .* dnt_dKn(5) ...
                    +   dqm_dtq_v(:,:,1) .* dnt_dKn(6);
        otherwise
            error('Should not have gotten here');
    end
end