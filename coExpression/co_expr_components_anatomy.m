function coExprComponentsAnatomy = co_expr_components_anatomy( Ref, D, coExprComponents, colIndicesForNetwork, options )
%Inputs: coExprComponents = co_expr_components( coExpressionNetwork )
%For instance colIndicesForNetwork = nicotineGenes.nicotineIndicesInTop75,
%and associated co-expression network

%put zeros instead of NaN at voxels with zero expression, when computing
%the qotients of expression volumes
%sumDNormalized( sumDNormalized == 0 ) = 1;
if nargin < 5
   options = struct( 'minimalComponentSize', 2, 'identifierIndex', 5, 'numDraws', 100 );
end
numDraws = options.numDraws;
identifierIndex = options.identifierIndex;

%study the connected components with at least minimalComponentSize genes
minimalComponentSize = options.minimalComponentSize;
cor = Ref.Coronal;
brainFilter = get_voxel_filter( cor, 'brainVox' );

thresholds = coExprComponents.thresholds;
connectedIndices = coExprComponents.connectedIndices;
%the j-th column of connectedIndices encodes the partition of the nodes at
%a threshold corresponding to the j-th entry of thresholds

%precompute sets of genes
numGenesAtlas = size( D, 2 );

numThresholds = numel( thresholds );
for tt = 1 : numThresholds
    thresholdLoc = thresholds( tt );
    componentIndicesLoc = connectedIndices( :, tt );
    labelsLoc = unique( componentIndicesLoc );
    numLargeComps( tt ) = 0;
    fittingScoresComp = {};
    for ll = 1 : numel( labelsLoc )
        labelComp = labelsLoc( ll );
        indsComp = find( componentIndicesLoc == labelComp );
        numGenesComp = numel( indsComp );
        if numGenesComp > minimalComponentSize
            numLargeComps( tt ) = numLargeComps( tt ) + 1;
            thresholdLoc = thresholds( tt );
            geneIndices = colIndicesForNetwork( indsComp );
            exprComp = D( :, geneIndices );
            exprCompSum = ( sum( exprComp' ) )';
            exprCompNormalized = normalise_integral( exprCompSum );
            %exprCompAvgVol = make_volume_from_labels( exprCompAvg, brainFilter );
            %plot_intensity_projections( exprCompAvgVol );
            %exprCompQuotientVol = make_volume_from_labels( exprCompNormalized ./ sumDNormalized, brainFilter );
            %display( numGenesComp );
            %plot_intensity_projections( exprCompQuotientVol );
            %pause;           
            %compute the fitting scores of the component
            fittingScoresComponent = fitting_scores_region_by_gene( Ref, exprCompNormalized, identifierIndex );
            %simulate the scores for sets of the same size 
            optionsFitting = struct( 'identifierIndex', identifierIndex, 'numDraws', numDraws, 'saveIndices', 0 ); 
            fittingDistributionInAtlas = fitting_distribution_in_atlas( Ref, D, numGenesComp, optionsFitting );
            fittingScoresProbaLoc = fitting_scores_proba( fittingScoresComponent, fittingDistributionInAtlas );
            fittingScoresComp{ numLargeComps( tt ) } = struct( 'geneIndicesInAtlas', geneIndices, 'fittingScores', fittingScoresProbaLoc );
            pause( 1 );            
        end 
    end   
    coExprComponentsAnatomy.fittingScoresComp{ tt } = fittingScoresComp;
    coExprComponentsAnatomy.threshold{ tt } = thresholdLoc;
    coExprComponentsAnatomy.numDraws{ tt } = numDraws;
    coExprComponentsAnatomy.numLargeComps{ tt } = numLargeComps( tt );
    %display( numLargeComps );
    hold off;
    close all;
end    

