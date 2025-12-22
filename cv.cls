\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cv}[2025/12/21 Custom CV Class]

\LoadClass[11pt,letterpaper]{article}

% --- Packages ---
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[default]{sourcesanspro}
\RequirePackage[margin=0.75in]{geometry}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{hyperref}
\RequirePackage{xcolor}
\RequirePackage{fontawesome5}
\RequirePackage{fancyhdr}
\RequirePackage{tabularx}
\RequirePackage{lastpage}

% --- Colors ---
\definecolor{primary}{RGB}{0, 75, 120} 
\definecolor{secondary}{RGB}{80, 80, 80}

% --- Hyperref Setup ---
\hypersetup{colorlinks,breaklinks,urlcolor=primary,linkcolor=primary}

% --- Header/Footer ---
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[C]{Page \thepage\ of \pageref*{LastPage}}
\fancyfoot[R]{\footnotesize\color{secondary}\ifdefined\@lastupdated Last updated: \@lastupdated\fi}

% --- Section Styling ---
\titleformat{\section}
  {\Large\bfseries\color{primary}\uppercase}
  {}
  {0em}
  {}
  [\titlerule]
\titlespacing*{\section}{0pt}{12pt}{8pt}

\titleformat{\subsection}
  {\large\bfseries\color{secondary}}
  {}
  {0em}
  {}
\titlespacing*{\subsection}{0pt}{10pt}{5pt}

% --- Personal Info Commands ---
\newcommand{\name}[2]{\def\@firstname{#1}\def\@lastname{#2}}
\newcommand{\position}[1]{\def\@position{#1}}
\newcommand{\address}[1]{\def\@address{#1}}
\newcommand{\email}[1]{\def\@email{#1}}
\newcommand{\website}[1]{\def\@website{#1}}
\newcommand{\tagline}[1]{\def\@tagline{#1}}
\newcommand{\lastupdated}[1]{\def\@lastupdated{#1}}

% --- Header Command ---
\newcommand{\makecvheader}{
  \begin{center}
    {\Huge\bfseries \@firstname\ \@lastname} \\[0.5em]
    {\Large \@position} \\[0.5em]
    {\color{secondary}
    \ifdefined\@address \faMapMarker*\ \@address \quad \fi
    \ifdefined\@email \faEnvelope\ \href{mailto:\@email}{\@email} \quad \fi
    \ifdefined\@website \faGlobe\ \href{https://\@website}{\@website} \fi
    }
  \end{center}
  \ifdefined\@tagline
  \begin{center}
    \small \textit{\@tagline}
  \end{center}
  \vspace{0.5em}
  \fi
}

% --- BibLaTeX ---
\RequirePackage[
bibstyle=reading,
isbn=false,
doi=false,
url=false,
sorting=ydnt,
maxbibnames=6,
minbibnames=6,
backend=biber,
style=phys
]{biblatex}

% Suppress label in bibliography
\DeclareFieldFormat{labelnumberwidth}{}
\DeclareFieldFormat{annotation}{ #1}

% Get annotation on the same line
\renewbibmacro{finentry}{%
  \setlength{\parskip}{0.5\baselineskip plus 2pt}%
  \setlength{\parindent}{1em}%
  \usebibmacro{annotation}%
  \finentry
}

% Author limit adjustment
\makeatletter
\newrobustcmd*{\setmaxbibnames}{\numdef\blx@maxbibnames}
\newrobustcmd*{\setminbibnames}{\numdef\blx@minbibnames}
\makeatother

% Remove fields
\AtEveryBibitem{\clearfield{pubstate}}
\AtEveryBibitem{\clearfield{abstract}}
\AtEveryBibitem{%
  \iffieldequalstr{entrysubtype}{newspaper}{}{\clearfield{url}}%
}
\AtEveryBibitem{\clearfield{type}}

% Link journal title and date if URL is present
\DeclareFieldFormat{journaltitle}{%
  \iffieldundef{url}{#1}{\href{\thefield{url}}{#1}}%
}
\DeclareFieldFormat{date}{%
  \iffieldundef{url}{#1}{\href{\thefield{url}}{#1}}%
}

% Custom Bibliography Checks
\defbibcheck{inprep}{\ifkeyword{cv_inprep}{}{\skipentry}}
\defbibcheck{preprint}{\ifkeyword{cv_preprint}{}{\skipentry}}
\defbibcheck{published}{\ifkeyword{cv_journal}{}{\skipentry}}
\defbibcheck{invitedtalk}{\ifkeyword{cv_invited}{}{\skipentry}} 
\defbibcheck{talk}{\ifkeyword{cv_talk}{}{\skipentry}}
\defbibcheck{poster}{\ifkeyword{cv_poster}{}{\skipentry}}
\defbibcheck{press}{\ifkeyword{cv_press}{}{\skipentry}}

% --- Bibliography Printing Macros ---
\newcommand{\cvInPrep}{
  \printbibliography[heading=none, check=inprep]
}
\newcommand{\cvPreprints}{
  \printbibliography[heading=none, check=preprint, env=publicationlist]
}
\newcommand{\cvArticles}{
  \printbibliography[heading=none, check=published, env=publicationlist]
}
\newcommand{\cvMedia}{
  \printbibliography[heading=none, check=press, env=publicationlist]
}
\newcommand{\cvInvitedTalks}{
  \printbibliography[heading=none, check=invitedtalk]
}
\newcommand{\cvContributedTalks}{
  \printbibliography[heading=none, check=talk]
}
\newcommand{\cvPosters}{
  \printbibliography[heading=none, check=poster]
}

% Spacing adjustments
\setlength\bibitemsep{0.3\baselineskip}
\renewbibmacro*{begentry}{\hspace{-1.5em}} 

% BOLD NAME LOGIC
\newcommand*{\boldname}[3]{%
  \def\lastname{#1}%
  \def\firstname{#2}%
  \def\firstinit{#3}}
\boldname{}{}{}

\renewcommand{\mkbibnamefamily}[1]{%
  \ifboolexpr{ ( test {\ifdefequal{\firstname}{\namepartgiven}} or test {\ifdefequal{\firstinit}{\namepartgiven}} ) and test {\ifdefequal{\lastname}{\namepartfamily}} }
  {\mkbibbold{#1}}{#1}%
}

% Custom Bibliography Environment
\defbibenvironment{bibliography}
  {\list
     {}
     {\setlength{\leftmargin}{0in}%
      \setlength{\itemindent}{0in}%
      \setlength{\itemsep}{0.7em}%
      \setlength{\parsep}{0pt}}%
  }
  {\endlist}
  {\item}
% Environment for Publications (with indent and labels)
\defbibenvironment{publicationlist}
  {\list
     {\printtext[labelnumberwidth]{%
      \printfield{labelprefix}%
      \printfield{labelnumber}}}
     {\setlength{\labelwidth}{\labelnumberwidth}%
      \setlength{\leftmargin}{\labelwidth}%
      \setlength{\labelsep}{\biblabelsep}%
      \addtolength{\leftmargin}{\labelsep}%
      \addtolength{\leftmargin}{2.25em}% Indent
      \setlength{\itemsep}{0.5\baselineskip}%
      \setlength{\parsep}{\bibparsep}}%
      \renewcommand*{\makelabel}[1]{\hss##1}}
  {\endlist}
  {\item}
\DeclareFieldFormat{cvtitle}{#1}

% Custom Driver for Unpublished (Talks/Posters)
\DeclareBibliographyDriver{unpublished}{%
  \begin{tabularx}{0.97\textwidth}[t]{>{\raggedright\arraybackslash}X >{\raggedleft\arraybackslash}p{0.25\textwidth}}
    \textbf{\printfield[cvtitle]{title}} & \textbf{\small\color{secondary}\printdate} \\
    \textit{\printfield{eventtitle}} & \textit{\small\color{secondary}\printlist{location}} \\
  \end{tabularx}\vspace{-5pt}
}

% --- Entry Commands ---
\newcommand{\resumeEntry}[4]{
  \vspace{-2pt}\item[]
    \begin{tabularx}{0.97\textwidth}[t]{>{\raggedright\arraybackslash}X >{\raggedleft\arraybackslash}p{0.25\textwidth}}
      \textbf{#1} & \textbf{\small\color{secondary}#2} \\
      \textit{#3} & \textit{\small\color{secondary}#4} \\
    \end{tabularx}\vspace{-5pt}
}

\newcommand{\awardEntry}[4]{
  \vspace{-2pt}\item[]
    \begin{tabularx}{0.97\textwidth}[t]{>{\raggedright\arraybackslash}X >{\raggedleft}p{0.15\textwidth} >{\raggedleft\arraybackslash}p{0.12\textwidth}}
      \textbf{#1} \textit{#2} & #3 & \textbf{\small\color{secondary}#4} \\
    \end{tabularx}\vspace{-5pt}
}

\newenvironment{resumeList}{
  \begin{itemize}[leftmargin=0.15in, label={\tiny\raisebox{0.5ex}{\textbullet}}, itemsep=0pt, parsep=0pt]
}{
  \end{itemize}\vspace{-5pt}
}

% --- General List Environments ---
\newenvironment{cvitems}{
  \begin{itemize}[leftmargin=0in, label={}]
}{
  \end{itemize}
}

\newenvironment{cvbulletitems}{
  \begin{itemize}[leftmargin=0.15in, label={\tiny\raisebox{0.5ex}{\textbullet}}, itemsep=0pt, parsep=0pt]
}{
  \end{itemize}
}

\newcommand{\cvDescription}[1]{
  \item \begin{tabularx}{0.75\linewidth}[t]{>{\raggedright\arraybackslash}X}
    #1
  \end{tabularx}
}

\newcommand{\cvItem}[1]{\item #1}
\newcommand{\cvSkill}[2]{\item \textbf{#1} #2}
\newcommand{\cvCategory}[1]{\textbf{#1}}
\newcommand{\cvOrgEntry}[4]{\resumeEntry{#1}{#2}{#3}{#4}}
\newcommand{\cvSessionEntry}[4]{\resumeEntry{#1}{#2}{#3}{#4}}
\newcommand{\cvThesis}[2]{\cvItem{Thesis: \href{#2}{\textit{#1}}}}
\newcommand{\cvAwardNote}[1]{\newline \footnotesize\textit{#1}}
\newcommand{\cvTagSep}{\ \textbullet\ }
\newcommand{\cvLink}[2]{\href{#1}{#2}}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5em}
