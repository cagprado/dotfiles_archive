// DEFAULT PEN ##############################################################
// Set default size and font for pens
usepackage("fontenc","T1");
usepackage("inputenc","utf8");
usepackage("newtxtext","p,osf");
usepackage("newtxmath");
texpreamble("
  \renewcommand\tiny{\fontsize{5}{6}\selectfont}
  \renewcommand\scriptsize{\fontsize{7}{8}\selectfont}
  \renewcommand\footnotesize{\fontsize{8}{9.5}\selectfont}
  \renewcommand\small{\fontsize{9}{11}\selectfont}
  \renewcommand\normalsize{\fontsize{10}{12}\selectfont}
  \renewcommand\large{\fontsize{12}{14}\selectfont}
  \renewcommand\Large{\fontsize{14.4}{18}\selectfont}
  \renewcommand\LARGE{\fontsize{17.28}{22}\selectfont}
  \renewcommand\huge{\fontsize{20.74}{25}\selectfont}
  \renewcommand\Huge{\fontsize{24.88}{30}\selectfont}
");
defaultpen(1+solid+black+fontsize(10pt,12pt));  // should match normalsize
restricted string tiny = "\tiny ";
restricted string scriptsize = "\scriptsize ";
restricted string footnotesize = "\footnotesize ";
restricted string small = "\small ";
restricted string normalsize = "\normalsize ";
restricted string large = "\large ";
restricted string Large = "\Large ";
restricted string LARGE = "\LARGE ";
restricted string huge = "\huge ";
restricted string Huge = "\Huge ";

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
