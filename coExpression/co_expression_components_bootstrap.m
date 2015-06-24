function coExpressionComponentsBootStrap = co_expression_components_bootstrap( coExpressionFull, coExpressionSmall, options )
% takes the full co-expression matrix coExpressionFull and the submatrix
% coExpressionSmall corresponding to autism-relatex genes only, and for
% values of the threshold specified in the options, study the average size
% of the connected components of the thresholded matrix.
%
% Does the same thing for numDraws random draws of submatrices of coExpressionFull,
% all of the same size as coExpressionSmall
%

if nargin < 3
    options = struct( 'thresholdInit', 1, 'thresholdStep', 0.02, 'cols', '.k',...
                      'numDraws', 200, 'thresholdFinal', 0 );
end
if isfield( options, 'randomIndices' )
    randomIndices = options.randomIndices;
else
    %draw randomIndices               
    numDraws = options.numDraws;
    numGenesFull = size( coExpressionFull, 1 );
    numGenesSmall = size( coExpressionSmall, 1 );
    randomIndices = zeros( numDraws, numGenesSmall );
    randomIndices = random_indices( numGenesFull, numGenesSmall, numDraws );           
end
numDraws = options.numDraws;
[ numGenesFull, otherNumGenesFull ] = size( coExpressionFull );
[ numGenesSmall, otherNumGenesSmall ] = size( coExpressionSmall );
coexprComponentsSmall = co_expr_components( coExpressionSmall, options );
thresholds = coexprComponentsSmall.thresholds;
avgSizesSmall = coexprComponentsSmall.avgSizes;
maxSizesSmall = coexprComponentsSmall.maxSizes;
for pp = 1 : numDraws
    indsDraw = randomIndices( pp, : );
    coExprDrawn = coExpressionFull( indsDraw, indsDraw );
    coexprIsland = co_expr_components( coExprDrawn, options );
    avgSizes( pp, : ) = coexprIsland.avgSizes;
    maxSizes( pp, : ) = coexprIsland.maxSizes;
    thresholds = coexprIsland.thresholds;
end
%at every column of avgSizes and maxSizes, there is a distribution of numbers
%across praws, study it
avgSizeMean = sum( avgSizes ) / numDraws;
maxSizeMean = sum( maxSizes ) / numDraws;
numThresholds = size( avgSizes, 2 );
thresholds = coexprIsland.thresholds;
for tt = 1 : numThresholds
    thresholdLoc = thresholds( tt );
    distributionLocAvg = avgSizes( :, tt );
    distributionLocMax = maxSizes( :, tt );
    studiedLocAvg = avgSizesSmall( tt );
    studiedLocMax = maxSizesSmall( tt );
    meanDistributionLocAvg = mean( distributionLocAvg );
    SDDistributionLocAvg = std( distributionLocAvg );
    SDDistributionAvg( tt ) = std( distributionLocAvg );
    meanDistributionLocMax = mean( distributionLocMax );
    SDDistributionLocMax = std( distributionLocMax );
    SDDistributionMax( tt ) = std( distributionLocMax );
    %numbers of s.ds
    if  SDDistributionLocAvg > 0
        devFromMeanAvgInSDs( tt ) = ( studiedLocAvg - meanDistributionLocAvg ) / SDDistributionLocAvg;
    else
        devFromMeanAvgInSDs( tt ) = 0;
    end
    if  SDDistributionLocMax > 0
        devFromMeanMaxInSDs( tt ) = ( studiedLocMax - meanDistributionLocMax ) / SDDistributionLocMax;
    else
        devFromMeanMaxInSDs( tt ) = 0;
    end
    %probabilities
    PAvgSpecialLarger( tt ) = numel( find( studiedLocAvg > distributionLocAvg ) ) / numDraws;
    PMaxSpecialLarger( tt ) = numel( find( studiedLocMax > distributionLocMax ) ) / numDraws;
end

coExpressionComponentsBootStrap = struct( 'thresholds', thresholds, 'avgSizes', avgSizes, 'avgSizeMean', avgSizeMean,...
    'maxSizes', maxSizes, 'maxSizeMean', maxSizeMean,...
    'avgSizesSmall', avgSizesSmall, 'maxSizesSmall', maxSizesSmall,...
    'deviationFromMeanAvgInSDs', devFromMeanAvgInSDs, 'deviationFromMeanMaxInSDs', devFromMeanMaxInSDs,...
    'PAvgSpecialLarger', PAvgSpecialLarger, 'PMaxSpecialLarger', PMaxSpecialLarger,...
    'numDraws', numDraws );