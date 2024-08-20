\ProvidesClass{textolivre-simples}[2024/01/10 Texto Livre simple class]
\LoadClassWithOptions{article}

\RequirePackage{authblk}

\RequirePackage[backend=biber,style=abnt,ittitles,repeatfields,sorting=nyt,maxcitenames=3,maxbibnames=999]{biblatex}
\DeclareLanguageMapping{brazil}{brazil-apa}

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

\RequirePackage{cleveref}
\RequirePackage{graphicx}
\RequirePackage{booktabs,threeparttable}

\newenvironment{polyabstract}{}{}
\newenvironment{english}{}{}
\newenvironment{portuguese}{}{}
\newenvironment{spanish}{}{}
\newenvironment{contributors}[1][]{%
    \section*{Author Contributions}
    \begin{itemize}
}
{
    \end{itemize}
}
\newcommand{\authorcontribution}[1]{\item #1}

% fake metadata commands
\newcommand{\orcid}[1]{#1}
\newcommand{\href}[2]{#2}
\newcommand{\sep}{,}
\newcommand{\notes}[1]{}
\newcommand{\source}[1]{}
\newcommand{\journalname}[1]{}
\newcommand{\thevolume}[1]{}
\newcommand{\theyear}[1]{}
\newcommand{\receiveddate}[1]{}
\newcommand{\accepteddate}[1]{}
\newcommand{\publisheddate}[1]{}
\newcommand{\corrauthor}[1]{}
\newcommand{\articledoi}[1]{}
\newcommand{\articlesessionname}[1]{}
\newcommand{\runningauthor}[1]{}
\newcommand{\sectioneditorname}[1]{}
\newcommand{\layouteditorname}[1]{}
\newcommand{\othertitle}[1]{}
\newcommand{\DTMdisplaydate}[4]{}

\providecommand{\keywords}[1]{\textbf{\textit{Keywords---}} #1}
