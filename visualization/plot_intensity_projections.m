function plot_intensity_projections(vol,imgtype,labels,border,reorient,cmap,clim,mytitle,options)

% FUNCTION PLOT_INTENSITY_PROJECTIONS(VOL,(IMGTYPE,LABELSBORDER,REORIENT,CMAP))
% - Draw intensity projections in 3 cardinal views (saggital, coronal,
% axial in that order).
%
% INPUTS:
%  REQUIRED:
%   vol : a 3D data volume corresponding to the Allen space (67x41x58)
%  OPTIONAL:
%   imgtype : 'max' for maximum intensity projection (default)
%             'sum' for summed intensity projection.  
%   labels : 1 to write section orientation labels (default), 0 for none
%   border : 1 to draw the brain border (default), 0 for no border
%   reorient : 1 to reorient volume to "standard" views (default),
%              0 to leave volume "as is"
%   cmap : a N x 3 matrix of RGB values to use as a colormap (default is
%          "hot" with black background)
%   clim: choose color scale limits (vector with two elements, cmin and
%   cmax) - default is the max and min of the data

if nargin < 9
   %I don't want a color bar for characteristic functions
   options = struct( 'removeColorbarForBinary', 1 );
   removeColorbarForBinary = options.removeColorbarForBinary;
   if removeColorbarForBinary 
      isBinaryWithoutColorbar = numel( unique( vol ) ) <= 2;
   else
      isBinaryWithoutColorbar = 0;
   end
end    
if nargin < 8, mytitle = []; end;
if nargin < 7, clim = []; end;
if nargin < 6 || isempty(cmap), cmap = [[0 0 0]; hot(64)]; end;
if nargin < 5 || isempty(reorient), reorient = 1; end;
if nargin < 4 || isempty(border), border = 1; end;
if nargin < 3 || isempty(labels), labels = 1; end;
if nargin < 2 || isempty(imgtype), imgtype = 'max'; end;

% NEED TO CHECK FOR BAD INPUTS
proj = cell(3,1); % the intensity projections
for i=1:3,
    if (strcmpi(imgtype,'max')),
        proj{i} = squeeze(max(vol,[],i));
    elseif (strcmpi(imgtype,'sum')),
        proj{i} = squeeze(sum(vol,i));
    elseif (strcmpi(imgtype,'mean')),
      if ~exist('maskProj','var'),
        load refDataStruct.mat;
        filt = Ref.Coronal.Filters.idxArray{2};
        maskProj = make_volume_from_labels(ones(size(filt)), ...
                                           filt);
      end;
      % contract the mask border a bit artificially
      temp = squeeze(sum(maskProj,i));
      temp = temp .* (temp > 0);  % .* (squeeze(sum(maskProj,i)));% ...
%                                          > 25);
      proj{i} = (temp > 0).* (squeeze(sum(vol,i))) ./ (temp+1);% .* (temp > 5)); %squeeze(sum(maskProj,i));
    else
        error(sprintf('Error, unknown IMGTYPE = %s',imgtype));
    end;
end;

% load the boundary data if necessary
if border, 
  % Make sure this file is in your path
  load('allen_brain_boundaries.mat'); 
end;

% Calculate max, min values for color mapping
if (nargin < 7) || (isempty(clim)),
   cmax = max([max(proj{1}(:)) max(proj{2}(:)) max(proj{3}(:))]);
   cmin = min([min(proj{1}(:)) min(proj{2}(:)) min(proj{3}(:))]);
else;
   cmin=clim(1);
   cmax=clim(2);
end
%xpos = [0.025 0.325 0.625]; % positions for axes
if isBinaryWithoutColorbar
    xpos = [0.015 0.32 0.6];
else
    xpos = [0.025 0.325 0.64];
end

% Create a proper figure frame
%h = figure('Color','k','InvertHardCopy','off','Position',[200 200 600 200]);
h = figure('Color','k','InvertHardCopy','off','Position',[200 200 600 180]);
set(h,'PaperPositionMode','auto');  

% --- Draw the saggital image --- 
ax1 = axes('Position',[xpos(1) 0.125 0.3 0.75],'NextPlot','add');
if reorient,
    imagesc(flipud(fliplr(proj{3}')));
else
    imagesc(proj{1});
end;
if border, 
    fmask = fill(bmask{1}(:,1),bmask{1}(:,2),'w');
    set(fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth',1);
end;
caxis([cmin cmax]);

set(gca,'XLim',[-5 67],'YLim',[0 41],'Color','k','Visible','off',...
    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
%set(gca,'XLim',[ 1 66],'YLim',[1 40],'Color','k','Visible','on',...
%    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1],'XDir','reverse');
axis xy;
set(gca,'XDir','reverse');
colormap(cmap);

% --- Draw the coronal axis ---
ax2 = axes('Position',[xpos(2) 0.125 0.3 0.75],'NextPlot','add');
if reorient,
    imagesc(flipud(squeeze(proj{1})));
else
    imagesc(proj{2});
end;
caxis([cmin cmax]);
if border, 
    fmask = fill(bmask{2}(:,1),bmask{2}(:,2),'w');
    set(fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth',1);
end;
set(gca,'XLim',[0 58],'YLim',[0 41],'Color','k','Visible','off',...
    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
%set(gca,'XLim',[1 57],'YLim',[1 40],'Color','k','Visible','on',...
%    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
axis xy ;
colormap(cmap);

% --- Draw the horizontal axis ---
ax3 = axes('Position',[xpos(3) 0.1 0.3 0.8],'NextPlot','add');
if reorient,
    imagesc(flipud(squeeze(proj{2})));
else
    imagesc(proj{3});
end;

caxis([cmin cmax]);
if border, 
    fmask = fill(bmask{3}(:,1),bmask{3}(:,2),'w');
    set(fmask,'FaceColor','none','FaceAlpha',1,'EdgeColor','w','LineWidth',1);
end;
set(gca,'XLim',[0 57],'YLim',[-5 67],'Color','k','Visible','off',...
    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
%set(gca,'XLim',[1 56],'YLim',[1 66],'Color','k','Visible','on',...
%    'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);
axis xy;
colormap(cmap);

% Add a colorbar (constant across views)
if ~isBinaryWithoutColorbar
    cb = colorbar;
    set(cb,'FontSize',16,'LineWidth',2);
end

if (labels),
 % Add text labels to each view
 axes('Position',[0 0 1 1],'Visible','off');
 %h = text(0.175,0.125,'Sagittal','color','w','FontSize',16,'HorizontalAlignment','center');
 %h = text(0.475,0.125,'Coronal','color','w','FontSize',16,'HorizontalAlignment','center');
 %h = text(0.7175,0.125,'Axial','color','w','FontSize',16,'HorizontalAlignment','center');
 h = text(0.175,0.07,'Sagittal','color','w','FontSize',16,'HorizontalAlignment','center');
 h = text(0.475,0.07,'Coronal','color','w','FontSize',16,'HorizontalAlignment','center');
 h = text(0.74,0.07,'Axial','color','w','FontSize',16,'HorizontalAlignment','center');
end;

if ~isempty(mytitle),
  text(0.475,0.75,mytitle,'HorizontalAlignment','center','FontSize',16,'Color','w');
end;

%fileout=fullfile(outputPath,[d(n).name '_ExpEnergy']);
%savefig(fileout,gcf,'-r150','jpeg','-crop');
%close;
%toc;
