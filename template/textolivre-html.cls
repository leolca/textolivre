\ProvidesClass{textolivre-html}[2021/01/22 Texto Livre HTML class]
\newif\if@suppmat\@suppmattrue
\DeclareOption{nosupp}{\@suppmatfalse}
\ProcessOptions\relax
\ExecuteOptions{}
\PassOptionsToPackage{inline}{enumitem}
\LoadClass[brazil,article]{abntex2}

\RequirePackage[utf8]{inputenc}
\RequirePackage[brazil]{babel}

\newcommand{\othertitle}[1]{\tituloestrangeiro{#1}}
\newcommand{\orcid}[1]{}
\newcommand{\journalname}[1]{}
\newcommand{\thevolume}[1]{}
\newcommand{\thenumber}[1]{}
\newcommand{\theyear}[1]{}
\newcommand{\receiveddate}[1]{}
\newcommand{\accepteddate}[1]{}
\newcommand{\publisheddate}[1]{}
\newcommand{\corrauthor}[1]{}
\newcommand{\articledoi}[1]{}
\newcommand{\runningauthor}[1]{}
\newenvironment{poliabstract}{}{}
%\newenvironment{english}{}{}
%\newenvironment{portuguese}{}{}
%\newcommand{\setdefaultlanguage}[2][1]{}
%\newcommand{\setotherlanguage}[2][1]{}
\def\sep{\unskip. }%
\newcommand{\keywords}[1]{\textbf{Palavras-chave}: #1}
%\newcommand{\source}[1]{\textbf{Fonte}: \legend{#1}}
\newcommand{\source}[1]{}
\RequirePackage{authblk}
\RequirePackage{hyperref}

\RequirePackage[alf]{abntex2cite}
\newcommand{\textcite}[1]{\citeauthoronline{#1}}
\newcommand{\parencite}[1]{(\cite{#1})}
\RequirePackage[inline]{enumitem}
%\renewenvironment{enumerate}{\begin{alineas}}{\end{alineas}}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{rotating}
\RequirePackage{subcaption}
\RequirePackage{booktabs}
\RequirePackage{amsmath,amsfonts,amssymb,amsthm}
\AtBeginDocument{\renewenvironment{subequations}{}{}}
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

\RequirePackage{polyglossia} 
\setmainlanguage{english}

% defining how to set bibliography file and print
\def\@bibfilesource{}
\newcommand{\setbibligraphyfile}[1]{\def\@bibfilesource{#1}}
%\newcommand{\tlprintbibliography}{\bibliographystyle{abnt-alf}\bibliography{\@bibfilesource}}
\newcommand{\tlprintbibliography}{\bibliography{\@bibfilesource}}
\newcommand{\citefield}[3][]{#1 {\citeonline{#2}}}
