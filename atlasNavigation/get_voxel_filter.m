function [filt] = get_voxel_filter(S,filtName,flag)
% FUNCTION [FILT] = GET_VOXEL_FILTER(S,FILTNAME,(FLAG))
% Returns the voxel filter named "filtName" as the type specified in flag
% INPUTS:
%  REQUIRED:
%    S - the second level structure containing Allen reference data (e.g.
%        x.Coronal)
%    filtName - a string containing the name of a filter to be found in
%               S.Filters
%  OPTIONAL:
%    flag - either 'list' (default) indicating you want a list (array) of
%           indices into the volume implied by S or 'mask' indicating you
%           want a volumetric mask with 1's in the filter indices, and 0's 
%           elsewhere
%
% $Rev: 169 $: 
% $Author: jbohland $:
% $Date: 2008-03-26 23:14:30 -0400 (Wed, 26 Mar 2008) $:

if nargin < 2,
    error(help(mfilename));
elseif nargin < 3,
    flag = 'list';
end;

% Find this filter (if it exists and is unique)
filtMatch = strcmpi(S.Filters.identifier,filtName);
if ~any(filtMatch),
    error('The filter %s was not found',filtName);
elseif (sum(filtMatch) > 1),
    error('There are multiple matching filters - please correct this!');
else
    thisFilt = S.Filters.idxArray{find(filtMatch==1)};
end;

% Return the use the data structure she wants
switch(flag),
    case 'list' 
        filt = thisFilt;
        % The user wants the filter as a list of indices
    case 'mask'
        filt = zeros(S.size);
        filt(thisFilt) = 1;
        % The user wants the filter as a volumetric mask (0's and 1's)
    otherwise
        error('Flag %s not recognized',flag);
end;
