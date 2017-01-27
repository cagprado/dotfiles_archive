private import graph;
private import Axis;
private import Sidebar;

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

pair Point(pair rawpoint)
{
  return (currentpicture.scale.x.T(rawpoint.x), currentpicture.scale.y.T(rawpoint.y));
}

void Dot(pair rawpoint, pen p = currentpen)
{
  dot(Point(rawpoint),p);
}

void Dot(real x, real y, pen p = currentpen)
{
  dot(Point((x,y)),p);
}

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
    xlimits = (currentpicture.scale.x.Tinv(point(W).x),currentpicture.scale.x.Tinv(point(E).x));
  if (ylimits == (-infinity,infinity))
    ylimits = (currentpicture.scale.y.Tinv(point(S).y),currentpicture.scale.y.Tinv(point(N).y));

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
  pair extrasize = (0,0);
  for (int i = 0; i < currentsidebars.length; ++i) {
    extrasize += currentsidebars[i].size;
    displace += currentsidebars[i].Draw((size.x/usersize.x,size.y/usersize.y));
  }
  size += extrasize;
  extrasize = (extrasize.x/size.x, extrasize.y/size.y);
  displace = (displace.x/size.x, displace.y/size.y);
  currentsidebars.delete();

  // Prepare final picture
  picture aux = new picture;
  picture final = new picture;
  unitsize(aux,size.x,size.y);
  unitsize(final,size.x,size.y);
  final.legend = currentpicture.legend[:];

  // Set origin (0,0) to be the bottom-left of the picture
  pair origin = (currentpicture.scale.x.scale.T(currentplot.xlimits.x)/usersize.x, currentpicture.scale.y.scale.T(currentplot.ylimits.x)/usersize.y);
  add(aux,currentpicture.fit(),-origin);

  // Displace the picture so left/bottom sidebars are included in the box
  add(final,aux.fit(),displace);
  currentpicture = final;

  // Set an invisible line so point(dir) work on the actual plot
  draw(displace--((1,1)+displace-extrasize), invisible);
}

void Reset()
{
  currentplot = new Plot;
}
