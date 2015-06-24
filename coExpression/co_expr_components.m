function coExprComponents = co_expr_components( coExpressionFull, options )

if nargin < 2
    options = struct( 'thresholdInit', 1, 'thresholdStep', 0.02, 'thresholdFinal', 0 );
end  
thresholdInit = options.thresholdInit;
thresholdStep = options.thresholdStep;
if isfield( options, 'thresholdFinal' )
    thresholdFinal = options.thresholdFinal;
else
    thresholdFinal = 0;
end    

threshold = thresholdInit;
thresholds = [];
[ numGenes, otherNumGenes ] = size( coExpressionFull );
% for gg = 1 : numGenes
%     coExpressionFull( gg, gg ) = 0; 
% end
avgSizes = [];
maxSizes = [];
connectedIndices = [];
while threshold > thresholdFinal
    coExpressionCopy = coExpressionFull;
    thresholds = [ thresholds, threshold ];
    coExpressionCopy( coExpressionCopy <= threshold ) = 0;
    [ numComp, conn ] = graphconncomp( sparse( double( coExpressionCopy ) ) );
    compSize = [];
    connectedIndices = [ connectedIndices, conn' ];
    for nn = 1 : numComp
       compSize( nn ) = numel( find( conn == nn ) ); 
    end
    sizeValsLoc = unique( compSize );
    numGraphsForSizeLoc = [];
    for vv = 1 : numel( sizeValsLoc )
        numGraphsForSizeLoc( vv ) = numel( find( compSize == sizeValsLoc( vv ) ) );
    end     
    sizeVals{ numel( thresholds ) } = sizeValsLoc;
    numGraphsForSize{ numel( thresholds ) } = numGraphsForSizeLoc;
    avgSizeLoc = dot( numGraphsForSizeLoc, sizeValsLoc ) / sum( numGraphsForSizeLoc );
    avgSizes = [ avgSizes, avgSizeLoc ];
    maxSizeLoc = max( compSize );
    maxSizes = [ maxSizes, maxSizeLoc ];
    threshold = threshold - thresholdStep;
end    

coExprComponents = struct( 'thresholds', thresholds, 'avgSizes', avgSizes, 'maxSizes', maxSizes, 'connectedIndices', connectedIndices );