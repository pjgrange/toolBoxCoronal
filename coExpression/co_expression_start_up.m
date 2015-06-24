
% constructs the co-expression matrix coExpressionFull
% of the genes corresponding to the columns of the matrix E,
% and extract the submatrix coExpressionSmall 
% corresponding to the list of genes in the file
% nicotineGenes.mat (genes retrieved from the NicSNP database)

load( 'nicotineGenes.mat' );
indsSmall = nicotineGenes.nicotineIndicesInTop75;


%construct coExpressionFull and coExpressionSmall matrices
cor = Ref.Coronal;
brainFilter = get_voxel_filter( cor, 'brainVox' );
leftFilter = get_voxel_filter( cor, 'leftVox' );

[ numVox, numGenes ] = size( E );
Dnormalised = normalise_integral_L2( E );

coExpressionFull = Enormalised' * Enormalised;
coExpressionSmall = coExpressionFull( indsSmall, indsSmall );

%ECentered = center_by_row( E );
%ECenteredNormalized = normalise_integral_L2( DCentered )
%coExpressionFullCentered = ECenteredNormalized' * ECenteredNormalized;