\ProvidesClass{textolivre}[2020/11/24 Texto Livre class]
\def\@classname{textolivre}
\newif\if@suppmat\@suppmattrue
\DeclareOption{nosupp}{\@suppmatfalse}
\ProcessOptions\relax
\ExecuteOptions{}
\LoadClass{article}

\RequirePackage{xkeyval}
\define@boolkey+{textolivre.cls}[@textolivre@]{anonymous}[true]{%
  \if@textolivre@anonymous
    \PackageInfo{\@classname}{Using anonymous mode}%
  \else
    \PackageInfo{\@classname}{Not using anonymous mode}%
  \fi}{\PackageError{\@classname}{Option anonymous can be either true or
    false}}
\ExecuteOptionsX{anonymous=false}
\ProcessOptionsX

\RequirePackage{etoolbox,xpatch}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{setspace}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage{rotating}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}
\RequirePackage[style]{abstract}
\RequirePackage[marginal]{footmisc}
\RequirePackage{caption,subcaption}
\RequirePackage[inline]{enumitem}
\RequirePackage{authblk}
\RequirePackage{relsize}
\RequirePackage[right]{lineno}

\RequirePackage[
    type={CC},
    modifier={by},
    version={4.0},
]{doclicense}


% fonts
\RequirePackage{fontspec}
%\setmainfont{SourceSansPro}[ 
%  Path = /usr/share/texlive/texmf-dist/fonts/opentype/adobe/sourcesanspro/,
%  Extension = .otf ,
%  UprightFont = *-Light,
%  ItalicFont = *-LightIt,
%  BoldFont = *-Semibold,
%]    
\RequirePackage{polyglossia} 
\setmainlanguage{english}
%\setotherlanguage{arabic}
%\AtEndPreamble{
%\setotherlanguage[numerals=arabic,calendar=gregorian]{arabic}
%\newfontfamily\arabicfont[Script=Arabic]{Amiri} % Replace 'Simplified Arabic' with a font from your system
% \setmonofont[Script=Arabic]{Amiri}
%}
\RequirePackage[default]{sourcesanspro}


\def\@keyandsep{
    \iflanguage{english}{ and }{
    \iflanguage{french}{ et }{
    \iflanguage{german}{ und }{
    \iflanguage{spanish}{ y }{
    \iflanguage{portuguese}{\hspace{-1.5ex} e }{ and }
    }}}}}
\renewcommand\Authand{\@keyandsep}
\renewcommand\Authands{\@keyandsep}

\RequirePackage{textcomp}
\RequirePackage[absolute]{textpos}
\RequirePackage{amsmath,amsfonts,amssymb,amsthm}
\RequirePackage{adjustbox}
\RequirePackage{titlecaps}
%\RequirePackage[english,spanish,french,brazilian]{babel} % change if article uses different languages (install suitable packages)
%\RequirePackage[brazilian,english,arabic]{babel}
%\RequirePackage[brazilian,english]{babel}
\RequirePackage{longtable,booktabs}

\def\@emptyfieldtext{xxxxxxxxx}

\newcommand{\tlprintlicense}{
    \iflanguage{english}{\makeatletter\input{doclicense-english.ldf}\makeatother\doclicenseText\\\doclicenseIcon}{
    \iflanguage{french}{\makeatletter\input{doclicense-french.ldf}\makeatother\doclicenseText\\\doclicenseIcon}{
    \iflanguage{german}{\makeatletter\input{doclicense-german.ldf}\makeatother\doclicenseText\\\doclicenseIcon}{
    \iflanguage{spanish}{\makeatletter\input{doclicense-spanish.ldf}\makeatother\doclicenseText\\\doclicenseIcon}{
    \iflanguage{portuguese}{\makeatletter\input{doclicense-brazilian.ldf}\makeatother\doclicenseText\\\doclicenseIcon}{\doclicenseText\par\doclicenseIcon}
    }}}}}
\def\@keywordsname{
    \iflanguage{english}{Keywords}{
    \iflanguage{french}{Mots-cl\'{e}s}{
    \iflanguage{german}{Schl\"{u}sselw\"{o}rter}{
    \iflanguage{spanish}{Palabras clave}{
    \iflanguage{portuguese}{\hspace{-1ex}Palavras-chave}{Keywords}
    }}}}}
\def\@authornotename{Author's notes}
\def\@keycorrauthorname{
    \iflanguage{english}{Corresponding author}{
    \iflanguage{french}{\hspace{-2.25pt}Auteur correspondant}{
    \iflanguage{german}{\hspace{-2.5pt}Entsprechender Autor}{
    \iflanguage{spanish}{\hspace{-5.5pt}Autor correspondiente}{
    \iflanguage{portuguese}{\hspace{-7pt}Autor Correspondente}{Corresponding author}
    }}}}}
\def\@corrauthorname{\@keycorrauthorname}
\def\@keyeditorname{
    \iflanguage{english}{Edited by}{
    \iflanguage{french}{\hspace{-2.25pt}Édité par}{
    \iflanguage{german}{\hspace{-2.5pt}Bearbeitet von}{
    \iflanguage{spanish}{\hspace{-5.5pt}Editado por}{
    \iflanguage{portuguese}{\hspace{-7pt}Editado por}{Edited by}
    }}}}}
\def\@editorname{\@keyeditorname}
\def\@runningauthor{}
\def\@journalname{}
\def\@corrauthor{}
\def\@authornote{}
\def\@articledoi{}
\definecolor{TLLightGreen}{RGB}{184,198,36}
\definecolor{TLDarkGreen}{RGB}{56,52,49}
\definecolor{TLDarkGray}{RGB}{153,153,153}

\RequirePackage{microtype}
\newif\ifxetexorluatex
\ifxetex
  \xetexorluatextrue
\else
  \ifluatex
    \xetexorluatextrue
  \else
    \xetexorluatexfalse
  \fi
\fi

\setstretch{1.15}

\RequirePackage{geometry}
\geometry{a4paper, 
  left=4.75cm,top=1.75cm,bottom=2.4cm,right=2.1cm,
  footskip=1.5\baselineskip,footnotesep=\baselineskip,headheight=21\p@,headsep=\baselineskip}

\newcommand{\runningauthor}[1]{\def\@runningauthor{#1}}
\newcommand{\journalname}[1]{\def\@journalname{#1}}
\newcommand{\authornote}[1]{\def\@authornote{#1}}
\newcommand{\corrauthor}[1]{\def\@corrauthor{#1}}
\newcommand{\articledoi}[1]{\def\@articledoi{#1}}

\renewcommand{\Authfont}{\large\bfseries}
\renewcommand{\Affilfont}{\small\itshape\mdseries}
\renewcommand\AB@authnote[1]{\textsuperscript{#1}}
\renewcommand\AB@affilnote[1]{\textsuperscript{#1}}
\setlength{\affilsep}{\baselineskip}

\newcommand{\more@metadata}{%
  %\emph{\bfseries \@journalname\ (\the\year)}\par
  \@cover@logo\par
  \textcolor{TLDarkGreen}{\bfseries DOI: }\@articledoi\par
  \textcolor{TLDarkGreen}{\bfseries\@corrauthorname}\\\if@textolivre@anonymous\@emptyfieldtext\else\@corrauthor\fi\par
  \textcolor{TLDarkGreen}{\bfseries\@editorname}\\Leonardo Araujo\par
  \textcolor{TLDarkGreen}{\bfseries\@keyreceivedtext}\\\@receiveddate\\
  \textcolor{TLDarkGreen}{\bfseries\@keyacceptedtext}\\\@accepteddate\\
  \textcolor{TLDarkGreen}{\bfseries\@keypublishedtext}\\\@publisheddate\par
  \tlprintlicense
  %\doclicenseText\\
  %\doclicenseIcon
  %\textcopyright\space The Author(s) \the\year.
  %Published by Cambridge University Press on behalf of the Society for Political Methodology.%
}

\newcommand{\@cover@logo}{%
  \includegraphics[width=0.9\textwidth]{logo.pdf}\\
  \minsizebox{0.9\textwidth}{1ex}{Linguagem e Tecnologia} 
}

%\newcommand{\@cover@logo}{%
%  \begin{textblock*}{3.3cm}[0,1](0.5cm,5.5cm) %\dimexpr\paperheight-\Gm@bmargin\relax)
%  \scriptsize\raggedright%
%  \setlength{\parskip}{\baselineskip}%
%  \setlength{\parindent}{\z@}%
%  \includegraphics[angle=90,height=5cm]{logo.png}\par
%  \end{textblock*}
%}

%\newsavebox{\mygraphic}
%\sbox{\mygraphic}{\includegraphics[width=3.5cm]{logo.png}} 
%\newcommand{\@cover@logo}{%
%  \begin{picture}(0,0)\put(300,20){\usebox{\mygraphic}}\end{picture} 
%}

\def\thevolume#1{\gdef\@thevolume{#1}}
\def\thenumber#1{\gdef\@thenumber{#1}}
\def\theyear#1{\gdef\@theyear{#1}}
\RequirePackage[useregional]{datetime2}
%\RequirePackage[orig]{isodate}
\def\receiveddate#1{\gdef\@receiveddate{#1}}
\def\accepteddate#1{\gdef\@accepteddate{#1}}
\def\publisheddate#1{\gdef\@publisheddate{#1}}
\def\@keyreceivedtext{
    \iflanguage{english}{Received on}{
    \iflanguage{french}{\hspace{-2.25pt}Reçu en}{
    \iflanguage{german}{\hspace{-2.5pt}Empfangsdatum}{
    \iflanguage{spanish}{\hspace{-6pt}Recibido el}{
    \iflanguage{portuguese}{\hspace{-7pt}Recebido em}{Received on}
    }}}}}
\def\@keyacceptedtext{
    \iflanguage{english}{Accepted on}{
    \iflanguage{french}{\hspace{-2.25pt}Acceptée en}{
    \iflanguage{german}{\hspace{-2.5pt}Akzeptiertes Datum}{
    \iflanguage{spanish}{\hspace{-6pt}Aceptado el}{
    \iflanguage{portuguese}{\hspace{-6.5pt}Aceito em}{Accepted on}
    }}}}}
\def\@keypublishedtext{
    \iflanguage{english}{Published on}{
    \iflanguage{french}{\hspace{-2.25pt}Publication en}{
    \iflanguage{german}{\hspace{-2.5pt}Veröffentlichungsdatum}{
    \iflanguage{spanish}{\hspace{-6pt}Publicado el}{
    \iflanguage{portuguese}{\hspace{-7pt}Publicado em}{Published on}
    }}}}}
%\def\othertitle#1{\gdef\@othertitle{#1}}
%\def\@othertitle{\@latex@error{No \noexpand\othertitle given}\@ehc}

\newcounter{cntothertitle}
\newcommand\othertitle[1]{%
  \stepcounter{cntothertitle}%
  \csdef{othertitle\thecntothertitle}{#1}}
\newcommand\getothertitle[1]{%
  \csuse{othertitle#1}}

\newcounter{ititle}
\newcommand\printothertitles[1]{%
  \setcounter{ititle}{0}%
  \whileboolexpr
    { test {\ifnumcomp{\value{ititle}}{<}{#1}} }%
    {\stepcounter{ititle}\Large\smaller[\the\numexpr\value{ititle}-1\relax]\getothertitle{\theititle}\par}
  }

\newcommand{\@insert@metadata}{%
  \begin{textblock*}{3.3cm}[0,1](1cm,\dimexpr\paperheight-\Gm@bmargin\relax)
  \scriptsize\raggedright%
  \setlength{\parskip}{\baselineskip}%
  \setlength{\parindent}{\z@}%
  \more@metadata\par
  \end{textblock*}
}
\AtBeginDocument{
\renewcommand{\@maketitle}{%
  \@insert@metadata%
  \noindent\begin{minipage}{0.9\linewidth}
  \raggedright\setstretch{1.0}
  {\LARGE\bfseries\@title\par}
  %\vskip\baselineskip
  %{\color{TLDarkGreen}\large\bfseries\@othertitle\par}
  %{\Large\@othertitle\par}
  {\printothertitles{\thecntothertitle}}
  \vskip\baselineskip
  \if@textolivre@anonymous\@emptyfieldtext\else\@author\fi\par
  \end{minipage}\bigskip\normalfont\normalsize%
}
\appto{\maketitle}{%
  \ifdefvoid{\@authornote}{}{\begingroup
    \renewcommand{\thefootnote}{}
    \footnotetext{\emph{\@authornotename:} \@authornote}%
  \endgroup}%
}

\renewcommand{\abstitlestyle}[1]{{\large\bfseries #1\par}}
\setlength{\absleftindent}{\z@}
\setlength{\absrightindent}{\absleftindent}
\preto{\abstract}{%
  \setlength{\parindent}{\z@}%
  \def\sep{\unskip. }%
  \newcommand{\keywords}[1]{%
  \emph{\@keywordsname : }\titlecap{#1}\par
  }
}
\appto{\abstract}{%
  \setlength{\parindent}{\z@}%
  \setlength{\parskip}{1em}%
  \vskip-\parskip%
  \noindent\ignorespaces%
}

% add source to lising
\makeatletter
\lst@Key{source}{}{\def\lst@source{#1}}

\let\orig@lst@MakeCaption=\lst@MakeCaption
\def\lst@MakeCaption#1{%
    \orig@lst@MakeCaption#1%
    \ifx b#1%
        \ifx\lst@source\@empty\else
            \noindent
            \hspace{-13pt}\normalfont\textcolor{TLDarkGreen}{\textit{\textSource}}\lst@source\expandafter%
            \vskip\belowcaptionskip
        \fi
    \fi
}
\makeatother


} % end AtBeginDocument

\newenvironment{poliabstract}
{\noindent\textcolor{TLLightGreen}{\rule{\linewidth}{1.0pt}}\par}
{\vspace{-1.5ex}\noindent\textcolor{TLLightGreen}{\rule{\linewidth}{.5pt}}\par}

\titleformat{\section}{\large\bfseries}{\hspace*{-1em}\makebox[\z@][r]{\thesection}}{1em}{}
\titleformat{\subsection}{\large}{\hspace*{-1em}\makebox[\z@][r]{\thesubsection}}{1em}{}
\titlespacing*{\section}{\z@}{\baselineskip}{\z@}
\titlespacing*{\subsection}{\z@}{\baselineskip}{\z@}
\titlespacing*{\subsubsection}{\z@}{\baselineskip}{\z@}
\setcounter{secnumdepth}{2}

\setlist{leftmargin=*,nosep}

\setlength{\footnotemargin}{-1em}
\pretocmd{\@makefntext}{%
  \renewcommand{\@makefnmark}{\thefootnote}
}{}{}

\fancyhf{}
\renewcommand{\footrulewidth}{1.5\p@}
\renewcommand{\headrule}{}
\preto{\footrule}{\begingroup\color{TLLightGreen}}
\appto{\footrule}{\endgroup}
%\fancyhead[L]{\hspace*{-4cm}\Huge\color{TLDarkGray}TL}
\fancyfoot[R]{\small\thepage}
\fancyfoot[L]{\small\emph{\if@textolivre@anonymous\@emptyfieldtext\else\@runningauthor\fi}\enskip|\enskip\@journalname\quad{v.\@thevolume\enskip n.\@thenumber\enskip (\@theyear)}}
%\fancyfoot[L]{\small\emph{\@runningauthor}}
\pagestyle{fancy}
\fancypagestyle{plain}{%
  \fancyhf{}
  \renewcommand{\footrule}{}
  \fancyfoot[R]{\small\thepage}
}

\captionsetup*{singlelinecheck=false,font={small},labelfont={bf,color=TLDarkGreen},labelsep=period}
\captionsetup*[table]{position=top}
\captionsetup*[sub]{labelfont=small,justification=centering}
\newcommand{\headrow}{\rowcolor{TLDarkGray}}
\newcommand{\thead}[1]{\bfseries #1\rule[-1.2ex]{0pt}{2em}}
\renewcommand{\arraystretch}{1.2}

\RequirePackage[backend=biber,style=abnt, ittitles]{biblatex}
\DeclareLanguageMapping{brazil}{brazil-apa}
%\RequirePackage[backend=biber,authordate,giveninits=true,uniquename=mininit,natbib]{biblatex-chicago}
%\xpatchbibmacro{name:andothers}{%
%  \bibstring{andothers}%
%}{%
%  \bibstring[\emph]{andothers}%
%}{}{}

%\newcommand{\insert@supplmat}{\section*{Supplementary Material}(This is dummy text) For supplementary material accompanying this paper, please visit \url{https://doi.org/10.1017/pan.xxxx.xx.}}
%\if@suppmat
%  \xpretocmd{\printbibliography}{\insert@supplmat}{}{}
%  \AtBeginEnvironment{thebibliography}{\insert@supplmat}
%\fi
\renewcommand{\bibfont}{\small}

\PassOptionsToPackage{hyphens}{url}
\RequirePackage[breaklinks=true]{hyperref}
% (Less aggressive) Treat both / and - as breakable characters 
%\renewcommand{\UrlBreaks}{\do\/\do\-}
%\def\UrlBreaks{\do\/\do-\do.\do=\do?\do\&}
% (More aggressive) Any letter and / are treated as breakable characters
\renewcommand{\UrlBreaks}{\do\/\do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z\do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L\do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z}
\hypersetup{colorlinks,allcolors=TLDarkGreen}
\urlstyle{same}
%\RequirePackage[hyphenbreaks]{breakurl}
%\RequirePackage{breakurl}

%\RequirePackage{cleveref}
\RequirePackage[english,french,spanish,brazilian]{cleveref}

% used to provide source code environment
\crefname{lstlisting}{lista}{listas}
\Crefname{lstlisting}{Lista}{Listas}
\RequirePackage{listings}
\renewcommand\lstlistingname{Lista}
\lstset{language=bash,
        breaklines=true,
        basicstyle=\linespread{1}\small\ttfamily,
        numbers=none,xleftmargin=0.5cm,
        frame=none,
        framexleftmargin=0.5em,
        framexrightmargin=0.5em,
        showstringspaces=false,
        upquote=true,
        commentstyle=\color{gray},
        literate=%
           {á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1 
           {à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
           {ã}{{\~a}}1 {ẽ}{{\~e}}1 {ĩ}{{\~i}}1 {õ}{{\~o}}1 {ũ}{{\~u}}1
           {â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
           {ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
           {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
           {À}{{\`A}}1 {È}{{\`E}}1 {Ì}{{\`I}}1 {Ò}{{\`O}}1 {Ù}{{\`U}}1
           {Ã}{{\~A}}1 {Ẽ}{{\~E}}1 {Ũ}{{\~u}}1 {Õ}{{\~O}}1 {Ũ}{{\~U}}1
           {Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\^U}}1
           {Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\"I}}1 {Ö}{{\"O}}1 {Ü}{{\"U}}1
           {ç}{{\c{c}}}1 {Ç}{{\c{C}}}1
}


%%%% source START 
%%%% define source for table and figures
% set sourceVspace for table or not-table (figure)
\makeatletter
\newcommand{\sourceVspace}{%
  \ifx\@currenvir\@table
    0pt
  \else
     \ifx\@currenvir\@figure
     -10pt
     \else
     -7pt
     \fi
  \fi}
\newcommand*\@table{table}
\newcommand*\@longtable{longtable}
\newcommand*\@figure{figure}
\makeatother

\newcommand{\textSource}{%
  \iflanguage{english}{Source:}{%
  \iflanguage{french}{Source:}{%
  \iflanguage{german}{Quelle:}{%
  \iflanguage{spanish}{Fuente:}{%
  \iflanguage{portuguese}{Fonte:}{Source:}
  }}}}}
%\newcommand{\source}[1]{
%  \vspace{\sourceVspace}\caption*{\textcolor{TLDarkGreen}{\textit{\textSource}} {#1}}
%}
\newcommand{\source}[1]{
 \captionsetup{skip=0ex,position=b}%
 \caption*{\textcolor{TLDarkGreen}{\textit{\textSource}} {#1}}
}
%%%% source END


%\RequirePackage[autostyle,portuguese=brazilian]{csquotes}
%\RequirePackage[style=brazilian]{csquotes}
%\patchcmd{\quote}{\rightmargin}{\leftmargin 4em \rightmargin}{}{}

% change quote margins
%\renewenvironment{quote}
%  {\small\list{}{\rightmargin=0em \leftmargin=6em}%
%   \item\relax}
%  {\endlist}


\RequirePackage{academicons}
% ORCID
\newcommand{\orcid}[1]{\href{https://orcid.org/#1}{\textcolor[HTML]{B8C624}{\aiOrcid}}}
% A6CE39

