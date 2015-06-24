function cumulCoExpr = cumul_co_expr( coExpressionFull, coExpressionSmall, options )
dbstop if error;
if nargin < 3
   options = struct( 'numPaths', 200, 'coExprStep', 0.01, 'minCoExpr', 0, 'maxCoExpr', 1, 'wantPlots', 1, 'species', 'mouse' ); 
end    

numPaths = options.numPaths;
coExprStep = options.coExprStep;
wantPlots = options.wantPlots;
species = options.species;
%study co-expression between 0 and 1 by default
maxCoExpr = options.maxCoExpr;
minCoExpr = options.minCoExpr;


coExprGrid = minCoExpr : coExprStep : maxCoExpr;



numGenesFull =  size( coExpressionFull, 1 );
numGenesSmall =  size( coExpressionSmall, 1 );

cumulDistrSpecial = cumul_distr( coExpressionSmall, coExprGrid );

for pp = 1 : numPaths 
   permLoc = randperm( numGenesFull ); 
   indsLoc = permLoc( 1 : numGenesSmall );
   coExpressionLoc = coExpressionFull( indsLoc, indsLoc );
   cumulDistrSimul( pp, : ) =  cumul_distr( coExpressionLoc, coExprGrid );
end

%statistics of cdfs across paths at fixed thresholds
numSteps = numel( coExprGrid );
for nn = 1 : numSteps 
   meanCumul( nn ) = mean( cumulDistrSimul( :, nn ) );
   stdCumul( nn ) = std( cumulDistrSimul( :, nn ) );
   numStDevsSpecialFromSimul( nn ) = ( cumulDistrSpecial( nn ) - meanCumul( nn ) ) / stdCumul( nn );
end
 
cumulCoExpr.cumulDistrSpecial = cumulDistrSpecial;
cumulCoExpr.coExprGrid = coExprGrid;
cumulCoExpr.meanCumul = meanCumul;
cumulCoExpr.stdCumul = stdCumul;
cumulCoExpr.numStDevs = numStDevsSpecialFromSimul;

    function cumulDistr = cumul_distr( symMatrix, threshGrid )
        upperCoeffs = upper_diagonal_coeffs( symMatrix );
        upperCoeffs = sort( upperCoeffs, 'ascend' );
        numCoeffs = numel( upperCoeffs );
        numThresh = numel( threshGrid );
        for nn = 1 : numThresh
            threshLoc = threshGrid( nn );
            if threshLoc > minCoExpr
                threshLoc = threshGrid( nn );
                indsSmaller = find( upperCoeffs <= threshLoc );
                if ~isempty( indsSmaller )
                    %cumulDistr( nn ) = max( indsSmaller ) / numCoeffs;
                    cumulDistr( nn ) = numel( indsSmaller ) / numCoeffs;
                else
                    cumulDistr( nn ) = 0;
                end
            else
               cumulDistr( nn ) = 0;
           end    
        end      
    end
end