\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{textolivre}[2019/10/17 Texto Livre class]
 
\LoadClass[onecolumn]{article}
\RequirePackage{xcolor}
\RequirePackage[utf8]{inputenc}
\RequirePackage[portuguese,english]{babel} 
\RequirePackage{lmodern} 
\pagenumbering{arabic} 
 
\DeclareOption{twocolumn}{\OptionNotUsed}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax


\RequirePackage[hidelinks]{hyperref}
\newcommand{\hrefemail}[1]{\href{mailto:#1}{\color{blue}{#1}}}%

\RequirePackage{graphicx}

\RequirePackage[left=2cm,%
                right=2cm,%
                top=2cm,%
                bottom=2cm,%
                headheight=12pt,%
                headsep=36pt,%
                a4paper, includefoot, heightrounded]{geometry}%

%% Settings for the author block
%\RequirePackage[blocks]{authblk}
%\renewcommand\Authfont{\fontsize{12}{12}\usefont{T1}{lmss}{sb}{n}}
%\renewcommand\Affilfont{\fontsize{10}{10}\usefont{T1}{lmss}{m}{n}}
%\setlength{\affilsep}{0em}
 
\RequirePackage{datatool}% for multiple authors
\renewcommand{\dtlheaderformat}[1]{}
\DTLnewdb{tlauthors}
\newcommand*{\tlauthor}[3]{%
  \DTLnewrow{tlauthors}%
  \DTLnewdbentry{tlauthors}{name}{#1}%
  \DTLnewdbentry{tlauthors}{affiliation}{#2}%
  \DTLnewdbentry{tlauthors}{email}{#3}%
} 
 
 
\def\keywords#1{\gdef\@keywords{#1}}
\def\palavraschave#1{\gdef\@palavraschave{#1}}

\def\xabstract{abstract}
\long\def\abstract#1\end#2{\def\two{#2}\ifx\two\xabstract 
\long\gdef\theabstract{\textbf{ABSTRACT:} \ignorespaces#1}
\def\go{\end{abstract}}\else
\typeout{PLEASE DO NOT USE ANY COMMANDS WITHIN ABSTRACT}#1\end{#2}
\gdef\theabstract{BADLY FORMED ABSTRACT: PLEASE DO NOT USE COMMANDS WITHIN THE ABSTRACT}\let\go\relax\fi
\go}

\def\xresumo{resumo}
\long\def\resumo#1\end#2{\def\two{#2}\ifx\two\xresumo
\long\gdef\theresumo{\textbf{RESUMO:} \ignorespaces#1}
\def\go{\end{resumo}}\else
\typeout{PLEASE DO NOT USE ANY COMMANDS WITHIN ABSTRACT}#1\end{#2}
\gdef\theresumo{BADLY FORMED ABSTRACT: PLEASE DO NOT USE COMMANDS WITHIN THE ABSTRACT}\let\go\relax\fi
\go}


\renewcommand{\maketitle}{%
  \vskip1pt%
  {\ }
  \vskip40pt%
  {\centering\sffamily\bfseries\fontsize{12}{15}\fontfamily{lmss}\selectfont\@title\par}%
  \vskip13mm
	\DTLifdbempty{tlauthors}{\relax}{
    		\DTLforeach{tlauthors}{%
		\name=name,\affil=affiliation,\email=email}{%
		{
		\flushright \setstretch{1}
		{\fontsize{12}{12}\usefont{T1}{lmss}{sb}{n}\name}\par
		{\fontsize{10}{10}\usefont{T1}{lmss}{m}{n}\affil}\par
		{\fontsize{10}{10}\usefont{T1}{lmss}{m}{n}\hrefemail{\email}}\par
		\normalsize\vspace{\baselineskip}
		}
      }
	}
  %{\parbox{\dimexpr\linewidth-7\fboxsep\relax}{\raggedleft\sffamily\fontsize{12}{15}\fontfamily{lmss}\selectfont\@author}}%
  \vskip18pt%
    {%
    \noindent
    {\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\sffamily\textbf\\\theresumo}}
    }
  \vskip5pt%
   {%
    \noindent
    {\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\sffamily\textbf{PALAVRAS-CHAVE: }\@palavraschave.}}
   }
  \vskip11mm%
    {%
    \noindent
    {\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\sffamily\textbf\\\theabstract}}
    }
  \vskip5pt%
  {%
    \noindent
    {\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\sffamily\textbf{KEYWORDS: }\@keywords.}}
  }
  \vskip18pt%
}


\renewcommand \thesection{\@arabic\c@section}

\renewcommand{\section}{%
    \@startsection
    {section}{1}
    {0pt}% indent
    {1cm plus -1ex minus -.2ex}% spacing before section title
    {0.5cm plus .2ex}% spacing after section title
    {\sffamily\bfseries\boldmath}%style
}
% spacing between section number and title
\renewcommand*{\@seccntformat}[1]{\csname the#1\endcsname\hspace{0.1cm}} 
 
\renewcommand{\normalsize}{\fontsize{12}{13}\fontfamily{lmss}\selectfont}
\setlength{\parskip}{1mm}


\newcommand{\JournalDataAndLogo}{%
  \leavevmode\smash{%
    \raisebox{-2ex}{% <----- adjust to suit
      \begin{tabular*}{\textwidth}{@{}ll@{}}
        \includegraphics[width=3.86cm]{logo.png}
        &
        \renewcommand{\arraystretch}{0.75}
        \begin{tabular}[b]{@{}c@{}}
        %\fontsize{8}{9}\fontfamily{cmtt}\selectfont http://periodicos.letras.ufmg.br/index.php/textolivre\\
        \fontsize{8}{9}\fontfamily{cmtt}\selectfont Belo Horizonte, v. 12, n. 2, p. mai.--ago. 2019 --- ISSN 1983-3652\\
        \multicolumn{1}{c}{\fontsize{8}{9}\fontfamily{cmtt}\selectfont DOI: 10.17851/1983-3652.XX.YY}
        \end{tabular} 
     \end{tabular*}%
    }% end of \raisebox
  }% end of \smash
}

\RequirePackage{fancyhdr}
\fancypagestyle{txtlivre}{%
    \setlength\headheight{44pt}
    \fancyhead{}
    \fancyfoot{}
    \fancyhead[L]{%
     \JournalDataAndLogo
    }
    \renewcommand{\headrulewidth}{0pt}
    \fancyfoot[R]{\thepage}
}
\pagestyle{txtlivre}


