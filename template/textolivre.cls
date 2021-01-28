\ProvidesClass{textolivre}[2020/11/24 Texto Livre class]
\newif\if@suppmat\@suppmattrue
\DeclareOption{nosupp}{\@suppmatfalse}
\ProcessOptions\relax
\ExecuteOptions{}
\LoadClass{article}

\RequirePackage{etoolbox,xpatch}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{setspace}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
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
\RequirePackage[standard-baselineskips]{cmbright}
\RequirePackage{fontspec}
\RequirePackage{polyglossia} 
\setmainlanguage{english}
%\RequirePackage[default]{sourcesanspro}

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
\RequirePackage{longtable,booktabs,tabularx}

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
    \iflanguage{spanish}{\hspace{-1ex}Palabras clave}{
    \iflanguage{portuguese}{\hspace{-2ex}Palavras-chave}{Keywords}
    }}}}}
\def\@authornotename{Author's notes}
\def\@keycorrauthorname{
    \iflanguage{english}{Corresponding author}{
    \iflanguage{french}{\hspace{-5pt}Auteur correspondant}{
    \iflanguage{german}{\hspace{-2.5pt}Entsprechender Autor}{
    \iflanguage{spanish}{\hspace{-10pt}Autor correspondiente}{
    \iflanguage{portuguese}{\hspace{-13pt}Autor Correspondente}{Corresponding author}
    }}}}}
\def\@corrauthorname{\@keycorrauthorname}
\def\@keyeditorname{
    \iflanguage{english}{Edited by}{
    \iflanguage{french}{\hspace{-5pt}Édité par}{
    \iflanguage{german}{\hspace{-2.5pt}Bearbeitet von}{
    \iflanguage{spanish}{\hspace{-10pt}Editado por}{
    \iflanguage{portuguese}{\hspace{-13pt}Editado por}{Edited by}
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
  left=4.75cm,top=1.75cm,bottom=2.4cm,right=1.5cm,
  footskip=1.5\baselineskip,footnotesep=\baselineskip,headheight=21\p@,headsep=\baselineskip}

\RequirePackage{xstring}

\newcommand{\runningauthor}[1]{\def\@runningauthor{#1}}
\newcommand{\journalname}[1]{\def\@journalname{#1}}
\newcommand{\authornote}[1]{\def\@authornote{#1}}
\newcommand{\corrauthor}[1]{\def\@corrauthor{#1}}
\newcommand{\articledoi}[1]{\def\@articledoi{#1}}
\newcommand{\articleenumber}{e\StrRight{\@articledoi}{5}}


\renewcommand{\Authfont}{\large\bfseries}
\renewcommand{\Affilfont}{\small\itshape\mdseries}
\renewcommand\AB@authnote[1]{\textsuperscript{#1}}
\renewcommand\AB@affilnote[1]{\textsuperscript{#1}}
\setlength{\affilsep}{\baselineskip}

\newcommand{\more@metadata}{%
  \@cover@logo\par
  \textcolor{TLDarkGreen}{\bfseries DOI: }\@articledoi\par
  \textcolor{TLDarkGreen}{\bfseries\@corrauthorname}\\\@corrauthor\par
  \textcolor{TLDarkGreen}{\bfseries\@editorname}\\Leonardo Araujo\par
  \textcolor{TLDarkGreen}{\bfseries\@keyreceivedtext}\\\@receiveddate\\
  \textcolor{TLDarkGreen}{\bfseries\@keyacceptedtext}\\\@accepteddate\\
  \textcolor{TLDarkGreen}{\bfseries\@keypublishedtext}\\\@publisheddate\par
  \tlprintlicense
}

\newcommand{\@cover@logo}{%
  \includegraphics[width=0.9\textwidth]{logo.pdf}\\
  \minsizebox{0.9\textwidth}{1ex}{Linguagem e Tecnologia} 
}

\def\thevolume#1{\gdef\@thevolume{#1}}
\def\thenumber#1{\gdef\@thenumber{#1}}
\def\theyear#1{\gdef\@theyear{#1}}
\AtBeginDocument{
\RequirePackage[useregional]{datetime2}
}
\def\receiveddate#1{\gdef\@receiveddate{#1}}
\def\accepteddate#1{\gdef\@accepteddate{#1}}
\def\publisheddate#1{\gdef\@publisheddate{#1}}
\def\@keyreceivedtext{
    \iflanguage{english}{Received on}{
    \iflanguage{french}{\hspace{-5pt}Reçu en}{
    \iflanguage{german}{\hspace{-2.5pt}Empfangsdatum}{
    \iflanguage{spanish}{\hspace{-10pt}Recibido el}{
    \iflanguage{portuguese}{\hspace{-13pt}Recebido em}{Received on}
    }}}}}
\def\@keyacceptedtext{
    \iflanguage{english}{Accepted on}{
    \iflanguage{french}{\hspace{-5pt}Acceptée en}{
    \iflanguage{german}{\hspace{-2.5pt}Akzeptiertes Datum}{
    \iflanguage{spanish}{\hspace{-10pt}Aceptado el}{
    \iflanguage{portuguese}{\hspace{-13pt}Aceito em}{Accepted on}
    }}}}}
\def\@keypublishedtext{
    \iflanguage{english}{Published on}{
    \iflanguage{french}{\hspace{-5pt}Publication en}{
    \iflanguage{german}{\hspace{-2.5pt}Veröffentlichungsdatum}{
    \iflanguage{spanish}{\hspace{-10pt}Publicado el}{
    \iflanguage{portuguese}{\hspace{-13pt}Publicado em}{Published on}
    }}}}}

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
    {\stepcounter{ititle}\Large\smaller[\the\numexpr\value{ititle}-1\relax]\makefirstuc{\MakeLowercase{\getothertitle{\theititle}}}\par}
  }

\RequirePackage{mfirstuc}

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
  {\LARGE\bfseries{\makefirstuc{\MakeLowercase{\@title}}}\par}
  {\printothertitles{\thecntothertitle}}
  \vskip\baselineskip
  \@author\par
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
\titleformat{\subsubsection}{\normalsize}{\hspace*{-1em}\makebox[\z@][r]{\thesubsubsection}}{1em}{}
\titlespacing*{\section}{\z@}{\baselineskip}{\z@}
\titlespacing*{\subsection}{\z@}{\baselineskip}{\z@}
\titlespacing*{\subsubsection}{\z@}{\baselineskip}{\z@}
\setcounter{secnumdepth}{3}

\setlist{leftmargin=*,nosep}

\setlength{\footnotemargin}{-1em}
\pretocmd{\@makefntext}{%
  \renewcommand{\@makefnmark}{\thefootnote}
}{}{}

\RequirePackage{lastpage}

\fancyhf{}
\renewcommand{\footrulewidth}{1.5\p@}
\renewcommand{\headrule}{}
\preto{\footrule}{\begingroup\color{TLLightGreen}}
\appto{\footrule}{\endgroup}
%\fancyfootoffset[LE,RO]{\marginparsep+\marginparwidth}
\fancyfootoffset[L]{3.25cm}
\fancyfoot[R]{\small\thepage/\pageref*{LastPage}}
\fancyfoot[L]{\small\emph{\@runningauthor}\enskip|\enskip\@journalname\enskip|\enskip{Belo Horizonte}\enskip|\enskip{v.\@thevolume}\enskip|\enskip{n.\@thenumber}\enskip|\enskip\articleenumber\enskip|\enskip\@theyear}
\pagestyle{fancy}
\fancypagestyle{plain}{%
  \fancyhf{}
  \renewcommand{\footrule}{}
  \fancyfoot[R]{\small\thepage/\pageref*{LastPage}}
}

\captionsetup*{singlelinecheck=false,font={small},labelfont={bf,color=TLDarkGreen},labelsep=period}
\captionsetup*[table]{position=top}
\captionsetup*[sub]{labelfont=small,justification=centering}
\newcommand{\headrow}{\rowcolor{TLDarkGray}}
\newcommand{\thead}[1]{\bfseries #1\rule[-1.2ex]{0pt}{2em}}
\renewcommand{\arraystretch}{1.2}

\RequirePackage[backend=biber,style=abnt,ittitles]{biblatex}
\DeclareLanguageMapping{brazil}{brazil-apa}
\renewcommand{\bibfont}{\small}

\PassOptionsToPackage{hyphens}{url}
\RequirePackage[breaklinks=true,pdfa=true]{hyperref}
\renewcommand{\UrlBreaks}{\do\/\do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z\do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L\do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z}
\hypersetup{colorlinks,allcolors=TLDarkGreen}
\urlstyle{same}

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
\newcommand{\source}[1]{
 \captionsetup{skip=0ex,position=b}%
 \caption*{\textcolor{TLDarkGreen}{\textit{\textSource}} {#1}}
}
%%%% source END

\RequirePackage{academicons}
% ORCID
\newcommand{\orcid}[1]{\href{https://orcid.org/#1}{\textcolor[HTML]{B8C624}{\aiOrcid}}}
% A6CE39

% PDF/A
\RequirePackage[a-1b]{pdfx}
\hypersetup{pdfpagelabels}
\RequirePackage{inputenc}
\hypersetup{pdfencoding=unicode}
\inputencoding{utf8}
\makeatother

