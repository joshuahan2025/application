function h = plotLifetimes(lftRes, colorA)

fset = loadFigureSettings();

if isstruct(lftRes)
    h = figure;
    hold on;
    opts = {'.-', 'LineWidth', 2, 'MarkerSize', 16};
    hp(2) = plot(lftRes.t_hist, lftRes.meanLftHist_B, opts{:}, 'Color', 0.5*[1 1 1]);
    hp(1) = plot(lftRes.t_hist, lftRes.meanLftHist_A, opts{:}, 'Color', 'k');

    legendText = {['Above threshold (' num2str(mean(lftRes.pctAbove)*100,'%.1f') ' � ' num2str(std(lftRes.pctAbove)*100,'%.1f') ' %)'],...
        ['Below threshold (' num2str(mean(1-lftRes.pctAbove)*100,'%.1f') ' � ' num2str(std(lftRes.pctAbove)*100,'%.1f') ' %)']};
    
    if isfield(lftRes, 'lftHist_Apos')
        hp(6) = plot(lftRes.t_hist, mean(lftRes.lftHist_Bneg,1), opts{:}, 'Color', hsv2rgb([0   0.4 0.9]));
        hp(5) = plot(lftRes.t_hist, mean(lftRes.lftHist_Bpos,1), opts{:}, 'Color', hsv2rgb([1/3 0.4 0.9]));
        hp(4) = plot(lftRes.t_hist, mean(lftRes.lftHist_Aneg,1), opts{:}, 'Color', hsv2rgb([0   1 0.9]));
        hp(3) = plot(lftRes.t_hist, mean(lftRes.lftHist_Apos,1), opts{:}, 'Color', hsv2rgb([1/3 1 0.9]));
        legendText = [legendText ['Above, sign. (' num2str(mean(lftRes.pctAboveSignificant)*100,'%.1f') ' � ' num2str(std(lftRes.pctAboveSignificant)*100,'%.1f') ' %)'],...
            ['Above, not sign. (' num2str(mean(lftRes.pctAbove-lftRes.pctAboveSignificant)*100,'%.1f') ' � ' num2str(std(lftRes.pctAboveSignificant)*100,'%.1f') ' %)'],...
            ['Below, sign. (' num2str(mean(lftRes.pctBelowSignificant)*100,'%.1f') ' � ' num2str(std(lftRes.pctBelowSignificant)*100,'%.1f') ' %)'],...
            ['Below, not sign. (' num2str(mean(1-lftRes.pctAbove-lftRes.pctBelowSignificant)*100,'%.1f') ' � ' num2str(std(lftRes.pctBelowSignificant)*100,'%.1f') ' %)']];
    end
    
    axis([0 min(120, lftRes.t_hist(end)) 0 0.05]);
    set(gca, 'LineWidth', 2, fset.sfont{:}, fset.axOpts{:});
    xlabel('Lifetime (s)', fset.lfont{:});
    ylabel('Frequency', fset.lfont{:});
    
    
    
    
    hl = legend(hp, legendText{:}, 'Location', 'NorthEast');
    set(hl, 'Box', 'off', fset.ifont{:});
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
        hp(2*(i-1)+2) = plot(lftRes{i}.t_hist, lftRes{i}.meanLftHist_B, '.-', 'Color', colorB(i,:), 'LineWidth', 2, 'MarkerSize', 16);
        hp(2*(i-1)+1) = plot(lftRes{i}.t_hist, lftRes{i}.meanLftHist_A, '.-', 'Color', colorA(i,:), 'LineWidth', 2, 'MarkerSize', 16);
        expName = getDirFromPath(getExpDir(lftRes{i}.data));
        legendText{2*(i-1)+1} = [expName ', above threshold (' num2str(mean(lftRes{i}.pctAbove)*100,'%.1f') ' � ' num2str(std(lftRes{i}.pctAbove)*100,'%.1f') ' %)'];
        legendText{2*(i-1)+2} = [expName ', below threshold (' num2str(mean(1-lftRes{i}.pctAbove)*100,'%.1f') ' � ' num2str(std(lftRes{i}.pctAbove)*100,'%.1f') ' %)'];
    end
    axis([0 min(120, lftRes{1}.t_hist(end)) 0 0.05]);
    set(gca, 'LineWidth', 2, fset.sfont{:}, fset.axOpts{:});
    xlabel('Lifetime (s)', fset.lfont{:});
    ylabel('Frequency', fset.lfont{:});
    hl = legend(hp, legendText{:}, 'Location', 'NorthEast');
    set(hl, 'Box', 'off', fset.ifont{:}, 'Interpreter', 'none');
    
else
    error('Incompatible input');
end
