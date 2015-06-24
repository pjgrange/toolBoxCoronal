function fitVoxelsToTypesPicked = fit_voxels_to_types_picked( Ref, D, M, colsToUseInAllen, colsToUseInTypes, typeIndicesPicked )
%pick only certain cell types (for purity reasons)

dbstop if error;

numTypesInit = size( M, 1 )
%take all cell types by default
if nargin < 6
    typeIndicesPicked = 1 : numTypesInit; 
    %eliminate the samples with low purity
    %typeIndicesPicked = [ 4, 5, 10 : 13, 15 : 24, 27 : 29, 31 : 32, 35 : 37, 40, 43 : 59, 64 ];
end


dbstop if error;
cor = Ref.Coronal;
ann = cor.Annotations;

[ numVox, numGenesAllen ] = size( D ); 
[ numTypesInit, numGenesTypes ] = size( M );

DTaken = D( :, colsToUseInAllen );
%eliminate the samples with low purity
MTaken = M( typeIndicesPicked, colsToUseInTypes );

numTypesTaken = numel( typeIndicesPicked );
[ numTypes, numGenesTypes ] = size( MTaken );

typeByType = MTaken * MTaken';
diagNegTypes = diag( -1 * ones( numTypes, 1 ) );
refZeroTypes = zeros( numTypes, 1 );

MTakenGeneByType = MTaken';
%study caudoputamen
annotFine = get_annotation( cor, 'fine' );
idsFine = ann.ids{ 4 };
brainFilter = get_voxel_filter( cor, 'brainVox' );
annotFine = annotFine( brainFilter );
warning off;

for vv = 1 : numVox
    if mod( vv, 1000 ) == 0
      vv
    end
    voxelData = DTaken( vv, : );
    %a column to fit
    voxelData = voxelData';
    fitVoxelsToTypesBis( vv, : ) = lsqlin( MTakenGeneByType, double( voxelData ), diagNegTypes, refZeroTypes );
end
if size( fitVoxelsToTypesBis, 1 ) < numVox
    fitVoxelsToTypesBis( numVox, numTypes ) = 0;
    brainFilter = get_voxel_filter( cor, 'brainVox' );
end

%reorganize the type indices in the same array as the complete list of cell
%types


for tt = 1 : numTypesInit
  tt  
  takenPositionInTypesTaken = find( typeIndicesPicked == tt ); 
  if ~isempty( takenPositionInTypesTaken )
      fitVoxelsToTypesPicked( :, tt ) = fitVoxelsToTypesBis( :, takenPositionInTypesTaken( 1 ) );
      volForType = make_volume_from_labels( fitVoxelsToTypesPicked( :, tt ), brainFilter );
      plot_intensity_projections( volForType );
      pause( 3 );
  else    
      fitVoxelsToTypesPicked( :, tt ) = zeros( numVox, 1 );
  end
end  
