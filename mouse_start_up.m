clear all;
load( 'ExpEnergytop75percent.mat' );
load( 'refAtlas.mat' );
dbstop if error;
E = D;
clear D;
mousePath = pwd;
addpath( genpath( mousePath ) );
cor = Ref.Coronal;
brainFilter = get_voxel_filter( cor, 'brainVox' );
genesAllen = get_genes( cor, 'top75corrNoDup', 'allen' );
genesEntrez = get_genes( cor, 'top75corrNoDup', 'entrez' );