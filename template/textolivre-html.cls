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
\newcommand{\articledoi}[1]{}
\newcommand{\runningauthor}[1]{}
\newenvironment{poliabstract}{}{}
\def\sep{\unskip. }%
\newcommand{\keywords}[1]{\textbf{Palavras-chave}: #1}
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

