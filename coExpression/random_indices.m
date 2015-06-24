function randomIndices = random_indices( numObjectsFull, numObjectsSmall, numDraws )

randomIndices = zeros( numDraws, numObjectsSmall );
for pp = 1 : numDraws
    permLoc = randperm( numObjectsFull );
    randomIndices( pp, : ) =  permLoc( 1 : numObjectsSmall );
end