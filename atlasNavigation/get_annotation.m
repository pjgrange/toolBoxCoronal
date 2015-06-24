function [annot] = get_annotation(S,annotName,filtName,valFlag,formatFlag)
% FUNCTION [ANNOT] = GET_ANNOTATION(S,ANNOTNAME,(FILTNAME,VALFLAG,FORMATFLAG))
% Returns an annotation in one of several forms (see below)
% INPUTS:
%  REQUIRED:
%    S - the second level structure containing Allen reference data (e.g.
%        x.Coronal)
%    ANNOTNAME - the name of the annotation to be found in S.Annotations
%  OPTIONAL:
%    filtName - a string containing the name of a filter to be found in
%               S.Filters.  Use [] or 'all' to return all voxels (default)
%    valFlag - indicates which values to return.  Use:
%              'ids' for integer id's (DEFAULT)
%              'labels' for string labels
%              'symbols' for abbreviated strings
%              'parents' for integer id's of the parent structure
%              'all' to return a structure containing all of these as
%              fields
%    formatFlag - indicates the data type to be returned:
%              'vol' for a volume of values (DEFAULT) (If filtered, you
%              will get 0's for all indices not in the filter).
%              'list' for an array of values corresponding to only the
%              filter chosen
%
% OUTPUTS:
%    annot - an annotation containing the data specified by "valFlag" in
%    the form specified by "formatFlag".  If "valFlag" is all, return a
%    struct containing multiple fields, each of the format specified by
%    "formatFlag"
%
% $Rev: 230 $: 
% $Author: jbohland $:
% $Date: 2008-04-15 14:43:51 -0400 (Tue, 15 Apr 2008) $:

if nargin < 3,
    filtName = 'all';
    valFlag = 'ids';
    formatFlag = 'vol';
elseif nargin < 4,
    valFlag = 'ids';
    formatFlag = 'vol';
elseif nargin < 5,
    formatFlag = 'vol';
end;

% Find the filter if one is supplied
try
    postFiltIdx = get_voxel_filter(S,filtName);
catch
    error('Problem retrieving voxel filter %s',filtName);
end;

% grab the annotation, which itself is filtered
annotMatch = strcmpi(S.Annotations.identifier,annotName);
if ~any(annotMatch),
    error('The annotation %s was not found',annotName);
elseif (sum(annotMatch) > 1),
    error('There are multiple matching annotations - please correct this!');
else
    annotIdx = find(annotMatch==1);
    preFiltIdx = get_voxel_filter(S,S.Annotations.filter{annotIdx});
end;

% Note that the annotations are stored in a "pre-filtered" form.  The
% approach here is to create an empty volume, then enter the pre-filtered
% ids, then "post-filter" with the user's specified filter
% First handle the error case
if (~any(strcmpi(valFlag,{'ids','labels','symbols','parents','all'}))),
    error('Invalid valFlag: %s',valFlag);
end;

% get ids block
if (any(strcmpi(valFlag,{'ids','labels','symbols','parents','all'}))),
    volIds = zeros(S.size);
    preFiltIds = S.Annotations.classification{annotIdx};
    volIds(preFiltIdx) = preFiltIds;
    volIds(setdiff([1:numel(volIds)],postFiltIdx)) = 0;
    % If user wants an array, convert
    if strcmpi(formatFlag,'list'),
        volIds = volIds(postFiltIdx);
    end;
end;

% get labels block
if (any(strcmpi(valFlag, {'labels','all'}))),
    volLabels = cell(S.size);
    for i=1:length(preFiltIdx),
        myidx = find(S.Annotations.ids{annotIdx} == ...
            preFiltIds(i));
        volLabels{preFiltIdx(i)} = char(S.Annotations.labels{annotIdx}(myidx));
    end;
    volLabels(setdiff([1:numel(volLabels)],postFiltIdx)) = {''};
    % If user wants an array, convert
    if strcmpi(formatFlag,'list'),
        volLabels = volLabels(postFiltIdx);
    end;
end;

% get symbols block
if (any(strcmpi(valFlag, {'symbols','all'}))),
    volSymbols = cell(S.size);
    for i=1:length(preFiltIdx),
        myidx = find(S.Annotations.ids{annotIdx} == ...
            preFiltIds(i));
        volSymbols{preFiltIdx(i)} = char(S.Annotations.symbols{annotIdx}(myidx));
    end;
    volSymbols(setdiff([1:numel(volSymbols)],postFiltIdx)) = {''};
    % If user wants an array, convert
    if strcmpi(formatFlag,'list'),
        volSymbols = volSymbols(postFiltIdx);
    end;
end;

% get parents block
if (any(strcmpi(valFlag, {'parents','all'}))),
    volParentIds = zeros(S.size);
    % Loop through and get the actual region id (check for 0's)
    for i=1:length(preFiltIdx),
        myidx = find(S.Annotations.ids{annotIdx} == ...
            preFiltIds(i));
        myparent = S.Annotations.parentIdx{annotIdx}(myidx);
        if myparent == 0,
            volParentIds(preFiltIdx(i)) = 0;
        else
            volParentIds(preFiltIdx(i)) = myparent;
        end;
    end;

    volParentIds(setdiff([1:numel(volParentIds)],postFiltIdx)) = 0;
    % If user wants an array, convert
    if strcmpi(formatFlag,'list'),
        volParentIds = volParentIds(postFiltIdx);
    end;
end;

% Now figure out what to return
switch(valFlag),
    case 'ids',
        annot = volIds;
    case 'labels',
        annot = volLabels;
    case 'symbols',
        annot = volSymbols;
    case 'parents',
        annot = volParentIds;
    case 'all',
        annot = struct('ids',volIds,'labels',{volLabels},...
            'symbols',{volSymbols},'parents',volParentIds);
    otherwise
        error('How did this happen?');
end;