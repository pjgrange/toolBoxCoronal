function flipThroughSections = flip_through_sections( vol, options )
dbstop if error;
if nargin < 2
   options = struct( 'sectionStyle', 'coronal', 'secondsOfPause', 1, 'displaySectionIndex', 1 ); 
end    
if isfield( options, 'secondsOfPause' )
    secondsOfPause = options.secondsOfPause;
else    
    secondsOfPause = 1;
end
if isfield( options, 'secondsOfPause''displaySectionIndex' )
    displaySectionIndex = options.displaySectionIndex;
else    
    displaySectionIndex = 1;
end

load( 'allen_brain_boundaries.mat' );
%cor = Ref.Coronal;

xPosProj = [ 0.49, 0.02 ];
bottomDist = 0.02;
widthParam = 0.42;
heightParam = 0.8;
corMult = 1;
figDim = [ 200, 200, 1000, 500 ];
fontSize = 20;

sectionStyle = options.sectionStyle;
coronalSection = strcmp( sectionStyle, 'coronal' );
sagittalSection = strcmp( sectionStyle, 'sagittal' );
axialSection = strcmp( sectionStyle, 'axial' );

[ C, A, S ] = size( vol );
if coronalSection
    maxIndex = C;
elseif sagittalSection
    maxIndex = S;
elseif axialSection
    maxIndex = A; 
else
    error( 'Section style must be coronal, sagittal or axial' );
end

for ss = 1 : 3
    proj{ ss } = squeeze( max( vol, [], ss ) );
end

for ii = 1 : maxIndex
    h = figure( 'Color', 'k', 'InvertHardCopy', 'off', 'Position', figDim );
    intenseIndex = ii;
    if coronalSection
        section( :, : ) = vol( ii, :, : );
        section = flipud( section );
    elseif sagittalSection
        sectionInit( :, : ) = vol( :, :, ii );
        section = sectionInit';
        section = flipud( section );
    elseif axialSection
        sectionInit( :, : ) = vol( :, ii, : );
        section = sectionInit';
    else
        error( 'Section style must be coronal, sagittal or axial' );
    end
    multLoc = 1;
    ax2 = axes( 'Position', [ xPosProj( 2 ), bottomDist, widthParam * multLoc, heightParam * multLoc ], 'NextPlot', 'add');
    if coronalSection
        imagesc( section );
    elseif sagittalSection
        imagesc( section );
    elseif axialSection
        imagesc( flipud( section' ) );
    end
   
    if coronalSection
        set( gca,'XLim',[ 1 56],'YLim',[1 41],'Color','k','Visible','on',...
            'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
        axis xy ;
    elseif sagittalSection
        %set( gca,'XLim',[ -5 67],'YLim',[1 41],'Color','k','Visible','on',...
        %    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        set(gca,'XLim',[ -5 67 ],'YLim',[0 41],'Color','k','Visible','on',...
            'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        axis xy;
        %set(gca,'XDir','reverse');
    elseif axialSection
        set( gca,'XLim',[ -1 59 ],'YLim',[ -5 70],'Color','k','Visible','on',...
            'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
        axis xy;
    else
        sectionStyleMessage = 'Misinterpreted section'
    end
    if coronalSection
        ax1 = axes( 'Position', [ xPosProj( 1 ), bottomDist, widthParam, heightParam ],  'NextPlot', 'add');
        %show the plane of section on a sagittal projection
        mockSec = proj{ 3 }';
        maxCorr = max( mockSec( : ) );
        mockSec = 0 * mockSec;
        mockSec( :, intenseIndex ) = maxCorr;
        imagesc( flipud( fliplr( mockSec ) ) );

        fmask = fill( bmask{ 1 }( :, 1), bmask{ 1 }( :, 2), 'w' );
        set( fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth', 1 );
        
        set(gca,'XLim',[-3 67],'YLim',[0 41],'Color','k','Visible','on',...
            'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        axis xy;
        set(gca,'XDir','reverse');
    elseif sagittalSection
        axSec = axes( 'Position', [ xPosProj( 1 ), bottomDist, widthParam * corMult, heightParam * corMult ],  'NextPlot', 'add');
        %show the plane of section on a sagittal projection
        mockSec = proj{ 1 };
        maxCorr = max( mockSec( : ) );
        mockSec = 0 * mockSec;
                 mockSec( :, S - intenseIndex + 1) = maxCorr;
        imagesc( flipud( mockSec ) );
       
        fmask = fill( bmask{ 2 }( :, 1 ), bmask{ 2 }( :, 2), 'w' );
        set( fmask,'FaceColor','none','FaceAlpha', 1,'EdgeColor','w','LineWidth',1);
       
        set( gca, 'XLim', [0 58], 'YLim', [0 41], 'Color','k','Visible','on',...
            'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        axis xy ;
        set(gca,'XDir','reverse');
    elseif axialSection
        ax1 = axes( 'Position', [ xPosProj( 1 ), bottomDist, widthParam, heightParam ],  'NextPlot', 'add');
        %show the plane of section on a sagittal projection
        mockSec = proj{ 3 }';
        maxCorr = max( mockSec( : ) );
        mockSec = 0 * mockSec;
        mockSec( intenseIndex, : ) = maxCorr;
        imagesc( flipud( fliplr( mockSec ) ) );

        fmask = fill( bmask{ 1 }( :, 1), bmask{ 1 }( :, 2), 'w' );
        set( fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth', 1 );
        
        set(gca,'XLim',[-3 67],'YLim',[0 41],'Color','k','Visible','on',...
            'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
        axis xy;
        set(gca,'XDir','reverse');
    end
    axes( 'Position', [0 0 1 1], 'Visible', 'off' );
    h = text( 0.22, 0.95, 'Section', 'color', 'w','FontSize', fontSize, 'HorizontalAlignment', 'center');
    h = text( 0.65, 0.95, 'Plane of section', 'color','w','FontSize', fontSize, 'HorizontalAlignment', 'center');
    if displaySectionIndex
       text( 0.82, 0.95, [ '(index ', num2str( ii ), '/', num2str( maxIndex ), ')' ], 'color','w','FontSize', fontSize, 'HorizontalAlignment', 'center');
    end    
    
    cmax = max( section( : ) );
    cmin = min( section( : ) );
    caxis( [cmin cmax ] );
    colormap( 'hot' );
    %axes('Position',[ 0 0 1 1 ],'Visible','off');
    axes( 'Position', [ 0 0.1 0.95 0.7 ], 'NextPlot', 'add', 'Visible','off' );
    cb = colorbar( 'eastoutside', 'fontWeight', 'b', 'fontSize', fontSize  );
    cmax = max( section( : ) );
    cmin = min( section( : ) );
    caxis( [cmin cmax ] );
    colormap( 'hot' );
    if secondsOfPause >= 0
        pause( secondsOfPause );
    else
        pause;
    end    
    hold off;
end

flipThroughSections = [];