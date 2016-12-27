private import Plot;

// Panel: Setup multiple plot in the same page //////////////////////////////
private struct Panel {
  picture pic;
  pair size;
}
Panel currentpanel;

void Panels(real width, real height)
{
  currentpanel.size = (width, height);
  currentpanel.pic = new picture;
  unitsize(currentpanel.pic,width,height);
  Size(currentpanel.size.x,true,currentpanel.size.y,true);
}

void PushPanel(real x, real y, filltype filltype = NoFill)
{
  add(currentpanel.pic,currentpicture.fit(),(x,y),filltype);
  currentpicture = new picture;
  Reset();
  Size(currentpanel.size.x,true,currentpanel.size.y,true);
}

void PanelSize(real xscale = 1, real yscale = 1)
{
  Size(currentpanel.size.x*xscale,true,currentpanel.size.y*yscale,true);
}

void DrawPanels()
{
  currentpicture = currentpanel.pic;
  currentpanel = new Panel;
}
