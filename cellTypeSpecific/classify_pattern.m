function classifyPatterns = classify_pattern( Ref, cellTypesCorrelations, fitVoxelsToTypes, options )

if nargin < 4
    options = struct( 'identifierIndex', 5 );
end
identifierIndex = options.identifierIndex;
cor = Ref.Coronal;
ann = cor.Annotations;
brainFilter = get_voxel_filter( cor, 'brainVox' );

regionByTypeFractionCorrelations = region_by_type_fraction( cellTypesCorrelations, identifierIndex );
regionByTypeFractionFittings = region_by_type_fraction( fitVoxelsToTypes, identifierIndex );
regionByTypeAverageCorrelations = region_by_type_average( cellTypesCorrelations, identifierIndex );
regionByTypeAverageFittings = region_by_type_average( fitVoxelsToTypes, identifierIndex );

classifyPatterns.regionByTypeFractionCorrelations =regionByTypeFractionCorrelations;
classifyPatterns.regionByTypeFractionFittings = regionByTypeFractionFittings;
classifyPatterns.regionByTypeAverageCorrelations = regionByTypeAverageCorrelations;
classifyPatterns.regionByTypeAverageFittings = regionByTypeAverageFittings;

rankRegionsFractionCorrelations = rank_regions( regionByTypeFractionCorrelations );
rankRegionsFractionFittings = rank_regions( regionByTypeFractionFittings );
rankRegionsAverageCorrelations = rank_regions( regionByTypeAverageCorrelations );
rankRegionsAverageFittings = rank_regions( regionByTypeAverageFittings );

classifyPatterns.rankRegionsFractionCorrelations = rankRegionsFractionCorrelations;
classifyPatterns.rankRegionsFractionFittings = rankRegionsFractionFittings;
classifyPatterns.rankRegionsAverageCorrelations = rankRegionsAverageCorrelations;
classifyPatterns.rankRegionsAverageFittings = rankRegionsAverageFittings;

    function regionByTypeFraction = region_by_type_fraction( voxelByType, identifierIndex )
        ids = ann.ids{ identifierIndex };
        numRegions = numel( ids );
        labels = ann.labels{ identifierIndex };
        filter = get_voxel_filter( cor, ann.filter{ identifierIndex } );
        annot = get_annotation( cor, ann.identifier{ identifierIndex } );
        annotMasked = annot( filter );
        for rr = 1 : numRegions
            voxelIndices{ rr } = find( annotMasked == ids( rr ) );
        end
        numTypes = size( voxelByType, 2 );
        for tt = 1 : numTypes
            colForType = voxelByType( :, tt );
            volForType = make_volume_from_labels( colForType, brainFilter );
            colForTypeMasked = volForType( filter );
            typeSignal = sum( abs( colForTypeMasked ) );
            if typeSignal > 0
                %normalise the whole colum
                colForTypeMasked = colForTypeMasked / typeSignal;
                for rr = 1 : numRegions
                    regionByTypeFraction( rr, tt ) = sum( colForTypeMasked(  voxelIndices{ rr } ) );
                end
            else
                regionByTypeFraction( :, tt ) = zeros( numRegions, 1 );
            end
        end
    end

    function regionByTypeAverage = region_by_type_average( voxelByType, identifierIndex )
        ids = ann.ids{ identifierIndex };
        numRegions = numel( ids );
        labels = ann.labels{ identifierIndex };
        filter = get_voxel_filter( cor, ann.filter{ identifierIndex } );
        annot = get_annotation( cor, ann.identifier{ identifierIndex } );
        annotMasked = annot( filter );
        for rr = 1 : numRegions
            voxelIndices{ rr } = find( annotMasked == ids( rr ) );
            numVoxelIndices( rr ) = numel( voxelIndices{ rr } );
        end
        numTypes = size( voxelByType, 2 );
        for tt = 1 : numTypes
            colForType = voxelByType( :, tt );
            volForType = make_volume_from_labels( colForType, brainFilter );
            colForTypeMasked = volForType( filter );
            typeSignal = sum( abs( colForTypeMasked ) );
            if typeSignal > 0
                for rr = 1 : numRegions
                    regionByTypeAverage( rr, tt ) = sum( colForTypeMasked(  voxelIndices{ rr } ) ) / numVoxelIndices( rr );
                end
            else
                regionByTypeAverage( :, tt ) = zeros( numRegions, 1 );
            end
        end
    end


    function rankRegions = rank_regions( regionByType )
        numTypes = size( regionByType, 2 );
        for tt = 1 : numTypes
            scoreForType = regionByType( :, tt );
            [ vals, inds ] = sort( scoreForType, 'descend' );
            rankRegions( :, tt ) = inds; 
        end
    end
end






