function cellTypesCorrels = cell_types_correls( Ref, D, M, colsToUseInAllen, colsToUseInTypes, typeIndices, options )

if nargin < 7
    if nargin < 6
        % if the list of row indices to use in M is not specified,
        % take all of of them
        numTypes = size( M, 1 );
        typeIndices = 1 : numTypes;
    end
    options = struct( 'savePlots', 0 );
end

cor = Ref.Coronal;
brainFilter = get_voxel_filter( cor, 'brainVox' );

DUsed = D( :, colsToUseInAllen );
MUsed = M( :, colsToUseInTypes );

[ numVox, numGenes ] = size( DUsed );
[ numTypes, numGenes ] = size( MUsed );

MAv = sum( MUsed ) / numTypes;
DAv = sum( DUsed ) / numVox;

MCen = MUsed - repmat( MAv, numTypes, 1 );
DCen = DUsed - repmat( DAv, numVox, 1 );

%types x voxels
MCenNorm = ( normalise_integral_L2( MCen' ) )';
DCenNormPrime = normalise_integral_L2( DCen' );
cellTypesCorrels = MCenNorm * DCenNormPrime;

for tt = 1 : numel( typeIndices )
    typeIndex = typeIndices( tt );
    profileType = cellTypesCorrels( typeIndex, : );
    profileType = make_volume_from_labels( profileType, brainFilter );
    savePlots = options.savePlots;
    if savePlots > 0
       plot_intensity_projections( profileType ); 
       pathToSave = options.pathToSave;
       thisPath = pwd;
       saveas( gcf, [ 'cellTypeProj', num2str( tt ), '.eps' ], 'psc2' );
    end    
    pause( 0.5 );
    close all;
end
cellTypesCorrels = MCenNorm * DCenNormPrime;