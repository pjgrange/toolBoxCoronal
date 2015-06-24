function plotCorrelationsForBig12 = plot_correlations_for_big12( Ref, avgCorrelation, options )

if nargin < 3
    options = struct( 'figDim', [ 200 200 800 600 ], 'fontSize', 16 );
end    
figDim = options.figDim;
fontSize = options.fontSize;

cor = Ref.Coronal;
ann = cor.Annotations;
identifierIndex = 5;
symbols = ann.symbols{ identifierIndex };

figGranule = figure( 'Color', 'w', 'InvertHardCopy', 'off', 'Position', figDim );
axCorr = axes( 'Position', [ 0.1, 0.15, 0.9, 0.8 ], 'NextPlot', 'add');
bar( avgCorrelation, 'b' );
grid;
set( gca, 'fontweight', 'b', 'fontSize', fontSize );
ylabel( 'Average correlation to cell type' );
xlabel( 'Symbol of brain region (ARA)' );
set( gca, 'xTick', 1 : numel( symbols ), 'xTickLabel', symbols );
plotCorrelationsForBig12 = [];
hold off;

