function [V] = make_volume_from_labels(labels,volIdx)

% FUNCTION MAKE_VOLUME_FROM_LABELS(LABELS,(VOLIDX)) - Make a full 3D volume
% (67 x 41 x 58) from a vector of integer/real labels 
%
% INPUTS:
%  REQUIRED:
%   labels : a vector of integers/reals to be assigned to voxels in the volume
%  OPTIONAL:
%   volIdx : a vector (same length as labels) that specifies the entries
%   (in 1-D index form) of the entries in which to put each entry of
%   "labels."  Default is the list in *** (the annotated voxels in the 
%   Allen Reference Atlas)
%
% OUTPUTS:
%   V : a 67 x 41 x 58 volume with "labels" entered at "volidx" entries;
%   zeros elsewhere.

if nargin < 1,
    error('help make_volume_from_labels');
elseif nargin < 2,
    load refDataStruct;
    volIdx = get_voxel_filter(Ref.Coronal,'brainVox');
    clear x;
end;

if (numel(labels) ~= numel(volIdx)),
    error('Labels and volume indices must have same number of elements');
end;

V = zeros(67,41,58);
V(volIdx) = labels;
