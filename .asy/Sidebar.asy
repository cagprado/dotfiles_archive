private import graph;
private import palette;
private import Picture;

// Sidebar: Saves a palette for later drawing ///////////////////////////////
private struct Sidebar {
  Label L;
  bounds bounds;
  pair size;
  real offset;
  axis axis;
  pen[] palette;
  pen p;
  paletteticks ticks;
  bool antialias;

  pair TextSize(pair plotsize)
  {
    Save();

    // Define unitsize
    if (axis == Left || axis == Right) // vertical bar
      unitsize(size.x,plotsize.y);
    else // horizontal bar
      unitsize(plotsize.x,size.y);

    // Draw the palette
    palette(L,bounds,(0,0),(1,1),axis,palette,p,ticks,true,antialias);
    picture pal = currentpicture;
    currentpicture = new picture;
    add(currentpicture,pal.fit(),0);

    // Get extra size (due to text) from picture
    pair truesize = size(currentpicture,false);
    if (axis == Left || axis == Right)
      truesize = (truesize.x-size.x,0);
    else
      truesize = (0,truesize.y-size.y);

    Restore();
    return truesize;
  }

  pair Draw(pair unitsize)
  {
    // Draw palette
    pair A,B;
    if (axis == Left) {
      A = point(SW) - (size.x/unitsize.x,0);
      B = point(NW) - (offset/unitsize.x,0);
    }
    else if (axis == Right) {
      A = point(SE) + (offset/unitsize.x,0);
      B = point(NE) + (size.x/unitsize.x,0);
    }
    else if (axis == Bottom) {
      A = point(SW) - (0,size.y/unitsize.y);
      B = point(SE) - (0,offset/unitsize.y);
    }
    else if (axis == Top) {
      A = point(NW) + (0,size.y/unitsize.y);
      B = point(NE) + (0,offset/unitsize.y);
    }
    palette(L,bounds,A,B,axis,palette,p,ticks,true,antialias);


    // If palette is Bottom or Left, we need to displace the picture
    if (axis == Bottom || axis == Left)
      return size;
    else
      return (0,0);
  }
}
Sidebar[] currentsidebars;

void Palette(Label L = "", bounds bounds, pair width = (0.4cm,0.1cm), axis axis = Right, pen[] palette = Grayscale(), pen p = currentpen, paletteticks ticks = PaletteTicks, bool antialias = false)
{
  Sidebar sidebar;
  sidebar.L = L;
  sidebar.bounds = bounds;
  sidebar.offset = width.y;
  sidebar.axis = axis;
  sidebar.palette = palette;
  sidebar.p = p;
  sidebar.ticks = ticks;
  sidebar.antialias = antialias;
  if (axis == Left || axis == Right) sidebar.size = (width.x+width.y,0);
  else sidebar.size = (0,width.x+width.y);
  currentsidebars.push(sidebar);
}
