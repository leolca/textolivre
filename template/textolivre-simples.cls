\ProvidesClass{textolivre-simples}[2024/01/10 Texto Livre simple class]
\LoadClassWithOptions{article}

\RequirePackage{authblk}

\RequirePackage[backend=biber,style=abnt,ittitles,repeatfields,sorting=nyt,maxcitenames=3,maxbibnames=999]{biblatex}
\DeclareLanguageMapping{brazil}{brazil-apa}

\RequirePackage{cleveref}
\RequirePackage{graphicx}
\RequirePackage{booktabs,threeparttable}

\newenvironment{polyabstract}{}{}
\newenvironment{contributors}[1][]{%
    \section*{\GetTranslation{authorcontributions}}
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

\providecommand{\keywords}[1]{\textbf{\textit{Keywords---}} #1}
