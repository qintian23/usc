%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{summary}{TeXLive/MikTex >= 2017 is required ...}{}%
}
\ProvidesClass{summary}[2014/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexart}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexart}%
}
\newif\ifusc@print \usc@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexart}%
    \usc@printtrue%
}
%-
%-> Language
%-
\newif\ifusc@plain \usc@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexart}%
    \usc@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifusc@versioninfo \usc@versioninfofalse
\DeclareOption{draftversion}{%
    \usc@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexart}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexart}%
\@ifclasslater{ctexart}{2017/01/01}{}{%
    \ClassError{uscthesis}{ctex >= 2017/01/01 is required ...}{}%
}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{expl3}% LaTeX3 programming environment
\ExplSyntaxOn
\newcommand{\usclntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/summary.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifusc@print% if print layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{-10.4mm}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.3em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-3em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%- special cell
%- \specialcell[<align2>]{align1}{text1\\text2};
%- <align1>: t,c,b; <align2> l,c,r; @{} suppress spaces before and after text 
\newcommand{\specialcell}[3][c]{%
    \begin{tabular}[#2]{@{}#1@{}}#3\end{tabular}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\usc@value@ch@schoollogo{}
\newcommand{\schoollogo}[2]{\def\usc@value@ch@schoollogo{\includegraphics[#1]{#2}}}
\def\usc@value@ch@title{}
\def\usc@value@ch@titlemark{}
\renewcommand{\title}[2][\usc@value@ch@title]{%
  \def\usc@value@ch@title{#2}
  %\def\usc@value@ch@titlemark{\MakeUppercase{#1}}}
  \def\usc@value@ch@titlemark{#1}}
\def\usc@value@ch@author{}
\renewcommand{\author}[1]{\def\usc@value@ch@author{#1}}
\def\usc@value@ch@authorid{}
\newcommand{\authorid}[1]{\def\usc@value@ch@authorid{#1}}
\def\usc@value@ch@advisor{}
\newcommand{\advisor}[1]{\def\usc@value@ch@advisor{#1}}
\def\usc@value@ch@advisortitle{}
\newcommand{\advisortitle}[1]{\def\usc@value@ch@advisortitle{#1}}
\def\usc@value@ch@degree{}
\newcommand{\degree}[1]{\def\usc@value@ch@degree{#1}}
\def\usc@value@ch@degreetype{}
\newcommand{\degreetype}[1]{\def\usc@value@ch@degreetype{#1}}
\def\usc@value@ch@major{}
\newcommand{\major}[1]{\def\usc@value@ch@major{#1}}
\def\usc@value@ch@field{}
\newcommand{\field}[1]{\def\usc@value@ch@field{#1}}
\def\usc@value@ch@institute{}
\newcommand{\institute}[1]{\def\usc@value@ch@institute{#1}}
\def\usc@value@ch@date{}
\newcommand{\chinesedate}[1]{\def\usc@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\usc@value@en@titlemark{\usc@value@ch@titlemark}
\def\usc@value@en@author{\usc@value@ch@author}
%-
%-> Redefine Chinese style
%-
\renewcommand{\maketitle}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.3}
        \zihao{-3}\bfseries
        \vspace*{10pt}

        {\usc@value@ch@schoollogo}

        \vspace*{80pt}

        {\zihao{1}\bfseries\sffamily \usc@label@ch@thesis} % 标题

        \vspace*{135pt}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.2}
        \begin{tabular}{lc}
            %\usc@label@ch@title        & \ulenhance{\ulextend{\shortstack{\usc@value@ch@title}}}\\
            %\usc@label@ch@title        & \ulenhance{\ulextend{\specialcell[c]{b}{\usc@value@ch@title}}}\\
            \usc@label@ch@title         & \usclntotab{\usc@value@ch@title}\\ % 题目
            \usc@label@ch@institute     & \usclntotab{\usc@value@ch@institute}\\ % 学院名称
            \usc@label@ch@advisor       & \usclntotab{\usc@value@ch@advisor} \\ % 指导教师
            \usc@label@ch@advisortitle  & \usclntotab{\usc@value@ch@advisortitle}\\ % 职称
            \usc@label@ch@major         & \usclntotab{\usc@value@ch@major}\\ % 专业班级
            \usc@label@ch@authorid      & \usclntotab{\usc@value@ch@authorid}\\ % 学号
            \usc@label@ch@author        & \usclntotab{\usc@value@ch@author}\\ % 学生姓名
            % \usc@label@ch@degree      & \ulenhance{\ulextend{\usc@value@ch@degreetype\usc@value@ch@degree}}\\
            % \usc@label@ch@field       & \ulenhance{\ulextend{\usc@value@ch@field}}\\
            % \usc@label@ch@date        & \ulenhance{\ulextend{\usc@value@ch@date}}
      \end{tabular}

      \vspace*{50pt}

      {\usc@label@ch@mark}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifusc@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifusc@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifusc@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%---------------------------------------------------------------------------%
%->> 新环境
%---------------------------------------------------------------------------%
%- 定义中文关键字
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \usc@label@ch@keywords} #1}
%- 定义英文关键字
\newcommand{\KEYWORDS}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \usc@label@en@keywords} #1}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifusc@plain%
    \def\contentsname{\usc@label@en@tocname}
    \def\listfigurename{\usc@label@en@lsfigname}
    \def\listtablename{\usc@label@en@lstabname}
    \def\bibname{\usc@label@en@bibname}
    \def\refname{\usc@label@en@bibname}
    \def\algname{\usc@label@en@algname}
    \def\bibetal{\usc@label@en@bibetal}
    \def\biband{\usc@label@en@biband}
    \def\axiomname{\usc@label@en@axiomname}
    \def\theoremname{\usc@label@en@theoremname}
    \def\lemmaname{\usc@label@en@lemmaname}
    \def\corollaryname{\usc@label@en@corollaryname}
    \def\assertionname{\usc@label@en@assertionname}
    \def\propositionname{\usc@label@en@propositionname}
    \def\conjecturename{\usc@label@en@conjecturename}
    \def\definitionname{\usc@label@en@definitionname}
    \def\examplename{\usc@label@en@examplename}
    \def\remarkname{\usc@label@en@remarkname}
    \def\proofname{\usc@label@en@proofname}
    \def\@title{\usc@value@en@titlemark}
    \def\@author{\usc@value@en@author}
\else
    \def\contentsname{\usc@label@ch@tocname}
    \def\listfigurename{\usc@label@ch@lsfigname}
    \def\listtablename{\usc@label@ch@lstabname}
    \def\algname{\usc@label@ch@algname}
    \def\bibname{\usc@label@ch@bibname}
    \def\refname{\usc@label@ch@bibname}
    \def\bibetal{\usc@label@ch@bibetal}
    \def\biband{\usc@label@ch@biband}
    \def\axiomname{\usc@label@ch@axiomname}
    \def\theoremname{\usc@label@ch@theoremname}
    \def\lemmaname{\usc@label@ch@lemmaname}
    \def\corollaryname{\usc@label@ch@corollaryname}
    \def\assertionname{\usc@label@ch@assertionname}
    \def\propositionname{\usc@label@ch@propositionname}
    \def\conjecturename{\usc@label@ch@conjecturename}
    \def\definitionname{\usc@label@ch@definitionname}
    \def\examplename{\usc@label@ch@examplename}
    \def\remarkname{\usc@label@ch@remarkname}
    \def\proofname{\usc@label@ch@proofname}
    \def\@title{\usc@value@ch@titlemark}
    \def\@author{\usc@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure elements configuration
%---------------------------------------------------------------------------%
%- section
\ctexset {
    section = {
        format = \centering \zihao{3}\sffamily,
        % number = {\chinese{section}},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},
        afterskip = {6pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \zihao{-3}\sffamily, % 二级标题，粗黑体小三号，编号为1.1
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \sffamily,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@sectionvspace{1ex}% vertical space between section titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from article.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty\@secpenalty
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \if@compatibility
                \global\@nobreaktrue
                \everypar{\global\@nobreakfalse\everypar{}}%
            \fi
        \endgroup
    \fi
}
%- redefine l@section from article.cls to add dotted toc line
\renewcommand*\l@section[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\z@
        \addpenalty\@secpenalty
        \addvspace{\@sectionvspace \@plus\p@}%
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{3}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
        \endgroup
    \fi
}
%- redefine indentation for others
%\renewcommand*\l@section{\@dottedtocline{1}{0em}{1em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{1em}{1.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{2em}{2.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{3em}{3.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{4em}{4.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{0em}{0.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{0em}{0.8em}}
%---------------------------------------------------------------------------%
\endinput

