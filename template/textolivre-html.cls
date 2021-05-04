\ProvidesClass{textolivre-html}[2021/01/22 Texto Livre HTML class]
\newif\if@suppmat\@suppmattrue
\DeclareOption{nosupp}{\@suppmatfalse}
\ProcessOptions\relax
\ExecuteOptions{}
\PassOptionsToPackage{inline}{enumitem}
\LoadClass[brazil]{article}

\RequirePackage[utf8]{inputenc}
\RequirePackage[brazil]{babel}

\makeatletter
\newcommand\othertitle[1]{ 
  \expandafter\def\expandafter\@title\expandafter{\@title {\\}#1}
}
\makeatother
\newcommand{\orcid}[1]{}
\newcommand{\journalname}[1]{}
\newcommand{\thevolume}[1]{}
\newcommand{\thenumber}[1]{}
\newcommand{\theyear}[1]{}
\newcommand{\receiveddate}[1]{}
\newcommand{\accepteddate}[1]{}
\newcommand{\publisheddate}[1]{}
\newcommand{\corrauthor}[1]{}
\newcommand{\editorname}[1]{}
\newcommand{\articledoi}[1]{}
\newcommand{\runningauthor}[1]{}
\newenvironment{polyabstract}{}{}
\def\sep{\unskip. }%
% keywords
\newcommand{\keywordsname}{%
    \iflanguage{english}{Keywords}{%
    \iflanguage{french}{Mots-cl\'{e}s}{%
    \iflanguage{german}{Schl\"{u}sselw\"{o}rter}{%
    \iflanguage{spanish}{Palabras clave}{%
    \iflanguage{portuguese}{Palavras-chave}{Keywords}
    }}}}}
\newcommand{\keywords}[1]{\textbf{\keywordsname}: {#1}}
% add source 
\newcommand{\textSource}{%
  \iflanguage{english}{Source:}{% 
  \iflanguage{french}{Source:}{% 
  \iflanguage{german}{Quelle:}{% 
  \iflanguage{spanish}{Fuente:}{% 
  \iflanguage{portuguese}{Fonte:}{Source:} 
  }}}}} 
\newcommand{\source}[1]{ 
 \caption*{\textbf{\textSource} {#1}} 
} 
% end source

% add notes
\newcommand{\textNotes}{%
  \iflanguage{english}{Note:}{% 
  \iflanguage{french}{Remarque:}{% 
  \iflanguage{german}{Hinweis:}{% 
  \iflanguage{spanish}{Nota:}{% 
  \iflanguage{portuguese}{Nota:}{Note:} 
  }}}}} 
\newcommand{\notes}[1]{ 
 \caption*{\textbf{\textNotes} {#1}} 
} 
%end notes

\RequirePackage{authblk}
\RequirePackage{hyperref}

\RequirePackage{polyglossia} 
\setmainlanguage{english}

\RequirePackage[backend=biber,style=abnt,ittitles]{biblatex}
\DeclareLanguageMapping{brazil}{brazil-apa}

\RequirePackage[inline]{enumitem}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{rotating}
\RequirePackage{subcaption}
\RequirePackage{booktabs}
\RequirePackage{amsmath,amsfonts,amssymb,amsthm}
\AtBeginDocument{\renewenvironment{subequations}{}{}}
\RequirePackage{adjustbox}
\RequirePackage{longtable,booktabs,tabularx}
\definecolor{Gray}{gray}{0.9}
\newcommand{\headrow}{\rowcolor{Gray}}
\newcommand{\thead}[1]{\bfseries #1\rule[-1.2ex]{0pt}{2em}}
\RequirePackage[english,french,spanish,brazilian]{cleveref}

% used to provide source code environment
\crefname{lstlisting}{lista}{listas}
\Crefname{lstlisting}{Lista}{Listas}
\RequirePackage{listings}
\renewcommand\lstlistingname{Lista}
\input{listingconfig.tex}
% add source to lising
\makeatletter
\lst@Key{source}{}{\def\lst@source{#1}}
\makeatother


% BEGIN \citefirstlastauthor 
% reference: https://tex.stackexchange.com/questions/581792/how-to-write-the-authors-full-name-and-avoid-style-formatting-given-by-biblatex/581838#581838
\DeclareCiteCommand{\citefirstlastauthor}
  {\DeclareNameAlias{labelname}{given-family}%
   \let\multinamedelim\multinamedelimorig
   \let\finalnamedelim\finalnamedelimorig
   \let\mkbibnamefamily\origmkbibnamefamily
   \let\mkbibnamegiven\origmkbibnamegiven
   \let\mkbibnameprefix\origmkbibnameprefix
   \let\mkbibnamesuffix\origmkbibnamesuffix
   \boolfalse{citetracker}%
   \boolfalse{pagetracker}%
   \usebibmacro{prenote}}%
  {\ifciteindex%
     {\indexnames{labelname}}%
     {}%
   \printtext[bibhyperref]{\printnames{labelname}}}%
  {\multicitedelim}%
  {\usebibmacro{postnote}}%
% END \citefirstlastauthor

% BEGIN \posscite
% reference: https://tex.stackexchange.com/questions/592713/how-to-make-author-name-appear-in-small-caps-when-using-biblatex-abnt/592726#592726
\DeclareNameWrapperFormat{textlabelname:poss}{#1's}
\DeclareFieldFormat{shorthand:poss}{%
  \ifnameundef{labelname}{#1's}{#1}}
\DeclareFieldFormat{citetitle:poss}{\mkbibemph{#1}'s}
\DeclareFieldFormat{label:poss}{#1's}
\newrobustcmd*{\posscitealias}{%
  \AtNextCite{%
    \DeclareNameWrapperAlias{labelname}{textlabelname:poss}%
    \DeclareFieldAlias{shorthand}{shorthand:poss}%
    \DeclareFieldAlias{citetitle}{citetitle:poss}%
    \DeclareFieldAlias{label}{label:poss}}}
\newrobustcmd*{\posscite}{%
  \posscitealias%
  \textcite}
\newrobustcmd*{\Posscite}{\bibsentence\posscite}
\newrobustcmd*{\posscites}{%
  \posscitealias%
  \textcites}
% END \posscite

