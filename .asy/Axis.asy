private import graph;
private import Picture;

// Axis: saves an axis for later drawing ////////////////////////////////////
private struct Axis {
  Label L;
  axis axis;
  real xmin;
  real xmax;
  pen p;
  ticks ticks;
  arrowbar arrow;
  bool above;
  bool3 autorotate;

  pair TextSize(pair plotsize, pair xlimits, pair ylimits)
  {
    Save();

    // Define unitsize
    unitsize(plotsize.x/(xlimits.y-xlimits.x),plotsize.y/(ylimits.y-ylimits.x));

    // Draw the axis
    draw((xlimits.x,ylimits.x)--(xlimits.y,ylimits.y));
    if (autorotate == default) // xaxis
      xaxis(L,axis,xmin,xmax,p,ticks,arrow,above);
    else // yaxis
      yaxis(L,axis,xmin,xmax,p,ticks,arrow,above,autorotate);

    // Get extra size (due to text) from picture
    pair truesize = size(currentpicture,false);
    if (autorotate == default) // xaxis
      truesize = (0,truesize.y-plotsize.y);
    else // yaxis
      truesize = (truesize.x-plotsize.x,0);

    Restore();
    return truesize;
  }

  void Draw()
  {
    if (autorotate == default) // xaxis
      xaxis(L,axis,xmin,xmax,p,ticks,arrow,above);
    else // yaxis
      yaxis(L,axis,xmin,xmax,p,ticks,arrow,above,autorotate);
  }
};
Axis[] currentaxis;

bool3 noendlabel = default;
private bool3 TestArrayType(real[] A)
{
  if (A.length == 0)
    return false;
  else if (A.length == 2 && A[1] < A[0])
    return default;
  else
    return true;
}

void XAxis(Label L = "", axis axis, real xmin = -infinity, real xmax = infinity, pen p = currentpen, ticks ticks = NoTicks, arrowbar arrow = None, bool above = true)
{
  Axis xaxis;
  xaxis.L = L;
  xaxis.axis = axis;
  xaxis.xmin = xmin;
  xaxis.xmax = xmax;
  xaxis.p = p;
  xaxis.ticks = ticks;
  xaxis.arrow = arrow;
  xaxis.above = above;
  xaxis.autorotate = default;
  currentaxis.push(xaxis);
}

void XAxis(Label L = "", bool3 drawlabels = true, int ndecimals = -1, real[] nTicks = {}, real[] nticks = {})
{
  string labelformat = (ndecimals < 0) ? "" : ("$%#."+format("%d",ndecimals)+"f$");
  if (drawlabels == false) {
    labelformat = "%";
    L = "";
  }

  ticks ticks;
  if (TestArrayType(nTicks) == false && TestArrayType(nticks) == false) // both empty
    ticks = LeftTicks(labelformat,endlabel=drawlabels);
  else if (!TestArrayType(nTicks) && !TestArrayType(nticks)) { // at least one default and the other one default/false
    int N = nTicks.length == 0 ? 0 : round(nTicks[0]);
    int n = nticks.length == 0 ? 0 : round(nticks[0]);
    ticks = LeftTicks(labelformat,N=N,n=n,endlabel=drawlabels);
  }
  else
    ticks = LeftTicks(labelformat,nTicks,nticks,endlabel=drawlabels);

  XAxis(L,BottomTop,ticks);
}
void XAxis(Label L = "", bool3 drawlabels = true, int N, int n, int ndecimals = -1)
{ XAxis(L,drawlabels,ndecimals,new real[] {N,0},new real[] {n,0}); }

void YAxis(Label L = "", axis axis, real ymin = -infinity, real ymax = infinity, pen p = currentpen, ticks ticks = NoTicks, arrowbar arrow = None, bool above = true, bool autorotate = true)
{
  Axis yaxis;
  yaxis.L = L;
  yaxis.axis = axis;
  yaxis.xmin = ymin;
  yaxis.xmax = ymax;
  yaxis.p = p;
  yaxis.ticks = ticks;
  yaxis.arrow = arrow;
  yaxis.above = above;
  yaxis.autorotate = autorotate;
  currentaxis.push(yaxis);
}

void YAxis(Label L = "", bool3 drawlabels = true, int ndecimals = -1, real[] nTicks = {}, real[] nticks = {})
{
  string labelformat = (ndecimals < 0) ? "" : ("$%#."+format("%d",ndecimals)+"f$");
  if (drawlabels == false) {
    labelformat = "%";
    L = "";
  }

  ticks ticks;
  if (TestArrayType(nTicks) == false && TestArrayType(nticks) == false) // both empty
    ticks = RightTicks(labelformat,endlabel=drawlabels);
  else if (!TestArrayType(nTicks) && !TestArrayType(nticks)) { // at least one default and the other one default/false
    int N = nTicks.length == 0 ? 0 : round(nTicks[0]);
    int n = nticks.length == 0 ? 0 : round(nticks[0]);
    ticks = RightTicks(labelformat,N=N,n=n,endlabel=drawlabels);
  }
  else
    ticks = RightTicks(labelformat,nTicks,nticks,endlabel=drawlabels);

  YAxis(L,LeftRight,ticks);
}
void YAxis(Label L = "", bool3 drawlabels = true, int N, int n, int ndecimals = -1)
{ YAxis(L,drawlabels,ndecimals,new real[] {N,0},new real[] {n,0}); }

void XGrid(real[] nTicks = {}, real[] nticks = {})
{
  XAxis(LeftRight,LeftTicks("\phantom{$%g$}",0.5+dashed,0.5+dotted,beginlabel=false,endlabel=false,extend=true));
}
void XGrid(int N, int n) { XGrid(new real[] {N,0}, new real[] {n,0}); }

void YGrid(real[] nTicks = {}, real[] nticks = {})
{
  YAxis(BottomTop,RightTicks("\phantom{$%g$}",0.5+dashed,0.5+dotted,beginlabel=false,endlabel=false,extend=true));
}
void YGrid(int N, int n) { YGrid(new real[] {N,0}, new real[] {n,0}); }

void Grid() { XGrid(); YGrid(); }
