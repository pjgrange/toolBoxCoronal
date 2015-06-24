function figureForTypeDensity = figure_for_type_density( Ref, vol, options )

if nargin < 3
    options = struct( 'identifierIndex', 5, 'sectionStyle', 'coronal' );
end    

identifierIndex = options.identifierIndex;
sectionStyle = options.sectionStyle;
stripDim = [ 200 200 1350 260 ];
optionsVol = struct( 'regionChoice', 'maxFraction', 'sectionStyle', sectionStyle,...
           'customIndex', 0, 'desiredIndex', 36, 'identifierIndex', identifierIndex, 'isCorrelation', 0, 'isFitting', 1,...
           'fontSize', 18, 'fontSizeAtlas', 16, 'corMult', 0.94, 'stripDim', stripDim, 'xPosProj', [ 0.01, 0.16, 0.3, 0.45, 0.61, 0.76, 0.77],...
           'labelForType', '' );
figureForTypeDensity  = figure_for_types( Ref, {vol}, {optionsVol} );