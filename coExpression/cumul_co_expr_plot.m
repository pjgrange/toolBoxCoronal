function cumulCoExprPlot = cumul_co_expr_plot( cumulCoExpr, options )

if nargin < 2
   options = struct( 'savePlots', 0, 'fontSize', 18, 'figurePosition', [200 200 1100 700], 'markerSize', 14,...
                      'lineWidth', 2, 'fileName', 'cumulCoExprFunction' ); 
end
savePlots = options.savePlots;
figurePosition = options.figurePosition;
fontSize = options.fontSize;
figurePosition = options.figurePosition;
lineWidth = options.lineWidth;

coExprGrid = cumulCoExpr.coExprGrid;
meanCumul = cumulCoExpr.meanCumul;
stdCumul = cumulCoExpr.stdCumul;
cumulDistrSpecial = cumulCoExpr.cumulDistrSpecial; 

cumulCoExprPlot = figure('Color', 'w', 'InvertHardCopy', 'off', 'Position', figurePosition );
plot( coExprGrid, cumulDistrSpecial, '-or', 'linewidth', lineWidth );
hold on;
set( gca, 'xLim', [ 0, 1 ], 'yLim', [ 0,1 ] );
plot( coExprGrid, meanCumul, '-ob', 'linewidth', lineWidth / 2  );
plot( coExprGrid, meanCumul + stdCumul, '-g',  'linewidth', lineWidth / 2 );
plot( coExprGrid, meanCumul - stdCumul, '-g',  'linewidth', lineWidth / 2);
legend( { 'c.d.f of special set', 'mean c.d.f. across draws', 'mean c.d.f. across draws +/- s.d.' },...
        'Location', 'Northoutside', 'fontSize', fontSize, 'FontWeight', 'b' );
set( gca, 'fontweight', 'b', 'fontsize', 14 );
xlabel( 'Threshold on co-expression', 'fontweight', 'b', 'fontsize', fontSize );

if savePlots
    set( gcf, 'PaperPositionMode', 'auto' );
    fileName = options.fileName;
    saveas( gcf, fileName, 'png' );
end
hold off;
