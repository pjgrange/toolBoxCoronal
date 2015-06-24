function annotationBig12ToFine = annotation_big12_to_fine( Ref, identifierIndex )

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

for bb = 1 : numel( idsBig)
    idBig = idsBig( bb );
    valsFine = unique( annotFine( find( annotBig == idBig ) ) );
    indicesFine = [];   
    for vv = 1 : numel( valsFine )
       valFine = valsFine( vv );
       if valFine ~= 0 
           indicesFine = [ indicesFine, find( idsFine == valFine ) ];
       end
    end    
    annotationBig12ToFine.indicesInFineAtlas{ bb } = indicesFine;
    annotationBig12ToFine.subregionsInFineAtlas{ bb } = labelsFine( indicesFine );
    annotationBig12ToFine.labelBig{ bb } = labelsBig{ bb };
end
