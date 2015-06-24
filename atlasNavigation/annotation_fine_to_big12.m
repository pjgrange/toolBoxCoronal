function annotationFineToBig12 = annotation_fine_to_big12( Ref, identifierIndex )

if nargin < 2
   identifierIndex = 4; 
end    

cor = Ref.Coronal;
ann = cor.Annotations;
identifierIndexBig = 5;
annotBig = get_annotation( cor, ann.identifier{ identifierIndexBig  } );
idsBig = ann.ids{ identifierIndexBig };
labelsBig = ann.labels{ identifierIndexBig };  

annotFine = get_annotation( cor, ann.identifier{ identifierIndex } );
idsFine = ann.ids{ identifierIndex };
labelsFine = ann.labels{ identifierIndex };
for ff = 1 : numel( idsFine )
    idFine = idsFine( ff );
    annotLoc = annotFine;
    annotLoc( annotLoc ~= idFine ) = 0;
    valsBig = unique( annotBig( find( annotFine == idFine ) ) );
    if numel( valsBig ) ~= 1
        errorAtlasToBig = 'The annotation is not compatible with Big12'
        else
            indexParentBigAtlas( ff ) = find( idsBig == valsBig );
        end
end    
labelsParentBigAtlas = labelsBig( indexParentBigAtlas );
annotationFineToBig12.labelsFine = labelsFine;
annotationFineToBig12.indexParentBigAtlas = indexParentBigAtlas;
annotationFineToBig12.labelsParentBigAtlas = labelsParentBigAtlas;