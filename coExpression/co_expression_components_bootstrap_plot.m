function coExpressionComponentsBootStrapPlot = co_expression_components_bootstrap_plot( coExpressionComponentsBootStrap, options, fileNames )
%Input: coExpressionComponentBootStrap = co_expression_component_bootstrap( coExpressionFull, coExpressionSmall )
dbstop if error;
if nargin < 3
    fileNames =  { 'coExpressionSet', 'coExpressionProba', 'coExpressionSDs' };
    if nargin < 2
        options = struct( 'savePlots', 0,...
            'fontSize', 18, 'figurePosition', [200 200 1100 700], 'markerSize', 14 );
    end
end
savePlots = options.savePlots;
fontSize = options.fontSize;
figurePosition = options.figurePosition;
markerSize = options.markerSize;
cols = { '-oc', '-or', '-*c', '-*r' };

thresholds = coExpressionComponentsBootStrap.thresholds;
numThresholds = numel( thresholds );
indsLegend = [];

avgSizesSmall = coExpressionComponentsBootStrap.avgSizesSmall;
indsLegend = [ indsLegend, 1 ];
h = figure('Color', 'w','InvertHardCopy','off','Position', figurePosition );
set(h,'PaperPositionMode','auto');  

plo( 1 ) = plot( thresholds, avgSizesSmall, '-or', 'markersize', markerSize );

labels{ 1 } = 'Average size of components in the special set'; 

hleg = legend( plo( indsLegend ), labels( indsLegend  ), 'Location', 'Westoutside', 'fontSize', fontSize, 'FontWeight', 'b' ); 

hold on;
maxSizesSmall = coExpressionComponentsBootStrap.maxSizesSmall;
indsLegend = [ indsLegend, 2 ];
plo( 2 ) = plot( thresholds, maxSizesSmall, '-*r', 'markersize', markerSize );
labels{ 2 } = 'Maximum size of components in the special set'; 


avgSizeMean = coExpressionComponentsBootStrap.avgSizeMean;
indsLegend = [ indsLegend, 3 ];
plo( 3 ) = plot( thresholds, avgSizeMean, '-oc', 'markersize', markerSize );
labels{ 3 } = 'Mean of average size of components across draws';

maxSizeMean = coExpressionComponentsBootStrap.maxSizeMean;
indsLegend = [ indsLegend, 4 ];
plo( 4 ) = plot( thresholds, maxSizeMean, '-*c', 'markersize', markerSize );
labels{ 4 } = 'Mean of maximum size of components across draws';
grid;
hleg = legend( plo( indsLegend ), labels( indsLegend  ), 'Location', 'Northoutside', 'fontSize', fontSize, 'FontWeight', 'b' ); 
xlabel( 'Threshold on co-expression', 'fontweight', 'b', 'fontSize', fontSize );

set( gca, 'fontweight', 'b', 'fontSize', fontSize );
set( gcf, 'PaperPositionMode', 'auto' );
if savePlots
saveas( gcf, fileNames{ 1 }, 'png' );
end
pause( 2 );
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PMaxSpecialLarger = coExpressionComponentsBootStrap.PMaxSpecialLarger;
PAvgSpecialLarger = coExpressionComponentsBootStrap.PAvgSpecialLarger;
h = figure('Color', 'w','InvertHardCopy','off','Position', figurePosition );
set(h,'PaperPositionMode','auto');  
indsLegend = [];
plo = [];
plo( 1 ) = plot( thresholds, PAvgSpecialLarger, '-ob', 'markersize', markerSize );
indsLegend = [ indsLegend, 1 ];

labels{ 1 } = 'P( average component size larger in set )'; 
grid;
hleg = legend( plo( indsLegend ), labels( indsLegend  ), 'Location', 'Westoutside', 'fontSize', fontSize, 'FontWeight', 'b' ); 

hold on;
indsLegend = [ indsLegend, 2 ];
plo( 2 ) = plot( thresholds, PMaxSpecialLarger, '-*g', 'markersize', markerSize );
labels{ 2 } = 'P( maximum component size larger in set )'; 


hleg = legend( plo( indsLegend ), labels( indsLegend  ), 'Location', 'Northoutside', 'fontSize', fontSize, 'FontWeight', 'b' ); 
xlabel( 'Threshold on co-expression', 'fontweight', 'b', 'fontSize', fontSize );

 set( gca, 'fontweight', 'b', 'fontSize', fontSize );
set( gcf, 'PaperPositionMode', 'auto' );
if savePlots
saveas( gcf, fileNames{ 2 }, 'png' );
end
pause( 2 );
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = figure('Color', 'w','InvertHardCopy','off','Position', [200 200 1100 700]);
set(h,'PaperPositionMode','auto');  
devFromMeanMaxInSDs = coExpressionComponentsBootStrap.deviationFromMeanMaxInSDs;
devFromMeanAvgInSDs = coExpressionComponentsBootStrap.deviationFromMeanAvgInSDs;
plo( 1 ) = plot( thresholds, devFromMeanMaxInSDs, '-*g', 'markerSize', markerSize );
hold on;
plo( 2 ) = plot( thresholds, devFromMeanAvgInSDs, '-ob', 'markerSize', markerSize );
indsLegend = [ 1, 2 ];
hold on;
grid;
xlabel( 'Threshold on co-expression', 'fontweight', 'b', 'fontSize', fontSize ); 
hleg = legend( plo( indsLegend ), { 'Number of s.d.s from mean maximum component size', 'Number of s.d.s from mean average component size' },...
              'Location', 'Northoutside', 'fontSize', fontSize, 'FontWeight', 'b' ); 
ylabel( 'Number of s.d.s', 'fontweight', 'b', 'fontSize', fontSize );
%title( plotTitles{ 2 }, 'fontweight', 'b', 'fontSize', 14 );
set( gca, 'fontweight', 'b', 'fontSize', fontSize );
set( gcf, 'PaperPositionMode', 'auto' );
if savePlots
    saveas( gcf, fileNames{ 3 }, 'png' );
end 
pause( 2 );
hold off; 

coExpressionComponentsBootStrapPlot = coExpressionComponentsBootStrap;

                                  