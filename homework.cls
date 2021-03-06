% homework.cls
% LaTeX class for typesetting homework
% Author: Artem Mavrin
%
% The most recent version can be found here:
% https://github.com/artemmavrin/latex-homework/blob/master/homework.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[2017/11/09 LaTeX class for typesetting homework]


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class base and options %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Support for key-value class options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
  family=HW,
  prefix=HW@,
}

% Options for 10pt, 11pt, or 12pt fonts
% We don't defer this to the article class because we want 12pt to be the
% default font size
\def\@fontsize{12pt}
\DeclareVoidOption{10pt}{\renewcommand{\@fontsize}{10pt}}
\DeclareVoidOption{11pt}{\renewcommand{\@fontsize}{11pt}}
\DeclareVoidOption{12pt}{\renewcommand{\@fontsize}{12pt}}

% True/False options. Defaults are False
\DeclareBoolOption{qed}                  % End solutions with a QED tombstone symbol
\DeclareBoolOption{hidesolutions}        % Do not display solutions
\DeclareBoolOption{boxes}                % Wrap problems in boxes
\DeclareBoolOption{pages}                % Each problem on a new page
\DeclareStringOption[black]{color}[blue] % Specify color for boxes

% All other options get passed to the article class
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}

% Process the options provided to the class and load the `article' class
\ProcessKeyvalOptions*
\LoadClass[\@fontsize]{article}


%%%%%%%%%%%%%%%%%%%%
% Homework details %
%%%%%%%%%%%%%%%%%%%%

% Internal names for homework details

% The internal student name, course name, term, and HW number macros have no
% default value and will raise an error if used before being set by their
% corresponding defining macros.
\def\@name{\@latex@error{No \noexpand\name given}\@ehc}
\def\@studentid{\@latex@error{No \noexpand\studentid given}\@ehc}
\def\@email{\@latex@error{No \noexpand\email given}\@ehc}
\def\@course{\@latex@error{No \noexpand\course given}\@ehc}
\def\@courseid{\@latex@error{No \noexpand\courseid given}\@ehc}
\def\@term{\@latex@error{No \noexpand\term given}\@ehc}
\def\@hwnum{\@latex@error{No \noexpand\hwnum given}\@ehc}
\def\@duedate{\@latex@error{No \noexpand\duedate given}\@ehc}
% The following internal homework detail macros have default values and do not
% have to be specified manually.
\def\@hwname{Homework}
\def\@problemname{Problem}
\def\@solutionname{Solution}
% The homework title is determined by the course name, homework name, and
% homework number, and cannot be changed by the user (without redefining
% \@hwtitle).
\def\@hwtitle{\@course\ \@hwname\ \@hwnum}

% The following macros let the user specify the values of the internal homework
% detail macros defined above.

% The following four macros must be used in the preamble.
\def\name#1{\renewcommand\@name{#1}}
\def\studentid#1{\renewcommand\@studentid{#1}}
\def\email#1{\renewcommand\@email{#1}}
\def\course#1{\renewcommand\@course{#1}}
\def\courseid#1{\renewcommand\@courseid{#1}}
\def\term#1{\renewcommand\@term{#1}}
\def\hwnum#1{\renewcommand\@hwnum{#1}}
\def\duedate#1{\renewcommand\@duedate{#1}}
% The following just redefine default values and are therefore optional
\def\hwname#1{\renewcommand\@hwname{#1}}
\def\solutionname#1{\renewcommand\@solutionname{#1}}
\def\problemname#1{\renewcommand\@problemname{#1}}


%%%%%%%%%%%%%%%%%%%
% Page formatting %
%%%%%%%%%%%%%%%%%%%


% make the margins a bit smaller
\RequirePackage[
  paper=a4paper,
  headheight=14pt,
  margin=1in,
  marginparwidth=70pt
]{geometry}

% Set up page headers and footers using the `fancyhdr' package
\RequirePackage{fancyhdr}
\renewcommand\headrulewidth{0pt}
% First page style
\fancypagestyle{firstpage}
{
  \fancyhf{}
  \fancyhead[R]{{\@name}\\{\@term}}
  \fancyfoot[C]{\small\thepage}
}
% Subsequent page style
\fancypagestyle{runningpage}
{
  \fancyhf{}
  \fancyhead[L]{\small\@hwtitle}
  \fancyhead[R]{\small\@name}
  \fancyfoot[C]{\small\thepage}
}
\pagestyle{runningpage}

% Specify how the title is printed
\renewcommand\maketitle
{
  \thispagestyle{plain}
  \begin{center}
    \textsf{\textbf{\Large\@hwtitle}}
  \end{center}
  \textbf{Name:} \@name \ (\@studentid)\hspace{\fill} \textbf{Due:} \@duedate \\
  \textbf{Email:} \href{mailto:\@email}{\texttt{\@email}} \hspace{\fill} \textbf{Course:} \@courseid
}
% The title is printed automatically, no need to type \maketitle manually
\AtBeginDocument{\maketitle}


%%%%%%%%%%%%%%%%%
% Miscellaneous %
%%%%%%%%%%%%%%%%%

\RequirePackage{mathpazo}           % Use the Palatino font
\RequirePackage[utf8]{inputenc}     % Use UTF-8 encoding
\RequirePackage[T1]{fontenc}        % Use Type 1 fonts
\RequirePackage{microtype}          % Microtypography package

% Insert hyperlinks to internal or external links
\RequirePackage[bookmarks=true, hidelinks]{hyperref}

% Add student name and homework title to the PDF document metadata
\AtBeginDocument{
  \hypersetup{
    pdfauthor={\@name},
    pdftitle={\@hwtitle},
  }
}

% Mathematics packages
\RequirePackage{amsmath, amsthm, amssymb}
\RequirePackage{mathtools}
\RequirePackage{physics}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem, parts, solution, and claim environments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[dvipsnames]{xcolor}
\def\@problemColor{white}
\ifHW@boxes
  \def\@problemColor{\HW@color}
\fi

% Problem environment
\RequirePackage{varwidth}
\RequirePackage{tcolorbox}
\tcbuselibrary{theorems}
\tcbuselibrary{skins}

\newtcbtheorem{prob}{\@problemname}{enhanced, colback=\@problemColor!5, colframe=\@problemColor!50!white, coltitle=black,fonttitle=\bfseries\sffamily, colbacktitle=\@problemColor!15!white, attach boxed title to top left={yshift=-2mm,xshift=-5mm}, varwidth boxed title, borderline={0.5mm}{0mm}{\@problemColor!15!white}, borderline={0.5mm}{0mm}{\@problemColor!50!white, dashed}, boxed title style={boxrule=1pt}}{prob}
\newenvironment{problem}[1][]
{
  \def\@arg{#1}
  \ifx\@arg\empty
    \begin{prob}{}{}
  \else
    \begin{prob}{#1}{}
  \fi
  \pdfbookmark{\@problemname\ \arabic{tcb@cnt@prob}}{\arabic{tcb@cnt@prob}}
}
{
  \end{prob}
}

% Problems are numbered 1, 2, 3, ... by default
% If a custom problem number is desired for a particular problem, use the
% following macro before the problem.
\def\problemnumber#1{\setcounter{tcb@cnt@prob}{#1}\addtocounter{tcb@cnt@prob}{-1}}

% Parts environment
% By default, parts are labeled by lowercase letters.
% The parts environment provides options for other labels:
% `a' (default) lowercase letters
% `A' uppercase letters
% `r' lowercase Roman numerals
% `R' uppercase Roman numerals
% `n' numbers
\RequirePackage{enumitem}

% Define parts environment option actions
\@namedef{partlabel@a}{\def\@partlabel{\textup{(\alph*)}}}
\@namedef{partlabel@A}{\def\@partlabel{\textup{(\Alph*)}}}
\@namedef{partlabel@r}{\def\@partlabel{\textup{(\roman*)}}}
\@namedef{partlabel@R}{\def\@partlabel{\textup{(\Roman*)}}}
\@namedef{partlabel@n}{\def\@partlabel{\textup{(\arabic*)}}}

% Actual parts environment
\newenvironment{parts}[1][a]
{
  % Process option (default is `a')
  \@ifundefined{partlabel@#1}
  {
    \@latex@error{Invalid parts environment option: #1}\@ehc
  }
  {
    \@nameuse{partlabel@#1}
  }
  \renewcommand\part\item
  \ % Make the list always starts on a new line
  \enumerate
  [ label=\@partlabel,
  , itemsep=1pt
  , parsep=1pt
  , topsep=0pt
  , partopsep=100pt
  , labelindent=0pt
  , labelwidth=4.5em
  , labelsep=0.5em
  , resume
  ]
}
{
  \endenumerate
}
\def\unresume{\setcounter{enumi}{0}}

% Solution environment
\ifHW@hidesolutions
  % Hide solutions if the `hidesolutions' class option is enabled
  \RequirePackage{comment}
  \excludecomment{solution}
\else
  % This is a modification of the `proof' environment from the amsthm package
  \newenvironment{solution}[1][\@solutionname]
  {
    \par
    \ifHW@qed
      \pushQED{\qed}
    \else
      \renewcommand\qedhere{}
    \fi
    \normalfont \topsep6\p@\@plus6\p@\relax
    \trivlist
    \item[\hskip\labelsep
          \sffamily\bfseries#1\@addpunct{.}]\ignorespaces
  }
  {
    \ifHW@qed
      \popQED
    \fi
    \endtrivlist\@endpefalse
    \ifHW@pages
      \clearpage
    \fi
  }
\fi

% 'claim' environment for better organization of claims made within a problem
% solution.
\def\@defaultclaimname{Claim}
\newenvironment{claim}[1][\@defaultclaimname]{
    \begin{quote}
    \textsf{\textbf{#1\@addpunct{.}}}
}
{
    \end{quote}\noindent
}

% Some common alternative uses of the 'claim' environment
\newcommand{\newclaim}[2]{\newenvironment{#1}{\begin{claim}[#2]}{\end{claim}}}
\newclaim{lemma}{Lemma}
\newclaim{proposition}{Proposition}
\newclaim{theorem}{Theorem}
\newclaim{corollary}{Corollary}
\newclaim{remark}{Remark}

% The 'proof' environment is re-defined to serve as a proof environment for
% claims made within a problem
\let\proof\@undefined
\let\endproof\@undefined
\newclaim{proof}{Proof}

% Remove indentation after 'claim' and all the related environments
\RequirePackage{noindentafter}
\NoIndentAfterEnv{claim}
\NoIndentAfterEnv{lemma}
\NoIndentAfterEnv{proposition}
\NoIndentAfterEnv{theorem}
\NoIndentAfterEnv{corollary}
\NoIndentAfterEnv{remark}
\NoIndentAfterEnv{proof}
