// CPen provides a method to construct a pen and an implicit cast to pens so
// final result can adapt given some constraints. For instance, the dotted
// line defined below (lstyle) will adapt if defaultpen width changes
struct CPen {
  typedef pen ConstructPen();
  ConstructPen p;
  void operator init(ConstructPen p) { this.p = p; }
};
pen operator cast(CPen P) { return P.p(); }

// linestyle
CPen[] lstyle = {
  // 0.solid
  CPen(new pen() { return linecap(0)+linetype(new real[],0,false,false); }),
  // 1.dashed
  CPen(new pen() { return linecap(0)+linetype(new real[] {5,3},0,false,false); }),
  // 2.long-short
  CPen(new pen() { return linecap(0)+linetype(new real[] {12,2,4,2},0,false,false); }),
  // 3.dotted
  CPen(new pen() { return linecap(1)+linetype(new real[] {0,2*linewidth(currentpen)},0,false,false); }),
  // 4.dash-dot
  CPen(new pen() { return linecap(0)+linetype(new real[] {6,2,1,2},0,false,false); }),
  // 5.dash-dot-dot
  CPen(new pen() { return linecap(0)+linetype(new real[] {5,2,1,2,1,2},0,false,false); }),
  // 6.long-dot-short-dot
  CPen(new pen() { return linecap(0)+linetype(new real[] {9,2,1,1,3,1,1,2},4.5,false,false); }),
};
lstyle.cyclic = true;

// colors
pen[] lcolor = {
  cmyk(black),
  cmyk(red),
  cmyk(royalblue),
  cmyk(purple),
  cmyk(orange),
  cmyk(heavygreen),
  cmyk(magenta),
};
lcolor.cyclic = true;
