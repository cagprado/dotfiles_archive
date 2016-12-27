real cmarkerscale() { return linewidth(currentpen); }

// CMarker provides a method to construct markers from paths
//   CMarker+CMarker: overlaps two markers (latter on top)
//   CMarker+pen: applies pen to CMarker (useful to set color)
//   (marker) cast(CMarker): implicit cast so we can use it directly
struct CMarker {
  bool above;
  markroutine mr;
  path[][] g;
  pen[] p;
  filltype[] ft;

  void operator init(path[] g, pen p = currentpen, markroutine mr = marknodes, filltype ft = Fill, bool above = true)
  {
    this.g.push(g);
    this.p.push(p);
    this.ft.push(ft);
    this.above = above;
    this.mr = mr;
  }
}

CMarker operator + (CMarker a, CMarker b)
{
  CMarker c;
  c.above = a.above;
  c.mr = a.mr;
  for (CMarker tmp : new CMarker[] {a,b}) {
    c.g.append(tmp.g);
    c.p.append(tmp.p);
    c.ft.append(tmp.ft);
  }
  return c;
}

CMarker operator + (CMarker a, pen p)
{
  CMarker c;
  c.above = a.above;
  c.mr = a.mr;
  c.g.append(a.g);
  c.p.append(a.p);
  c.ft.append(a.ft);
  c.p += p;
  return c;
}
CMarker operator + (pen p, CMarker a) { return a + p; }

marker operator cast(CMarker m)
{
  frame f;
  for (int i = 0; i < m.g.length; ++i) {
    if (m.ft[i] == Fill)
      fill(f,scale(cmarkerscale())*m.g[i],m.p[i]);
    else if (m.ft[i] == FillDraw)
      filldraw(f,scale(cmarkerscale())*m.g[i],m.p[i]);
    else
      draw(f,scale(cmarkerscale())*m.g[i],m.p[i]);
  }
  return marker(f,m.mr,m.above);
}

// predefined custom markers
CMarker[] mstyle = {
  // circle
  CMarker(scale(2)*unitcircle),
  // square
  CMarker(scale(3.5)*shift(-0.5,-0.5)*unitsquare),
  // triangle
  CMarker((0,2.5)--(2.5*cos(pi/6),-2.5*sin(pi/6))--(-2.5*cos(pi/6),-2.5*sin(pi/6))--cycle,linecap(0)),
  // star
  CMarker((0,3.0)-- (3.0*cos(3pi/10),-3.0*sin(3pi/10))-- (-3.0*cos(pi/10),3.0*sin(pi/10))-- (+3.0*cos(pi/10),+3.0*sin(pi/10))-- (-3.0*cos(3pi/10),-3.0*sin(3pi/10))-- cycle,linecap(0),Fill),
  // x
  CMarker((-1.7,-1.7)--(1.7,1.7)^^(-1.7,1.7)--(1.7,-1.7),linecap(0),NoFill),
  // +
  CMarker((-1.7*sqrt(2),0)--(1.7*sqrt(2),0)^^(0,-1.7*sqrt(2))--(0,1.7*sqrt(2)),linecap(0),NoFill),
  // *
  CMarker( (0,-2.5)-- (0,2.5)^^ (-2.5*cos(pi/6),-2.5*sin(pi/6))-- (2.5*cos(pi/6),2.5*sin(pi/6))^^ (-2.5*cos(pi/6),2.5*sin(pi/6))-- (2.5*cos(pi/6),-2.5*sin(pi/6)) ,linecap(0),NoFill),
};
mstyle.cyclic = true;
CMarker errormarker = CMarker((-5,0)--(5,0)^^(-5,-1.5)--(-5,1.5)^^(5,-1.5)--(5,1.5),NoFill);
