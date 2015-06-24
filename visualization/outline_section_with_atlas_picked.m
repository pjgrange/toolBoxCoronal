function outlineSectionWithAtlasPicked = outline_section_with_atlas_picked( secAtlas, ids, labels, colorCodes, options, secAtlasStandard )

if nargin < 5
    options = struct( 'outlineBrain', 1, 'lineWidth', 2, 'regionIndicesToPick', [ 2, 6 ] );
end    
outlineBrain = options.outlineBrain;    
lineWidth = options.lineWidth;
regionIndicesToPick = options.regionIndicesToPick;
[ I, J ] = size( secAtlas ); 
if outlineBrain
    corAnnotReg = secAtlasStandard == 0;
    if numel( find( corAnnotReg == 1 ) ) > 0
    [ B, L, N ] = bwboundaries( corAnnotReg );
        %for k = 1 : length( B )
        for k = 2 : length( B )
            boundary = B{ k };
            numBorder = numel( unique( boundary( :, 2 ) ) );
            %do not put a frame
            %if numBorder < I &&  numBorder < J
            %if numel( unique( boundary( :, 2 ) ) ) < I && numel( unique( boundary( :, 1 ) ) ) < J
                ploOutline = plot( boundary( :, 2 ),...
                boundary( :, 1 ), 'w', 'LineWidth', lineWidth / 2);
            %end
        end
    end
    hold on;
end

plo = [];
[ I, J ] = size( secAtlas );
numReg = numel( ids );
labelsIll = {};
 for ii = 1 : numel( regionIndicesToPick )
    rr = regionIndicesToPick( ii );
    idReg = ids( rr );
    colReg = colorCodes{ mod( rr, numel( colorCodes ) ) + 1 };
    corAnnotReg = secAtlas == idReg;
    if numel( find( corAnnotReg == 1 ) ) > 0
        [ B, L, N ] = bwboundaries( corAnnotReg );
        for k = 1 : length( B ),
            boundary = B{ k };
            plo( rr ) = plot( boundary( :, 2 ),...
                boundary( :, 1 ), 'color', colorCodes{ rr }, 'LineWidth', lineWidth );
            labelsIll = { labelsIll, labels{ rr } };
        end
    else
        plo( rr ) = 0;
    end
    hold on;
 end

indsLegend = find( plo > 0 );
%hleg = legend( plo( indsLegend ), labels( indsLegend  ), 'Location', 'Northwest', 'FontSize', 12, 'FontWeight', 'b' );
%hleg = legend( plo( indsLegend ), labels( indsLegend  ), 'Location', 'Westoutside', 'FontSize', 14, 'FontWeight', 'b' );
axis off;
% sectionEmpty = secAtlasStandard == 0;
% [ B, L, N ] = bwboundaries( sectionEmpty );
% for k = 1 : length( B ),
%     boundary = B{ k };
%     ploBd = plot( boundary( :, 2 ),...
%           boundary( :, 1 ), 'w', 'LineWidth', lineWidth );
% end
outlineSectionWithAtlasPicked.indsLegend = indsLegend;
outlineSectionWithAtlasPicked.plo = plo;
outlineSectionWithAtlasPicked.labels = labels;