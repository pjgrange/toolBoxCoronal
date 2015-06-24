function cellTypeVolPrepare = cell_type_vol_prepare( Ref, correlsVol, options )
%correlsVol is a 67x41x58 volume, filled with correlations between a given cell type and the Allen
%Atlas, or any other volume for that matters
dbstop if error;
if nargin < 3
    options = struct(  'savePlots', 0, 'sectionStyle', 'coronal',...
                       'lineWidth', 2, 'identifierIndex', 5, 'regionIndexForSection', 2,...
                       'customIndex', 0, 'desiredIndex', 30 );               
end

identifierIndex = options.identifierIndex;
regionIndexForSection = options.regionIndexForSection;

%thresholdFitting = options.thresholdFitting; 

sectionStyle = options.sectionStyle;

if isfield( options, 'lineWidth' );
    lineWidth = options.lineWidth;
else
    lineWidth = 2;
end

%annotation for anatomy and annotation for the whole brain
cor = Ref.Coronal;
ann = cor.Annotations;
brainFilter = get_voxel_filter( cor, 'brainVox' );
annot = get_annotation( cor, ann.identifier{ identifierIndex } );
annotStandard = get_annotation( cor, 'standard' );
ann = cor.Annotations;
ids = ann.ids{ identifierIndex };
labels = ann.labels{ identifierIndex };
numReg = numel( ids );
[ C, A, S ] = size( annot );

coronalStyle = strcmp( sectionStyle, 'coronal' );
sagittalStyle = strcmp( sectionStyle, 'sagittal' ); 
axialStyle = strcmp( sectionStyle, 'axial' );
customIndex = options.customIndex;

%work out the section that intersects the region of interest
%along the largest possible area
idForSection = ids( regionIndexForSection );
annotSec = [];
intensitySec = [];
intenseIndex = [];
%make sure that the section intersects the desired region and  
%important voxels in the volume
if coronalStyle
    for cc = 1 : C
        annotSec( :, : ) = annot( cc, :, : );
        volSec( :, : ) = correlsVol( cc, :, : );
        annotSec( annotSec ~= idForSection ) = 0;
        annotSec( annotSec ~= 0 ) = 1;
        intensitySec( cc ) = sum( sum( annotSec ) );
        volMax( cc ) = max( volSec( : ) );
    end
elseif sagittalStyle
    for ss = 1 : S
        annotSec( :, : ) = annot( :, :, ss );
        volSec( :, : ) = correlsVol( :, :, ss );
        annotSec( annotSec ~= idForSection ) = 0;
        annotSec( annotSec ~= 0 ) = 1;
        intensitySec( ss ) = sum( sum( annotSec ) );
        volMax( ss ) = max( volSec( : ) );
    end
elseif axialStyle
    for aa = 1 : A
        annotSec( :, : ) = annot( :, aa, : );
        volSec( :, : ) = correlsVol( :, aa, : );
        annotSec( annotSec ~= idForSection ) = 0;
        annotSec( annotSec ~= 0 ) = 1;
        intensitySec( aa ) = sum( sum( annotSec ) );
        volMax( aa ) = max( volSec( : ) );
    end
end
%intenseIndex = find( intensitySec == max( intensitySec ) );
%intenseIndex = intenseIndex( 1 );
intersectionIndices = find( intensitySec > 2 );
volMaxIntersection = volMax( intersectionIndices );
volMaxIntersectionMax = max( volMaxIntersection );
intenseIndex = intersectionIndices( find( volMaxIntersection == volMaxIntersectionMax ) );
%if there are several such indices, take the one that has the largest
%intersection with the region
intensitiesFromIndices = intensitySec( intenseIndex );
maxSection = find( intensitiesFromIndices == max( intensitiesFromIndices ) );
intenseIndex = intenseIndex( maxSection( 1 ) );

%pause;
%one may want to specify the section index by hand
if customIndex
   intenseIndex = options.desiredIndex;
end    
    
%maximal-intensity projections
for ss = 1 : 3
    projCorrels{ ss } = squeeze( max( correlsVol, [], ss ) );
end
cellTypeVolPrepare.projCorrels = projCorrels;

if coronalStyle
    secCorrels( :, : ) = correlsVol( intenseIndex, :, : );

    secCorrels = flipud( secCorrels );
    minCorrels = min( min( secCorrels ) );

    secAtlas( :, : ) = annot( intenseIndex, :, : );
    secAtlas = flipud( secAtlas );
    secAtlasStandard( :, : ) = annotStandard( intenseIndex, :, :  );
    secAtlasStandard = flipud( secAtlasStandard );
    secAtlasBig( :, : ) = annot( intenseIndex, :, :  );
    secAtlasBig = flipud( secAtlasBig );
    %use the minimum value to blacken the outside of the brain
    bMask = find( secAtlasStandard == 0 );
    secCorrels( bMask ) = minCorrels;

elseif sagittalStyle

    secCorrels( :, : ) = correlsVol( :, :, intenseIndex );
    secCorrels = secCorrels';

    secCorrels = flipud( secCorrels );

    secAtlas( :, : ) = annot( :, :, intenseIndex );
    secAtlasStandard( :, : ) = annotStandard( :, :, intenseIndex );
    secAtlas = secAtlas';
    secAtlas = flipud( secAtlas );
    secAtlasStandard = secAtlasStandard';
    secAtlasStandard = flipud( secAtlasStandard );
    secAtlasBig = annot( :, :, intenseIndex  );
    secAtlasBig = secAtlasBig';
    secAtlasBig = flipud( secAtlasBig );

    bMask = find( secAtlasStandard == 0 );
    minCorrels = min( min( secCorrels ) );
    secCorrels( bMask ) = minCorrels;
elseif axialStyle

    secCorrels( :, : ) = correlsVol( :, intenseIndex, : );
    secCorrels = secCorrels';

    secAtlas( :, : ) = annot( :, intenseIndex, : );
    secAtlasStandard( :, : ) = annotStandard( :, intenseIndex, : );
    secAtlas = secAtlas';
    secAtlasBig = secAtlas;
    secAtlasStandard = secAtlasStandard';
    minCorrels = min( min( secCorrels ) );
    bMask = find( secAtlasStandard == 0 );
    secCorrels( bMask ) = minCorrels;
else
    sectionMessage = 'section style not set properly'
end

cellTypeVolPrepare.secCorrels = secCorrels;
cellTypeVolPrepare.sectionStyle = sectionStyle;
cellTypeVolPrepare.secAtlasStandard = secAtlasStandard;
cellTypeVolPrepare.secAtlasBig = secAtlasBig;
cellTypeVolPrepare.intenseIndex = intenseIndex;
