function figureForTypes = figure_for_types_colormap_fixed( Ref, volumes, options )

numTypes = numel( volumes );
%dbstop if error

if nargin < 3
    %sectionChoice can be either maxAverage of maxFraction
    for vv = 1 : numTypes
        options{ vv } = struct( 'regionChoice', 'maxAverage', 'sectionStyle', 'coronal',...
            'identifierIndex', 5, 'isCorrelation', 1, 'isFitting', 0, 'fontSize', 20, 'fontSizeAtlas', 16, 'regionIndicesToPick', 1 : 13,...
            'customIndex', 1, 'desiredIndex', 36, 'corMult', 0.87, 'stripDim', [ 200 200 1350 255], 'labelForType', '',...
            'xPosProj', [ 0.01, 0.18, 0.33, 0.48, 0.64, 0.78, 0.78] );
    end
end
cols = { '-b', '-g', '-c', '-g*', '-b*', '-c*', '-go', '-bo', '-co', '-g.', '-b.', '-c.', '-gs' };
%colorCodes = { [ 0, 1, 0 ], [ 0.2, 0.3, 1 ], [ 0.2, 0.6, 1 ], [ 0.5, 1, 1 ], [ 0.5, 0, 1 ], [ 0.5, 1, 0 ],...
%           [ 0.5, 1, 0.5 ], [ 0.2, 1, 1 ], [ 0, 1, 0.9  ], [ 0.1, 0.9, 1 ], [ 0.2, 0.7, 1 ], [ 0.2, 0.5, 0.6 ], [ 0, 1, 1 ] } ;   
for cc = 1 : 13
   colorCodes{ cc } = [ 0, 1, 0 ];
end

%size for just one type
cor = Ref.Coronal;
ann = cor.Annotations;
brainFilter = get_voxel_filter( cor, 'brainVox' );

%for the boundaries of the brain
load('allen_brain_boundaries.mat');

%choose the planes of section
for vv = 1 : numTypes
    %size for just one type
    corMult = options{ vv }.corMult;
    stripDim = options{ vv }.stripDim;
    figDim = [ stripDim( 1 ), stripDim( 2 ), stripDim( 3 ), numTypes * stripDim( 4 ) ];
    identifierIndex = options{ vv }.identifierIndex;
    brainFilter = get_voxel_filter( cor, 'brainVox' );
    annot = get_annotation( cor, ann.identifier{ identifierIndex } );
    [ C, A, S ] = size( annot );
    annotStandard = get_annotation( cor, 'standard' );
    ids = ann.ids{ identifierIndex };
    labels = ann.labels{ identifierIndex };
    fontSize = options{ vv }.fontSize;
    fontSizeAtlas = options{ vv }.fontSizeAtlas;
    regionChoice = options{ vv }.regionChoice;
    sectionByAverage = strcmp( regionChoice, 'maxAverage' );
    sectionByFraction = strcmp( regionChoice, 'maxFraction' );
    %through which region should I cut?
    optionsLoc = struct( 'identifierIndex', identifierIndex );
    isCorrelation = options{ vv }.isCorrelation;
    isFitting = options{ vv }.isFitting;
    volLoc =  volumes{ vv };
    colLoc = volLoc( brainFilter );

    classifyPattern = classify_pattern( Ref, colLoc, colLoc, optionsLoc );
    if isCorrelation
        if sectionByAverage
            rankRegions{ vv } = classifyPattern.rankRegionsAverageCorrelations;
        else
            rankRegions{ vv } = classifyPattern.rankRegionsFractionCorrelations;
        end
    else
        if sectionByAverage
            rankRegions{ vv } = classifyPattern.rankRegionsAverageFittings;
        else
            rankRegions{ vv } = classifyPattern.rankRegionsFractionFittings;
        end
    end
   
end
%compute the volumes and the relevant sections
for vv = 1 : numTypes
    volLoc = volumes{ vv };
    optionsLoc = struct( 'sectionStyle', options{ vv }.sectionStyle,...
        'identifierIndex', 5, 'regionIndexForSection', rankRegions{ vv }( 1 ),...
        'customIndex', options{ vv }.customIndex, 'desiredIndex', options{ vv }.desiredIndex );
    cellTypeVolPrepare = cell_type_vol_prepare( Ref, volLoc, optionsLoc );
    cellTypePatternsFigures{ vv } =  cellTypeVolPrepare;
    optionsForVol{ vv } = optionsLoc;
end 

h = figure( 'Color', 'k', 'InvertHardCopy', 'off', 'Position', figDim );

numTypesShifted = numTypes * 1.08;
heightParam = 1 / numTypesShifted;
widthParam = 0.16;
numTypesShifted = numTypes * 1.08;

colormap( 'hot' );
for vv = 1 : numTypes
    %highest index on top of the figure 
    %vv = numTypes - uu + 1;
    xPosProj = options{ vv }.xPosProj;
    optionsLoc = optionsForVol{ vv };
    labelForType = options{ vv }.labelForType;
    cellTypeVolPrepare = cellTypePatternsFigures{ vv };
    proj = cellTypeVolPrepare.projCorrels;
    secCorrels = cellTypeVolPrepare.secCorrels;
    
    sectionStyle = cellTypeVolPrepare.sectionStyle;
    intenseIndex = cellTypeVolPrepare.intenseIndex;
    secAtlasStandard = cellTypeVolPrepare.secAtlasStandard;
    secAtlasBig = cellTypeVolPrepare.secAtlasBig;
    coronalSection = strcmp( sectionStyle, 'coronal' );
    sagittalSection = strcmp( sectionStyle, 'sagittal' );
    axialSection = strcmp( sectionStyle, 'axial' );

   
   
    %first type on top of the figure
     %highest index on top of the figure 
    bottomDist( vv ) = 0.01 + ( numTypes - vv  ) * 1 / numTypesShifted;
    %for the color map
    cmax( vv ) = max([max(proj{1}(:)) max(proj{2}(:)) max(proj{3}(:))]);
    cmin( vv ) = min([min(proj{1}(:)) min(proj{2}(:)) min(proj{3}(:))]);

    %maximal_intensity projections
    %______________Sagittal projection
    ax1 = axes( 'Position', [ xPosProj( 1 ), bottomDist( vv ), widthParam, heightParam ], 'NextPlot', 'add');
    imagesc( flipud( fliplr( ( proj{ 3 }' ) ) ) );
    %freezeColors;

    fmask = fill( bmask{ 1 }( :, 1), bmask{ 1 }( :, 2), 'w' );
    set( fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth',1);
    %caxis( [ cmin( vv ) cmax( vv ) ] );
    set(gca,'XLim',[-5 67],'YLim',[0 41],'Color','k','Visible','on',...
        'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
    axis xy;
    set(gca,'XDir','reverse');

    %______________Coronal projection
    ax2 = axes( 'Position', [ xPosProj( 2 ), bottomDist( vv ), widthParam * corMult, heightParam * corMult], 'NextPlot', 'add');
    imagesc( fliplr( flipud( proj{ 1 } ) ) );
    %freezeColors;

    fmask = fill( bmask{ 2 }( :, 1 ), bmask{ 2 }( :, 2), 'w' );
    set( fmask,'FaceColor','none','FaceAlpha', 1,'EdgeColor','w','LineWidth',1);
    %caxis( [ cmin( vv ) cmax( vv ) ] );
    set( gca,'XLim',[0 58],'YLim',[0 41],'Color','k','Visible','on',...
        'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
    axis xy ;
    set(gca,'XDir','reverse');

    %______________Axial projection
    ax3 = axes( 'Position', [ xPosProj( 3 ), bottomDist( vv ), widthParam * corMult, heightParam * corMult], 'NextPlot', 'add');
    imagesc( flipud( proj{ 2 } ) );
    %freezeColors;

    fmask = fill( bmask{ 3 }( :, 1 ), bmask{ 3 }( :, 2), 'w' );
    set( fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth',1);
    %caxis( [ cmin( vv ) cmax( vv ) ] );
    set( gca,'XLim',[0 57],'YLim',[-5 67],'Color','k','Visible','on',...
        'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
    axis xy;
    colormap( 'hot' );
    %plane of section
    if coronalSection
        axSec = axes( 'Position', [ xPosProj( 4 ), bottomDist( vv ), widthParam, heightParam ],  'NextPlot', 'add');
        %show the plane of section on a sagittal projection
        mockSec = proj{ 3 }';
        maxCorr = max( mockSec( : ) );
        mockSec = 0 * mockSec;
        mockSec( :, intenseIndex ) = maxCorr;
        imagesc( flipud( fliplr( mockSec ) ) );

        %freezeColors;

        fmask = fill( bmask{ 1 }( :, 1), bmask{ 1 }( :, 2), 'w' );
        set( fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth', 1 );
        %caxis( [cmin( vv ) cmax( vv )] );
        %set( gca, 'XLim', [0 58], 'YLim', [0 41], 'Color','k','Visible','on',...
        %      'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        set(gca,'XLim',[-3 67],'YLim',[0 41],'Color','k','Visible','on',...
        'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');  
        axis xy;
        set(gca,'XDir','reverse');
    elseif sagittalSection
        axSec = axes( 'Position', [ xPosProj( 4 ), bottomDist( vv ), widthParam * corMult, heightParam * corMult ],  'NextPlot', 'add');
        %show the plane of section on a sagittal projection
        mockSec = proj{ 1 };
        maxCorr = max( mockSec( : ) );
        mockSec = 0 * mockSec;
                   mockSec( :, S - intenseIndex ) = maxCorr;
        imagesc( flipud( mockSec ) );
        %freezeColors;

        fmask = fill( bmask{ 2 }( :, 1 ), bmask{ 2 }( :, 2), 'w' );
        set( fmask,'FaceColor','none','FaceAlpha', 1,'EdgeColor','w','LineWidth',1);
        %caxis( [cmin( vv ) cmax( vv )] );
        set( gca, 'XLim', [0 58], 'YLim', [0 41], 'Color','k','Visible','on',...
             'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        axis xy ;
        set(gca,'XDir','reverse');


    elseif axialSection
        axSec = axes( 'Position', [ xPosProj( 4 ), bottomDist( vv ), widthParam * corMult, heightParam * corMult],  'NextPlot', 'add');
        %show the plane of section on an axial projection
        mockSec = proj{ 1 };

        maxCorr = max( mockSec( : ) );
        mockSec = 0 * mockSec;
        mockSec( intenseIndex, : ) = maxCorr;

        imagesc( flipud( mockSec ) );
        %freezeColors;

        fmask = fill( bmask{ 2 }( :, 1 ), bmask{ 2 }( :, 2), 'w' );
        set( fmask,'FaceColor','none','FaceAlpha', 1,'EdgeColor','w','LineWidth',1);
        %caxis( [cmin( vv ) cmax( vv ) ] );
        %set( gca,'XLim',[0 58],'YLim',[-3 67],'Color','k','Visible','on',...
        %    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
        set( gca,'XLim', [0 58], 'YLim', [0 41], 'Color','k','Visible','on',...
          'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
        axis xy ;
        set(gca,'XDir','reverse');
    end

    %section
    section = cellTypeVolPrepare.secCorrels;
    if coronalSection || axialSection
        multLoc = corMult;
    else
        multLoc = 1;
    end    
    
    ax5 = axes( 'Position', [ xPosProj( 5 ), bottomDist( vv ), widthParam * multLoc, heightParam * multLoc ], 'NextPlot', 'add');
    if coronalSection
        imagesc( section );
    elseif sagittalSection
        imagesc( section );
    elseif axialSection
        imagesc( flipud( section' ) );
    end    
    %caxis( [cmin( vv ) cmax( vv ) ] );
    %freezeColors;
    optionsPlot = struct( 'outlineBrain', 1, 'lineWidth', 2, 'regionIndicesToPick', [ ] );
    optionsPlot.regionIndicesToPick = optionsLoc.regionIndexForSection;
    
    if optionsLoc.customIndex == 1
        %%%%%HACK
        optionsPlot.regionIndicesToPick = 13;
    end

    if identifierIndex == 5;
        labels{ 1 } = 'Basic cell groups';
        labels{ 4 } = 'Hippocampal reg.';
        labels{ 5 } = 'Retrohipp. reg.';
    end
    if axialSection
        outlineSectionWithAtlas = outline_section_with_atlas_picked( flipud( secAtlasBig' ), ids, labels, colorCodes, optionsPlot, flipud( secAtlasStandard' ) );
    elseif sagittalSection
        outlineSectionWithAtlas = outline_section_with_atlas_picked( secAtlasBig, ids, labels, colorCodes, optionsPlot, secAtlasStandard );
    else
        outlineSectionWithAtlas = outline_section_with_atlas_picked( secAtlasBig , ids, labels, colorCodes, optionsPlot, secAtlasStandard );
    end
   
    labelsOutline = outlineSectionWithAtlas.labels;
    ploOutline = outlineSectionWithAtlas.plo;
    indsLegend = outlineSectionWithAtlas.indsLegend;
    hleg = legend( ploOutline( indsLegend ), labelsOutline( indsLegend  ) );
    set( hleg, 'Position', [ xPosProj( 6 )+ 0.01, bottomDist( vv ) + 0.03, widthParam, heightParam / 3 ], 'fontweight', 'b', 'fontsize', fontSizeAtlas, 'Color', 'w' );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if coronalSection
        set( gca,'XLim',[ 1 56],'YLim',[1 41],'Color','k','Visible','on',...
            'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
        axis xy ;
    elseif sagittalSection
        %set( gca,'XLim',[ -5 67],'YLim',[1 41],'Color','k','Visible','on',...
        %    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        set(gca,'XLim',[-5 67],'YLim',[0 41],'Color','k','Visible','on',...
        'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        axis xy;
        %set(gca,'XDir','reverse');
    elseif axialSection
        set( gca,'XLim',[ 0 57],'YLim',[ -5 67],'Color','k','Visible','on',...
            'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
        axis xy;
    else
        sectionStyleMessage = 'Misinterpreted section'
    end
    %HACK%%%%%%%%%%%%%%%%%%%%%%%
    %pause;
end
cMin = min( cmin );
cMax = max( cmax );

colormap( 'hot' );
caxis( [cMin cMax] );
axes('Position',[ 0 0 1 1 ],'Visible','off');
axes('Position',[ xPosProj( 7 ) 0.1 0.2 0.7], 'Visible','off');
cb = colorbar( 'eastoutside', 'fontWeight', 'b', 'fontSize', fontSize  );
caxis( [cMin cMax] );

% Add text labels to each view
axes('Position',[0 0 1 1],'Visible','off');
h = text( xPosProj( 1 )+0.07, 0.94, 'Sagittal proj.', 'color', 'w', 'FontSize', fontSize -2, 'HorizontalAlignment','center');
h = text( xPosProj( 2 )+0.07, 0.94, 'Coronal proj.', 'color', 'w', 'FontSize', fontSize -2, 'HorizontalAlignment','center');
h = text( xPosProj( 3 )+0.08, 0.94, 'Axial proj.', 'color', 'w', 'FontSize', fontSize -2, 'HorizontalAlignment','center');
h = text( xPosProj( 4 )+0.09, 0.94, 'Plane of section', 'color', 'w', 'FontSize', fontSize -2, 'HorizontalAlignment','center');
h = text( xPosProj( 5 )+0.08, 0.94, 'Section', 'color', 'w', 'FontSize', fontSize -2, 'HorizontalAlignment','center');

for vv = 1 : numTypes
    labelForType = options{ vv }.labelForType;
    h = text( 0.01, bottomDist( vv ) + 0.05, options{ vv }.labelForType, 'color', 'w',...
                    'FontSize', fontSize, 'FontWeight', 'b', 'HorizontalAlignment', 'center');
end

figureForTypes = struct( 'cellTypePatternsFigures', cellTypePatternsFigures, 'options', options );

