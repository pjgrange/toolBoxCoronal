 function [genes] = get_genes(S,filtName,flag)
% FUNCTION [GENES] = GET_GENES(S,(FILTNAME,FLAG))
% Returns the list of genes as strings provided by Allen Institut (default)
% or as Entrez IDs.
% INPUTS:
%  REQUIRED:
%    S - the second level structure containing Allen reference data (e.g.
%        x.Coronal)
%  OPTIONAL:
%    filtName - a string containing the name of a filter to be found in
%               S.Genes.Filters.  Use [] or 'all' to return all (default)
%    flag - either 'allen' for the names provided by the Allen Institute
%    (default) or 'entrez' for Entrez ID's
% OUTPUTS:
%    genes - a list of genes as either a cell array of strings (allen
%    names) or as a vector of integers (entrez IDs)
%
% $Rev: 181 $: 
% $Author: jbohland $:
% $Date: 2008-03-27 14:16:38 -0400 (Thu, 27 Mar 2008) $:

if nargin < 2, 
    filtName = 'all';
    flag = 'allen';
elseif nargin < 3,
    flag = 'allen';
end;

if isempty(filtName),
    filtName = 'all';
end;

try
    idx = get_gene_filter(S,filtName);
catch
    error('Problem retrieving gene filter %s',filtName);
end;

if (strcmpi(flag,'allen')),
    genes = S.Genes.allenNames{1}(idx);
elseif (strcmpi(flag,'entrez')),
    genes = S.Genes.entrezIds{1}(idx);
else
    error('Flag %s is not understood',flag);
end;
