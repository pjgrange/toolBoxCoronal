function upperDiagonalCoeffs = upper_diagonal_coeffs( C )

[ numLines, numCols ] = size( C );
numLim = min( numLines, numCols );
upperDiagonalCoeffs = [];
for ll = 1 : numLim - 1
    line = C( ll, : );
    upperDiagonalCoeffs = [ upperDiagonalCoeffs, line( ll + 1 : numCols ) ];
end    