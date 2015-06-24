function plotDensitiesForBig12 = plot_densities_for_big12( Ref, fracDensity, options )

if nargin < 3
    options = struct( 'figDim', [ 200 200 800 600 ], 'fontSize', 16 );
end   
figDim = options.figDim;
fontSize = options.fontSize;

cor = Ref.Coronal;
ann = cor.Annotations;
identifierIndex = 5;
symbols = ann.symbols{ identifierIndex };

h = figure( 'Color', 'w', 'InvertHardCopy', 'off', 'Position', [ 200 200 850 600 ] );
axFit = axes( 'Position', [ 0.1, 0.15, 0.9, 0.8 ], 'NextPlot', 'add' );
bar( fracDensity, 'r' );
grid;
set( gca, 'fontweight', 'b', 'fontSize', fontSize );
ylabel( 'Fraction of brain-wide density of cell type' );
xlabel( 'Symbol of brain region (ARA)' );
set( gca, 'xTick', 1 : numel( symbols ), 'xTickLabel', symbols );
hold off;
plotDensitiesForBig12 = [];
