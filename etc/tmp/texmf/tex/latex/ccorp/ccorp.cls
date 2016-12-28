% General info
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ccorp}[2012/06/25 CCorp class - memoir/beamer]

% Beamer options
\DeclareOption{presentation}{%
  \AtEndOfClass{
    \LoadClass[aspectratio=169,xcolor={usenames,dvipsnames}]{beamer}
    \usetheme{Warsaw}
    \usecolortheme[RGB={33,65,119}]{structure}
    \setbeamertemplate{navigation symbols}{}

    \newcommand*\oldmacro{}%
    \let\oldmacro\insertshorttitle%
    \renewcommand*\insertshorttitle{%
      \oldmacro\hfill%
      \insertframenumber\,/\,\inserttotalframenumber}
  }
}

% Article options
\DeclareOption{nochapters}{
  \AtEndOfClass{
    \LoadClass[a4paper,12pt]{article}
    \RequirePackage[usenames,dvipsnames]{xcolor} % Color
    \RequirePackage[hidelinks]{hyperref} % pdf hypertext
  }
}

% Memoir options
\DeclareOption{chapters}{%
  \AtEndOfClass{
    \LoadClass[a4paper,11pt]{memoir}
    \chapterstyle{veelo}
    \RequirePackage[usenames,dvipsnames]{xcolor} % Color
    \RequirePackage[hidelinks]{hyperref} % pdf hypertext
    \let\oldchapnumfont\chapnumfont
    \renewcommand{\chapnumfont}{\oldchapnumfont\addfontfeatures{RawFeature=-onum}}
    \pagestyle{ruled}

    % Redefine author commands
    \renewcommand{\author}[2][]{%
      \renewcommand{\@author}{#2}
      \def\emptyarg{}
      \def\@shortauthor{#1}%
      \ifx\emptyarg\@shortauthor
        \renewcommand{\@shortauthor}{#2}
      \fi}
    \def\university#1{\def\@university{#1}}
    \def\institute#1{\def\@institute{#1}}
    \def\department#1{\def\@department{#1}}
    \def\advisor#1{\def\@advisor{#1}}
    \def\curyear#1{\def\@curyear{#1}}
    \def\curmonth#1{\def\@curmonth{#1}}
    \def\subject#1{\def\@subject{#1}}
    \def\catalog#1{\def\@catalog{#1}}
    \newcommand{\exama}[2]{\def\@exama{#1}\def\@examainst{#2}}
    \newcommand{\examb}[2]{\def\@examb{#1}\def\@exambinst{#2}}
    \newcommand{\examc}[2]{\def\@examc{#1}\def\@examcinst{#2}}
    \newcommand{\place}[2][compplace]{\def\@place{#2}\def\@compplace{#1}}

    % Set default values
    \author[short]{author}
    \university{university}
    \institute{institute}
    \department{department}
    \advisor{advisor}
    \exama{exama}{examainst}
    \examb{examb}{exambinst}
    \examc{examc}{examcinst}
    \place{place}
    \curyear{curyear}
    \curmonth{curmonth}
    \subject{subject}
    \catalog{catalog}

    % Function to separate Last name from rest
    \def\emptyarg{} % empty string

    \def\multiwords#1 #2\@nil{% 
      \def\nextarg{#2}%
      \ifx\emptyarg\nextarg
        \edef\lastname{#1}
        \let\next\@gobble
      \else
        \ifx\emptyarg\name
          \edef\name{#1}%
        \else
          \edef\name{\name{} #1}% 
        \fi
      \fi
      \next#2\@nil
    }%    

    \def\splitname#1{%
      \edef\name{}%
      \let\next\multiwords 
      \expandafter\next#1 \@nil%
    }% 

    % Define titlepage
    \def\titlepage{
      \splitname{\@author}

      \begin{titlingpage}

        \begingroup
        \begin{center}
          \vspace*{0.3\textheight}
          {\LARGE\scshape\@title}
        \end{center}
        \endgroup

        \cleardoublepage
        \thispagestyle{empty}

        \begingroup
        \begin{center}
          {\Large\scshape\@university}
          \vspace{2\baselineskip}

          {\large\scshape\@institute}
          \vspace{4\baselineskip}

          {\LARGE\@title}
          \vspace{2\baselineskip}

          {\Large\itshape\@shortauthor}
          \vspace{4\baselineskip}
        \end{center}

        \hfill
        {\large
        \begin{flushright}
        Orientador:\\
        \vspace{2\baselineskip}
        \@advisor
        \end{flushright}}

        \vspace{\fill}

        \hfill
        \begin{minipage}{0.75\textwidth}
        \begin{flushright}
        Dissertação de mestrado apresentada ao Instituto de Física para
        a obtenção do título de Mestre em Ciências.
        \end{flushright}
        \end{minipage}

        \vspace{\fill}

        \begin{flushleft}
        Comissão Examinadora:\\
        \@exama{} (\textsc{\@examainst})\\
        \@examb{} (\textsc{\@exambinst})\\
        \@examc{} (\textsc{\@examcinst})\\
        \end{flushleft}

        \vspace{\fill}

        \begin{center}
        {\large\@place}
        \vspace{2\baselineskip}

        {\large\@curyear}
        \end{center}
        \endgroup

        \clearpage
        \thispagestyle{empty}

        \begingroup
        \setlength{\parindent}{0pt}
        \setlength{\parskip}{\baselineskip}
        \textcopyright{} \@curyear{} \@author

        \@university, \@institute, \@place, \@compplace.

        \vspace*{\fill}
        \begin{minipage}{\textwidth}
        \hrulefill

        \begin{center}
        {\scshape Ficha Catalográfica}

        Preparada pelo Serviço de Biblioteca e Informação do Instituto de Física da
        Universidade de São Paulo
        \end{center}

          \lastname, \name

        \vspace*{\baselineskip}
          \@title\ --- \@place, \@curyear

        \vspace*{\baselineskip}
          Dissertação (Mestrado) --- \@university.
          
          \@institute\ --- \@department

        \vspace*{\baselineskip}
          Orientador: \@advisor

        \vspace*{\baselineskip}
          Área de Concentração: \@subject

        \vspace*{\baselineskip}
          Unitermos:
          1. ???;
          2. ???;
          3. ???.

        \vspace*{2\baselineskip}
          \textsc{\@catalog}

        \hrulefill
        \end{minipage}
        \vspace*{\fill}
        \begin{center}
        13 14 15 16\hspace{2em}5 4 3 2 1\par
        \end{center}
        \begin{center}
        \@curmonth{} de \@curyear\par
        \end{center}
        \endgroup
      \end{titlingpage}
    }
  }
}
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{ccorp}}
\ProcessOptions\relax
\AtEndOfClass{\RequirePackage{ccorp}}
% vim: ft=tex
