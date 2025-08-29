function [odf, odf_rec, error] = generate_random_HCP_starting_texture(path,nOrientations, CS, SS, psi)

pfAnnotations = @(varargin) text([vector3d.X,vector3d.Y],{'RD','TD'},...
  'BackgroundColor','w','tag','axesLabels',varargin{:});
setMTEXpref('pfAnnotations',pfAnnotations);
plotx2east;

odf = uniformODF(CS,SS);

h = Miller({0,0,0,1},{1,0,-1,0},{1,1,-2,0},CS);

ori = odf.discreteSample(nOrientations);

odf_rec = calcDensity(ori,psi);

f=figure;
plotPDF(odf_rec,h);
hold on;
plotPDF(odf_rec,h,'contour',0:0.1:2,'linecolor','k','linewith',2, 'ShowText', 'on');
hold off;
mtexColorMap LaboTeX;
mtexColorbar;
setColorRange([0 2]);
mtexColorbar('location','south', 'title', 'mrd');
export_fig(fullfile(path,'starting_texture.png'),'-png');
close(f);

error = calcError(odf_rec,odf);

export_VPSC(ori,fullfile(path,'random_Mg.tex'));

end