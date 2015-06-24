function extractComponentByPValue = extract_component_by_p_value_old( Ref, D, coExprComponentsAnatomy, probaCrit )

cor = Ref.Coronal;
ann = cor.Annotations;
brainFilter = get_voxel_filter( cor, 'brainVox' );
genesAllen = get_genes( cor, 'top75CorrNoDup', 'allen' );

numThresh = numel( coExprComponentsAnatomy.threshold );

identifierIndex = coExprComponentsAnatomy.fittingScoresComp{ numThresh }{ 1 }.fittingScores.identifierIndex;
labels = ann.labels{ identifierIndex };

fittingOfComps = coExprComponentsAnatomy.fittingScoresComp;
numCompsFound = 0;
for tt = 1 : numThresh
    compsAtThreshold = fittingOfComps{ tt };
    thresholdLoc = coExprComponentsAnatomy.threshold{ tt };
    numCompsAtThreshold = numel( compsAtThreshold );
    if numCompsAtThreshold > 0
        for nn = 1 : numCompsAtThreshold
            pValsStudy = compsAtThreshold{ nn }.fittingScores.pVals;
            indsCritAtlas = find( pValsStudy < probaCrit );
            if numel( indsCritAtlas ) > 0
               indsComp = compsAtThreshold{ nn }.geneIndicesInAtlas;
               %display( labels( indsCritAtlas ) );
               geneNames = genesAllen( indsComp );
               %plot_intensity_projections( make_volume_from_labels( ( sum( D( :, indsComp )' ) )', brainFilter ) );
               %pause;
               numCompsFound = numCompsFound + 1;
               extractComponentByPValue.threshold{ numCompsFound } = thresholdLoc;
               extractComponentByPValue.regionCritIndicesInAtlas{ numCompsFound } = indsCritAtlas;        
               extractComponentByPValue.regionCritNamesInAtlas{ numCompsFound } = labels{ indsCritAtlas };   
               extractComponentByPValue.identifierIndex{ numCompsFound } = identifierIndex;      
               extractComponentByPValue.identifier{ numCompsFound } = ann.identifier{ identifierIndex };     
               extractComponentByPValue.numGenesInComponent{ numCompsFound } =  numel( indsComp );
               extractComponentByPValue.geneIndicesInAtlas{ numCompsFound } = indsComp;                   
               extractComponentByPValue.geneNames{ numCompsFound } = geneNames;               
               extractComponentByPValue.pValsInAtlas{ numCompsFound } = pValsStudy;      
               extractComponentByPValue.probaCrit{ numCompsFound } = probaCrit    ;    
            end
        end
    end
    hold off; 
    close all;
end    

