function h = plotLifetimes(lftRes, varargin)

ip = inputParser;
ip.CaseSensitive = false;
ip.addParamValue('DisplayMode', '');
ip.addParamValue('ShowExpFits', false, @islogical);
ip.addParamValue('ShowCargoDependent', false, @islogical);
ip.addParamValue('CargoName', 'cargo');
ip.parse(varargin{:});

fset = loadFigureSettings(ip.Results.DisplayMode);

if isstruct(lftRes)
    
    figure(fset.fOpts{:}, 'Name', 'Lifetime dist. (intensity threshold)');
    axes(fset.axOpts{:});
    hold on;
    if isfield(lftRes, 'pctVisit')
        hp(4) = plot(lftRes.t, mean(lftRes.pctVisit)*lftRes.meanLftHist_V, '-', 'Color', fset.cfB, 'LineWidth', 2);
    end
    hp(3) = plot(lftRes.t, mean(vertcat(lftRes.lftHist_Ia), 1), 'Color', 0.6*[1 1 1], 'LineWidth', 2);
    hp(2) = plot(lftRes.t, mean(lftRes.pctBelow)*lftRes.meanLftHist_B, '-', 'Color', hsv2rgb([1/3 0.3 0.9]), 'LineWidth', 2);
    
    if ip.Results.ShowExpFits
        ff = mean(lftRes.pctBelow)*lftRes.meanLftHist_B;
        %ff = mean(vertcat(lftRes.lftHist_Ia), 1);
        [mu,~,Aexp,expF] = fitExpToHist(lftRes.t(5:end), ff(5:end));
        tx = 0:0.1:lftRes.t(end);
        plot(tx, Aexp/mu*exp(-1/mu*tx), 'r--', 'LineWidth', 1)
        
        %ff = mean(lftRes.pctBelow)*lftRes.meanLftHist_B + mean(lftRes.pctVisit)*lftRes.meanLftHist_V;
        %plot(lftRes.t, ff, '--', 'Color', 'k', 'LineWidth', 2);
        %[mu,~,Aexp,expF] = fitExpToHist(lftRes.t, ff);
        %plot(tx, Aexp/mu*exp(-1/mu*tx), 'm--', 'LineWidth', 1)
    end
    hp(1) = plot(lftRes.t, mean(lftRes.pctAbove)*lftRes.meanLftHist_A, '-', 'Color', hsv2rgb([1/3 1 0.9]), 'LineWidth', 2);

    
    ya = 0:0.01:0.05;
    axis([0 min(120, lftRes.t(end)) 0 ya(end)]);
    set(gca, 'XTick', 0:20:200, 'YTick', ya, 'YTickLabel', ['0' arrayfun(@(x) num2str(x, '%.2f'), ya(2:end), 'UniformOutput', false)]);
    xlabel('Lifetime (s)', fset.lfont{:});
    ylabel('Frequency', fset.lfont{:});
    
    ltext = {['Above threshold: ' num2str(mean(lftRes.pctAbove)*100, '%.1f') ' � ' num2str(std(lftRes.pctAbove)*100, '%.1f') ' %'],...
        ['Below threshold: ' num2str(mean(lftRes.pctBelow)*100, '%.1f') ' � ' num2str(std(lftRes.pctBelow)*100, '%.1f') ' %'],...
        'Raw distribution'};
    if isfield(lftRes, 'pctVisit')
        ltext = [ltext(1:2) ['Visitors: ' num2str(mean(lftRes.pctVisit)*100, '%.1f') ' � ' num2str(std(lftRes.pctVisit)*100, '%.1f') ' %'] ltext(3)];
        hp = hp([1 2 4 3]);
    end
    hl = legend(hp, ltext{:});
    set(hl, 'Box', 'off', fset.tfont{:});
    if strcmpi(ip.Results.DisplayMode, 'print')
        set(hl, 'Position', [4 4 1.75 1]); 
    end
    %%
    if ip.Results.ShowCargoDependent && isfield(lftRes, 'lftHist_Apos')
        
        figure(fset.fOpts{:}, 'Name', 'Lifetime dist.');
        axes(fset.axOpts{:});
        hold on;
        
        pAS = mean(lftRes.pctAboveSignificant);
        pANS = mean(lftRes.pctAboveNotSignificant);
        pBS = mean(lftRes.pctBelowSignificant);
        pBNS = mean(lftRes.pctBelowNotSignificant);
                
        hp = zeros(1,7);
        % total distr
        hp(1) = plot(lftRes.t, mean(vertcat(lftRes.lftHist_Ia), 1), 'Color', 0.6*[1 1 1], 'LineWidth', 2);
        
        % Cargo-negative distributions
        hp(5) = plot(lftRes.t, mean(vertcat(lftRes.lftHist_neg), 1), 'Color', [1 0 0], 'LineWidth', 2);
        hp(7) = plot(lftRes.t, pBNS/(pANS+pBNS)*mean(lftRes.lftHist_Bneg,1), '--', 'Color', hsv2rgb([0   0.4 0.9]), 'LineWidth', 2);
        hp(6) = plot(lftRes.t, pANS/(pANS+pBNS)*mean(lftRes.lftHist_Aneg,1), '--', 'Color', hsv2rgb([0   1 0.9]), 'LineWidth', 2);
        
        % Cargo-positive distributions
        hp(2) = plot(lftRes.t, mean(vertcat(lftRes.lftHist_pos), 1), 'Color', [0 1 0], 'LineWidth', 2);
        hp(4) = plot(lftRes.t, pBS/(pAS+pBS)*mean(lftRes.lftHist_Bpos,1), 'Color', hsv2rgb([1/3 0.4 0.9]), 'LineWidth', 2);
        hp(3) = plot(lftRes.t, pBS/(pAS+pBS)*mean(lftRes.lftHist_Apos,1), 'Color', hsv2rgb([1/3 1 0.9]), 'LineWidth', 2);
        
        % All, above/below threshold
        %hp(2) = plot(lftRes.t, mean(lftRes.pctBelow)*lftRes.meanLftHist_B, '-', 'Color', hsv2rgb([2/3 0.3 0.9]), 'LineWidth', 2);
        %hp(1) = plot(lftRes.t, mean(lftRes.pctAbove)*lftRes.meanLftHist_A, '-', 'Color', hsv2rgb([2/3 1 0.9]), 'LineWidth', 2);
        cargo = ip.Results.CargoName;
        fmt = '%.1f';
        legendText = {'All', ['w/ ' cargo '(' num2str((pAS+pBS)*100, fmt) '%)'], ['w/ ' cargo ', above (' num2str(pAS*100, fmt) '%)'],...
            ['w/ ' cargo ', below (' num2str(pBS*100, fmt) '%)'], ['w/o ' cargo '(' num2str((pANS+pBNS)*100, fmt) '%)'],...
            ['w/o ' cargo ', above (' num2str(pANS*100, fmt) '%)'], ['w/o ' cargo, ', below (' num2str(pBNS*100, fmt) '%)']};
        
        axis([0 min(120, lftRes.t(end)) 0 0.05]);
        set(gca, 'LineWidth', 2, fset.sfont{:}, fset.axOpts{:});
        xlabel('Lifetime (s)', fset.lfont{:});
        ylabel('Frequency', fset.lfont{:});
        
        hl = legend(hp, legendText{:}, 'Location', 'NorthEast');
        set(hl, 'Box', 'off', fset.tfont{:}, 'Position', [4 3 2.5 2]);
    end
elseif iscell(lftRes)
    if nargin<2
        colorA = hsv2rgb([0.6 1 1;
            1/3 1 1;
            0 1 1;
            1/7 1 1;
            5/9 1 1]);
    end
    colorB = rgb2hsv(colorA);
    colorB(:,2) = 0.5;
    colorB = hsv2rgb(colorB);
    
    nd = numel(lftRes);
    h = figure;
    hold on;
    for i = 1:nd
        hp(2*(i-1)+2) = plot(lftRes{i}.t, lftRes{i}.meanLftHist_B, '.-', 'Color', colorB(i,:), 'LineWidth', 2, 'MarkerSize', 16);
        hp(2*(i-1)+1) = plot(lftRes{i}.t, lftRes{i}.meanLftHist_A, '.-', 'Color', colorA(i,:), 'LineWidth', 2, 'MarkerSize', 16);
        expName = getDirFromPath(getExpDir(lftRes{i}.data));
        legendText{2*(i-1)+1} = [expName ', above threshold (' num2str(mean(lftRes{i}.pctAbove)*100,'%.1f') ' � ' num2str(std(lftRes{i}.pctAbove)*100,'%.1f') ' %)'];
        legendText{2*(i-1)+2} = [expName ', below threshold (' num2str(mean(1-lftRes{i}.pctAbove)*100,'%.1f') ' � ' num2str(std(lftRes{i}.pctAbove)*100,'%.1f') ' %)'];
    end
    axis([0 min(120, lftRes{1}.t(end)) 0 0.05]);
    set(gca, 'LineWidth', 2, fset.sfont{:}, fset.axOpts{:});
    xlabel('Lifetime (s)', fset.lfont{:});
    ylabel('Frequency', fset.lfont{:});
    hl = legend(hp, legendText{:}, 'Location', 'NorthEast');
    set(hl, 'Box', 'off', fset.ifont{:}, 'Interpreter', 'none');
    
else
    error('Incompatible input');
end
