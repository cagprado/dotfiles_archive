private import graph;
private import Axis;
private import Sidebar;

// Define picture corners
pair BL = (0,0);
pair BR = (1,0);
pair TL = (0,1);
pair TR = (1,1);

// Plot: Set size and limits of a 2D plot ///////////////////////////////////
private struct Plot {
  pair size = (6cm,6cm);
  pair xlimits = (-infinity,infinity);
  pair ylimits = (-infinity,infinity);
  bool fixwidth = true;
  bool fixheight = true;
  bool keepaspect = false;
  bool center = false;

  bool HaveLimits() { return xlimits != (-infinity,infinity) && ylimits != (-infinity,infinity); }
  pair RealSize()
  {
    pair plotsize = size;
    pair textsize = (0,0);

    // Measure axis dimensions
    for (int i = 0; i < currentaxis.length; ++i)
      textsize += currentaxis[i].TextSize(size,xlimits,ylimits);

    // Measure sidebars dimentions
    for (int i = 0; i < currentsidebars.length; ++i) {
      plotsize -= currentsidebars[i].size;
      textsize += currentsidebars[i].TextSize(size);
    }

    // Adapt size to fit texts
    if (!fixwidth) plotsize = (plotsize.x-textsize.x,plotsize.y);
    if (!fixheight) plotsize = (plotsize.x,plotsize.y-textsize.y);

    return plotsize;
  }
  pair UserSize(pair size)
  {
    // adapt limits if we need to maintain aspect ratio
    if (keepaspect) {
      real ratio = size.y/size.x;
      if (ratio < (ylimits.y-ylimits.x) / (xlimits.y-xlimits.x)) {
        real extra = 0.5 * ((ylimits.y-ylimits.x)/ratio - (xlimits.y-xlimits.x));
        xlimits = (xlimits.x-extra, xlimits.y+extra);
      }
      else {
        real extra = 0.5 * ((xlimits.y-xlimits.x)*ratio - (ylimits.y-ylimits.x));
        ylimits = (ylimits.x-extra, ylimits.y+extra);
      }
    }

    real xsize = currentpicture.scale.x.T(xlimits.y) - currentpicture.scale.x.T(xlimits.x);
    real ysize = currentpicture.scale.y.T(ylimits.y) - currentpicture.scale.y.T(ylimits.x);

    // return limits dimensions
    return (xsize,ysize);
  }
};
Plot currentplot;

void Size(real width, bool fixwidth = true, real height, bool fixheight = true)
{
  currentplot.size = (width,height);
  currentplot.fixwidth = fixwidth;
  currentplot.fixheight = fixheight;
}

void Aspect(bool keepaspect = true, bool center = false)
{
  currentplot.keepaspect = keepaspect;
  currentplot.center = center;
}

void Limits(pair xlimits = (-infinity,infinity), pair ylimits = (-infinity,infinity))
{
  // If set infinity, get limits from drawing
  if (xlimits == (-infinity,infinity))
    xlimits = (point(W).x,point(E).x);
  if (ylimits == (-infinity,infinity))
    ylimits = (point(S).y,point(N).y);

  // If difference is zero expand limits
  if (xlimits.y==xlimits.x) xlimits = (xlimits.x-1,xlimits.y+1);
  if (ylimits.y==ylimits.x) ylimits = (ylimits.x-1,ylimits.y+1);

  // Center (0,0) if we need to
  if (currentplot.center) {
    real tmp = max(abs(xlimits.x),abs(xlimits.y));
    xlimits = (-tmp,tmp);
    real tmp = max(abs(ylimits.x),abs(ylimits.y));
    ylimits = (-tmp,tmp);
  }

  currentplot.xlimits = xlimits;
  currentplot.ylimits = ylimits;
}

void Fit()
{
  if (!currentplot.HaveLimits()) Limits();

  // Eval final size of the plot
  pair size = currentplot.RealSize();
  pair usersize = currentplot.UserSize(size);
  // Eval again in case the Aspect changed the axis too much (add digits, etc)
  if (currentplot.keepaspect) {
    size = currentplot.RealSize();
    usersize = currentplot.UserSize(size);
  }
  // Set picture limits and unitsize
  limits((currentplot.xlimits.x,currentplot.ylimits.x),(currentplot.xlimits.y,currentplot.ylimits.y),Crop);
  unitsize(size.x/usersize.x, size.y/usersize.y);

  // Add axis
  for (int i = 0; i < currentaxis.length; ++i)
    currentaxis[i].Draw();
  currentaxis.delete();

  // Add Sidebars
  pair displace = (0,0);
  for (int i = 0; i < currentsidebars.length; ++i)
    displace += currentsidebars[i].Draw((size.x/usersize.x,size.y/usersize.y));
  currentsidebars.delete();

  // Fit picture so (0,0) is bottom-left (including the area for the sidebars)
  picture pic = new picture;
  unitsize(pic,size.x,size.y);
  pair origin = (displace.x/size.x-currentplot.xlimits.x/usersize.x,displace.y/size.y-currentplot.ylimits.x/usersize.y);
  add(pic,currentpicture.fit(),origin);
  pic.legend = currentpicture.legend[:]; // Copy legend array
  currentpicture = pic;
}

void Reset()
{
  currentplot = new Plot;
}
