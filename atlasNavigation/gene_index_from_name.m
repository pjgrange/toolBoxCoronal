function geneIndexFromName =  gene_index_from_name( geneName, genesAllen )
   
comparisonGene = strcmp( genesAllen, geneName );
geneIndexFromName = find( comparisonGene == 1 );