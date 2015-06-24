function figureForComponent = figure_for_component( Ref, D, extractComps, indexComp, options )

if nargin < 5
   options = struct( 'fontSize', 20, 'widthParam', 0.33, 'heightParam', 0.5, 'corMult', 0.9, 'maxGenesForDisplay', 10 );
end
fontSize = options.fontSize;
widthParam = options.widthParam;
heightParam = options.heightParam;
corMult = options.corMult;
maxGenesForDisplay = options.maxGenesForDisplay;

dbstop if error;
cor = Ref.Coronal;
ann = cor.Annotations;
ann.symbols{5}{1} = 'Basic';
brainFilter = get_voxel_filter( cor, 'brainVox' );

threshold = extractComps.threshold{ indexComp };
indsCritAtlas = extractComps.regionCritIndicesInAtlas{ indexComp };
labelsCrit = extractComps.regionCritNamesInAtlas{ indexComp };
identifierIndex = extractComps.identifierIndex{ indexComp };
identifier = extractComps.identifier{ indexComp };
numGenesInComponent = extractComps.numGenesInComponent{ indexComp };
geneIndicesInAtlas = extractComps.geneIndicesInAtlas{ indexComp };
geneNames = extractComps.geneNames{ indexComp };
pValsInAtlas = extractComps.pValsInAtlas{ indexComp };
probaCrit = extractComps.probaCrit{ indexComp };

expressionComp = ( sum( D( :, geneIndicesInAtlas )' ) )';
expressionTots = sum( D( :, geneIndicesInAtlas ) );
[ valsInt, indicesIntensitySorted ] = sort( expressionTots, 'descend' );
volExpressionComp = make_volume_from_labels( expressionComp, brainFilter );
%plot_intensity_projections( volExpressionComp );
numGenesComp = numel( geneNames );

figComp = figure( 'Color', 'k', 'InvertHardCopy', 'off', 'Position', [ 200, 200, 900, 1000 ] );
axes('Position',[0 0 1 1],'Visible','off');
%display the list of genes
numGenes = numel( geneNames );
h = text( 0.1, 0.93, [ 'Co-expression threshold ', num2str( threshold ) ], 'color', 'w', 'FontSize', fontSize + 4 );
h = text( 0.87, 0.93, [ num2str( numGenes), ' genes' ], 'color', 'w', 'FontSize', fontSize + 4, 'HorizontalAlignment','center');

for ll = 1 : numGenes
    if ll < maxGenesForDisplay
        geneName = geneNames( indicesIntensitySorted( ll ) );
        vertStep = 0.5 / 15;
        text( 0.85, 0.93-vertStep*ll, geneName, 'color', 'w', 'FontSize', fontSize );
        hold on;
    else
        text( 0.85, 0.93-vertStep*maxGenesForDisplay, '...', 'color', 'w', 'FontSize', fontSize );
    end    
end
xPosProj = [ 0.015 0.33 0.62 ];
for ss = 1 : 3
    proj{ ss } = squeeze( max( volExpressionComp, [], ss ) );
end
h = text( 0.18, 0.03, 'Sagittal projection', 'color', 'w', 'FontSize', fontSize, 'HorizontalAlignment','center');
h = text( 0.46, 0.03, 'Coronal projection', 'color', 'w', 'FontSize', fontSize, 'HorizontalAlignment','center');
h = text( 0.78, 0.03, 'Axial projection', 'color', 'w', 'FontSize', fontSize, 'HorizontalAlignment','center');

bottomDist = 0.02;
%for the color map
cmax = max([max(proj{1}(:)) max(proj{2}(:)) max(proj{3}(:))]);
cmin = min([min(proj{1}(:)) min(proj{2}(:)) min(proj{3}(:))]);

load( 'allen_brain_boundaries.mat' );
%maximal_intensity projections
%______________Sagittal projection
ax1 = axes( 'Position', [ xPosProj( 1 ), bottomDist, widthParam, heightParam ], 'NextPlot', 'add');
imagesc( flipud( fliplr( ( proj{ 3 }' ) ) ) );
%freezeColors;

fmask = fill( bmask{ 1 }( :, 1), bmask{ 1 }( :, 2), 'w' );
set( fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth',1);
caxis( [ cmin cmax ] );
set(gca,'XLim',[-5 67],'YLim',[0 41],'Color','k','Visible','on',...
    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
axis xy;
set(gca,'XDir','reverse');

%______________Coronal projection
ax2 = axes( 'Position', [ xPosProj( 2 ), bottomDist, widthParam * corMult, heightParam * corMult], 'NextPlot', 'add');
imagesc( fliplr( flipud( proj{ 1 } ) ) );
%freezeColors;

fmask = fill( bmask{ 2 }( :, 1 ), bmask{ 2 }( :, 2), 'w' );
set( fmask,'FaceColor','none','FaceAlpha', 1,'EdgeColor','w','LineWidth',1);
caxis( [ cmin cmax ] );
set( gca,'XLim',[0 58],'YLim',[0 41],'Color','k','Visible','on',...
    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
axis xy ;
set(gca,'XDir','reverse');

%______________Axial projection
ax3 = axes( 'Position', [ xPosProj( 3 ), bottomDist, widthParam * corMult, heightParam * corMult], 'NextPlot', 'add' );
imagesc( flipud( proj{ 2 } ) );
%freezeColors;

fmask = fill( bmask{ 3 }( :, 1 ), bmask{ 3 }( :, 2), 'w' );
set( fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth',1);
caxis( [ cmin cmax ] );
set( gca,'XLim',[0 57],'YLim',[-5 67],'Color','k','Visible','on',...
    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
axis xy;
colormap( 'hot' );
axes('Position',[ 0.73 0.05 0.23 0.3], 'Visible','off');
cb = colorbar( 'eastoutside', 'fontWeight', 'b', 'fontSize', fontSize  );
caxis( [cmin cmax] );

%Plot of proabilities in big12
symbols = ann.symbols{ identifierIndex };
ax5 = axes( 'Position', [ 0.1, 0.49, 0.72, 0.38 ], 'NextPlot', 'add', 'visible', 'on', 'Color', 'w' );
%freezeColors;
multScale = 1;
symbolsXs =  1 : numel( symbols );
%set( gca, 'YLim', [ 0, 1.1 ], 'XColor', 'w', 'Visible', 'on' );

bar( 1 - pValsInAtlas, 'c' );
set( gca, 'yLim', [ 0, 1.1], 'fontsize', fontSize, 'fontweight', 'b', 'Ycolor', 'w' );
set( gca, 'xLim', [ 0, numel( symbols ) + 1 ], 'xTick', symbolsXs, 'Xcolor', 'w', 'xTickLabel', symbols, 'fontsize', fontSize - 4, 'fontweight', 'b' );
xlabel( 'Symbols of brain regions', 'fontsize', fontSize, 'color', 'w', 'fontweight', 'b', 'color', 'w' );
ylabel( 'P( component better fitted to region )', 'fontsize', fontSize - 2, 'color', 'w', 'fontweight', 'b', 'color', 'w' );
axis xy;

figureForComponent = struct( 'threshold', threshold, 'geneIndicesInAtlas', geneIndicesInAtlas,...
        'geneNames', geneNames, 'pValsInAtlas', pValsInAtlas, 'labelsCrit', labelsCrit,...
        'identifier', identifier );