function coExpressionMatrix = co_expression_matrix( Ref, voxelByGeneData, options )

if nargin < 3
    %take the do-products of brain-wide data by default
    options = struct( 'identifierIndex', 1, 'quantity', 'dotProduct' );
else    
    if ~isfield( options, 'quantity' )
        options.quantity = 'dotProduct';
    end    
end    
identifierIndex = options.identifierIndex;
quantity = options.quantity;

cor = Ref.Coronal;
ann = cor.Annotations;

numVox = size( voxelByGeneData, 1 );
brainFilter = get_voxel_filter( cor, 'brainVox' );
numVoxBrain = numel( brainFilter );
if numVox ~= numVoxBrain
   error( 'The data matrix is not brain-wide' ); 
end    
indsBrain = 1 : numVox;
indsBrain = make_volume_from_labels( indsBrain, brainFilter );
filter = get_voxel_filter( cor, ann.filter{ identifierIndex } );
filteredInds = indsBrain( filter );
%this operation does not change the matrix voxelByGeneData if
%identifierIndex equals 1
voxelByGeneData = voxelByGeneData( filteredInds, : );
if strcmp( quantity, 'dotProduct' )
    voxelByGeneData = normalise_integral_L2( voxelByGeneData );
    coExpressionMatrix = voxelByGeneData' * voxelByGeneData;
else
   error( 'Problem retrieving the definition of co-expression' );
end    