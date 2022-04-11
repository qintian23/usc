%NAME: summary.cls

% 南华大学文献综述文档类
% Author: Zhu Liucheng
% E-mail: 2576950110@qq.com
% Date : 2022/4/11

% -------------------------------------------------- --------------%
% ->> 标识
% -------------------------------------------------- --------------%
\NeedsTeXFormat{LaTeX2e} % 告诉编译器该包适用于LaTeX2e版本
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{ucasthesis}{TeXLive/MikTex >= 2017 is required ...}{}%
    
}
\ProvidesClass{summary}[2022/04/11 v1.0 LaTeX document class] %
%---------------------------------------------------------------------------%
%->> 选项声明
%---------------------------------------------------------------------------%
%-
%-> 布局
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexbook}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexbook}%
}
\newif\ifusc@print \usc@printfalse
\DeclareOption{print}{
    \PassOptionsToClass{twoside}{ctexbook}%
    \usc@printtrue %
}
%-
%-> 语言
%-
\newif\ifusc@plain \usc@plainfalse
\DeclareOption {scheme=plain}{ %启用普通书写风格
    \PassOptionsToClass {scheme=plain}{ctexbook} %
    \usc@plaintrue %
}
%-
%-> 草稿版本信息
%-
\newif\ifusc@versioninfo \usc@versioninfofalse
\DeclareOption{draftversion}{%
    \usc@versioninfotrue%
}
% -
% -> 处理未实现的选项
% -
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
% -
% -> 终止所有选项处理
% -
\ProcessOptions\relax%
% -------------------------------------------------- --------------%
% ->> 加载类信息
% -------------------------------------------------- --------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}%
\@ifclasslater{ctexbook}{2017/01/01}{}{%
    \ClassError{summary}{ctex >= 2017/01/01 is required ...}{}%
}
% -------------------------------------------------- --------------%
% ->> 需要的包
% -------------------------------------------------- --------------%
\RequirePackage{ifxetex}% LaTeX 引擎检测
\RequirePackage{etoolbox}% 编程工具箱
\newcommand{\uscifstreq}{\expandafter\ifstrequal\expandafter} % 扩展控制
\newcommand{\uscifstrbk}{\expandafter\ifblank\expandafter} % 扩展控制
\RequirePackage{expl3}% LaTeX3 编程环境
\ExplSyntaxOn
\newcommand{\usclntotab}[2][1pt]{% 将行转换为表格行
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% 显示逗号​​列表的内容
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
% -------------------------------------------------- --------------%
% ->> 加载类配置
% -------------------------------------------------- --------------%
\AtEndOfPackage{% 打包后加载的类 cfg 以使前导命令生效
    \makeatletter
    \InputIfFileExists{style/uscthesis.cfg}{}{}
    \makeatother
}
% -------------------------------------------------- --------------%
% ->> 页面布局
% -------------------------------------------------- --------------%
% - 使用 \topmargin insead of \voffset 垂直移动整个文本
% - 使用 \hoffset 的 \<odd|even>sidemargin insead 水平移动文本
% - 第一部分 - 水平宽度
% - 左侧宽度 + 文本宽度 + 右侧宽度 = 纸张宽度
% - 装订边宽度 + 文本宽度 + 非装订边宽度 = 纸张宽度
% - [奇数，偶数] 页的装订边宽度 = [左，右] 边宽
% - [odd, even] 页面的左侧宽度 = 1.0in (fixed) + hoffset + [odd, even]sidemargin
% - 假设 A4 纸 (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% 首先设置所需的文本宽度
\setlength{\hoffset}{0mm}% 设置水平偏移
\ifusc@print% 如果启用打印布局
    \setlength{\oddsidemargin}{12.6mm}% 装订边距
    \setlength{\evensidemargin}{0mm}% 确保打印的装订边宽度一致
\else
    \setlength{\oddsidemargin}{6.3mm}% 左边距
    \setlength{\evensidemargin}{6.3mm}% 确保 EThesis 的左侧宽度一致
\fi
\setlength{\marginparwidth}{35pt}% 边注宽度
\setlength{\marginparsep}{10pt}% 正文和边注之间的空间宽度
% - 第二部分 - 垂直高度
% - 顶部高度 + 文本高度 + 底部高度 = 纸张高度
% - 顶部高度 = 1.0in（固定）+ voffset + topmargin + headheight + headep
\setlength{\textheight}{246.2mm}% 首先设置所需的文字高度
\setlength{\voffset}{0mm}% 设置垂直偏移
\setlength{\topmargin}{-10.4mm}% 标题上方的垂直边距
\setlength{\headheight}{12pt}% 标题高度
\setlength{\headsep}{17.5pt} % 标题和正文之间的垂直边距
\setlength{\footskip}{10.4mm}% 页脚和正文之间的垂直边距
% - 指定段落之间的空间量
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
% - 行距
\linespread{1.6}% 行距设置
\raggedbottom% 防止在奇怪的地方添加垂直空白
% - 默认页面样式是底部的页码，没有页眉和页脚
\pagestyle{plain}
% -------------------------------------------------- --------------%
% ->> 样式控制命令
% -------------------------------------------------- --------------%
% - 重新定义 cleardoublepage 以具有页面样式参数
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
% - 下划线
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% 统一名称
\newcommand{\ulenhance}[2][1pt]{% 增强下划线
    \def\ULthickness{#1}% 设置厚度
    \setlength{\ULdepth}{0.5em}% 设置深度
    \expandafter\ulunify\expandafter{#2}% 换行修复
}
\newcommand{\ulhshift}{-4em} % 下划线水平移位
\newcommand{\ulextend}[2][350pt]{% 延长下划线长度
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
% -------------------------------------------------- --------------%
% ->> 标题页
% -------------------------------------------------- --------------%
% -
% -> 中文项目命令
% -
\def\usc@value@ch@confidential {}
\newcommand { \confidential }[1]{ \def\usc@value@ch@confidential {#1}}
\def\usc@value@ch@orderid {}
\newcommand { \orderid }[1]{ \def\usc@value@ch@orderid {#1}}
\def\usc@value@ch@classid {}
\newcommand { \classid }[1]{ \def\usc@value@ch@classid {#1}}
\def\usc@value@ch@udc {}
\newcommand { \udc }[1]{ \def\usc@value@ch@udc {#1}}
\def\usc@value@ch@schoollogo {}
\newcommand { \schoollogo }[2][]{ \def\usc@value@ch@schoollogo { \uscifstrbk {#1}{ \zihao {-2} \bfseries\sffamily #2}{ \includegraphics [#1] {#2}}}}
\def\usc@value@ch@title {}
\def\usc@value@ch@titlemark {}
\renewcommand { \title }[2][ \usc@value@ch@title ]{ %
    \def\usc@value@ch@title {#2}
    % \def\usc@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\usc@value@ch@titlemark {#1}}
\def\usc@value@ch@author {}
\renewcommand { \author }[1]{ \def\usc@value@ch@author {#1}}
\def\usc@value@ch@advisor {}
\newcommand { \advisor }[1]{ \long\def\usc@value@ch@advisor {#1}}
\def\usc@value@ch@advisors {}
\newcommand { \advisors }[1]{ \long\def\usc@value@ch@advisors {#1}}
\def\usc@value@ch@degree {}
\newcommand { \degree }[1]{ \def\usc@value@ch@degree {#1}}
\def\usc@value@ch@degreetype {}
\newcommand { \degreetype }[1]{ \def\usc@value@ch@degreetype {#1}}
\def\usc@value@ch@subject {}
\newcommand { \subject }[1]{ \def\usc@value@ch@subject {#1}}
\def\usc@value@ch@major {}
\newcommand { \major }[1]{ \def\usc@value@ch@major {#1}}
\def\usc@value@ch@institute {}
\newcommand { \institute }[1]{ \long\def\usc@value@ch@institute {#1}}
\def\usc@value@ch@school {}
\newcommand { \school }[1]{ \def\usc@value@ch@school {#1}}
\def\usc@value@ch@orginization {}
\newcommand { \orginization }[1]{ \def\usc@value@ch@orginization {#1}}
\def\usc@value@ch@completedate {}
\newcommand { \completedate }[1]{ \def\usc@value@ch@completedate {#1}}
\def\usc@value@ch@submitdate {}
\newcommand { \submitdate }[1]{ \def\usc@value@ch@submitdate {#1}}
\def\usc@value@ch@studydate来自{}
\newcommand { \studydatefrom }[1]{ \def\usc@value@ch@studydatefrom {#1}}
\def\usc@value@ch@studydateto {}
\newcommand { \studydateto }[1]{ \def\usc@value@ch@studydateto {#1}}
\def\usc@value@ch@date {}
\renewcommand { \date }[1]{ \def\usc@value@ch@date {#1}}
% -
% -> 英文项目命令
% -
\def\usc@value@en@title{}
\def\usc@value@en@titlemark{}
\newcommand{\TITLE}[2][\usc@value@en@title]{%
    \def\usc@value@en@title{#2}
    %\def\usc@value@en@titlemark{\MakeUppercase{#1}}}
    \def\usc@value@en@titlemark{#1}}
\def\usc@value@en@author{}
\newcommand{\AUTHOR}[1]{\def\usc@value@en@author{#1}}
\def\usc@value@en@advisor{}
\newcommand{\ADVISOR}[1]{\def\usc@value@en@advisor{#1}}
\def\usc@value@en@degree{}
\newcommand{\DEGREE}[1]{\edef\usc@value@en@degree{\zap@space#1 \@empty}}% expand and remove space
\def\usc@value@en@degreetype{}
\newcommand{\DEGREETYPE}[1]{\def\usc@value@en@degreetype{#1}}
\def\usc@value@en@thesistype{}
\newcommand{\THESISTYPE}[1]{\def\usc@value@en@thesistype{#1}}
\def\usc@value@en@major{}
\newcommand{\MAJOR}[1]{\def\usc@value@en@major{#1}}
\def\usc@value@en@institute{}
\newcommand{\INSTITUTE}[1]{\def\usc@value@en@institute{#1}}
\def\usc@value@en@school{}
\newcommand{\SCHOOL}[1]{\def\usc@value@en@school{#1}}
\def\usc@value@en@date{}
\newcommand{\DATE}[1]{\def\usc@value@en@date{#1}}
% -
% -> 检测和调整项目
% -
\AtEndPreamble{%
    \uscifstreq{\usc@value@en@degree}{Bachelor}{% 学士
        \def\usc@label@ch@thesis{\usc@label@ch@thesis@bac}%
        \def\usc@label@ch@author{\usc@label@ch@author@bac}%
        \def\usc@label@ch@major{\usc@label@ch@major@bac}%
        \def\usc@label@ch@institute{\usc@label@ch@institute@bac}%
        \def\usc@value@en@thesistype{\usc@value@en@thesistype@bac}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \uscifstreq{\usc@value@en@degree}{Master}{% 硕士
        \def\usc@label@ch@thesis{\usc@label@ch@thesis@mas}%
        \def\usc@label@ch@author{\usc@label@ch@author@mas}%
        \def\usc@label@ch@major{\usc@label@ch@major@mas}%
        \def\usc@label@ch@institute{\usc@label@ch@institute@mas}%
        \def\usc@value@en@thesistype{\usc@value@en@thesistype@mas}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \uscifstreq{\usc@value@en@degree}{Doctor}{% 博士
        \def\usc@label@ch@thesis{\usc@label@ch@thesis@doc}%
        \def\usc@label@ch@author{\usc@label@ch@author@doc}%
        \def\usc@label@ch@major{\usc@label@ch@major@doc}%
        \def\usc@label@ch@institute{\usc@label@ch@institute@doc}%
        \def\usc@value@en@thesistype{\usc@value@en@thesistype@doc}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \uscifstreq{\usc@value@en@degree}{Postdoctor}{% 博士后
        \def\usc@label@ch@thesis{\usc@label@ch@thesis@pdc}%
        \def\usc@label@ch@author{\usc@label@ch@author@pdc}%
        \def\usc@label@ch@major{\usc@label@ch@major@pdc}%
        \def\usc@label@ch@institute{\usc@label@ch@institute@pdc}%
        \def\usc@value@en@thesistype{\usc@value@en@thesistype@pdc}%
        \def\maketitle{\maketitle@pdc}
        \def\MAKETITLE{\MAKETITLE@pdc}
    }{%
        \ClassWarning{ucasthesis}{Invalid value of '\string\DEGREE', please check the spelling}% 警告：输入无效，请检查拼写
    }}}}%
}
% -
% -> 定义中文风格
% -
\newcommand{\maketitle@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \hfill{} \uscifstrbk{\usc@value@ch@confidential}{}{\usc@label@ch@confidential \ulenhance{\ulextend[50pt]{\hspace*{-\ulhshift}\zihao{5}\usc@value@ch@confidential}}}

        \vspace*{\stretch{4}}

        {\usc@value@ch@schoollogo}

        \vspace*{\stretch{2}}

        {\zihao{1}\bfseries\sffamily {\usc@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3}\bfseries\sffamily \ulenhance[1.5pt]{\usc@value@ch@title}}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{lc}
            \usc@label@ch@author & \ulenhance[1.2pt]{\ulextend{\usc@value@ch@author}}\\
            \usc@label@ch@advisor & \usclntotab[1.2pt]{\usc@value@ch@advisor}\\
            \usc@label@ch@degree & \ulenhance[1.2pt]{\ulextend{\usc@value@ch@degreetype\usc@value@ch@degree}}\\
            \usc@label@ch@major & \ulenhance[1.2pt]{\ulextend{\usc@value@ch@major}}\\
            \usc@label@ch@institute & \usclntotab[1.2pt]{\usc@value@ch@institute}\\
        \end{tabular}

        \vspace*{\stretch{4}}

        {\usc@value@ch@date}

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifucas@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifucas@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifucas@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
\newcommand{\maketitle@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}

        \vspace*{30pt}

        \linespread{2.0}
        \zihao{4}

        \makebox[3.0em][s]{\usc@label@ch@classid} \ulenhance{\ulextend[6em]{\zihao{5}\usc@value@ch@classid}} \hfill{} \usc@label@ch@confidential \ulenhance{\ulextend[6em]{\zihao{5}\usc@value@ch@confidential}}

        \makebox[3.0em][s]{\usc@label@ch@udc} \ulenhance{\ulextend[6em]{\zihao{5}\usc@value@ch@udc}} \hfill{} \usc@label@ch@orderid \ulenhance{\ulextend[6em]{\zihao{5}\usc@value@ch@orderid}}

        \vspace*{\stretch{6}}

        {\ziju{1.5}\usc@value@ch@schoollogo}

        \vspace*{\stretch{1}}

        {\zihao{-2}\bfseries\sffamily{\ziju{0.5}\usc@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3} \ulenhance[1.5pt]{\usc@value@ch@title}}

        \vspace*{\stretch{2.5}}

        \usc@value@ch@author

        \vspace*{\stretch{2.5}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}c}
            \usc@label@ch@completedate & \ulenhance{\ulextend[200pt]{\usc@value@ch@completedate}}\\
            \usc@label@ch@submitdate & \ulenhance{\ulextend[200pt]{\usc@value@ch@submitdate}}\\
        \end{tabular}

        \vspace*{\stretch{2}}

        \usc@value@ch@institute

        \usc@value@ch@date

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
    \ifucas@print%
        \hypersetup{% 设置超链接
            hidelinks,% 移除链接颜色和边框
        }
    \fi
}
% -
% -> 定义英式风格
% -
\newcommand{\MAKETITLE@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \vspace*{50pt}

        {\zihao{-3}\bfseries \ulenhance[1.5pt]{\usc@value@en@title}}

        \vspace*{\stretch{3}}

        {\usc@label@en@statement}

        {By}

        {\usc@value@en@author}

        {\usc@value@en@advisor}

        \vspace*{\stretch{3}}

        {\usc@value@en@institute}

        \vspace*{\stretch{1}}

        {\usc@value@en@date}

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
\newcommand{\MAKETITLE@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{2.0}
        \zihao{4}

        \vspace*{50pt}

        {\zihao{3} \usc@value@ch@title}

        \vspace*{\stretch{3}}

        {\zihao{-3} \usc@value@en@title}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}l}
            \makebox[11em][s]{\usc@label@ch@author} & \usc@value@ch@author\\
            \makebox[11em][s]{\usc@label@ch@subject} & \usc@value@ch@subject\\
            \makebox[11em][s]{\usc@label@ch@major} & \usc@value@ch@major\\
        \end{tabular}

        \vspace*{\stretch{3}}

        \usc@label@ch@studydatefrom \quad \usc@value@ch@studydatefrom

        \usc@label@ch@studydateto \quad \usc@value@ch@studydateto

        \vspace*{\stretch{3}}

        \usc@value@ch@orginization

        \usc@value@ch@date

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
% -------------------------------------------------- --------------%
% ->> 作者声明
% -------------------------------------------------- --------------%
\newcommand{\makedeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.6}
        \zihao{-4}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \usc@label@ch@declare@creativity}
        \end{center}

        {\usc@value@ch@declare@creativity}

        \vspace*{3ex}

        {\hfill{} {\usc@label@ch@declare@author \hspace*{14em}}}

        {\hfill{} {\usc@label@ch@declare@date \hspace*{14em}}}

        \vspace*{6ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \usc@label@ch@declare@rights}
        \end{center}

        {\usc@value@ch@declare@rights}

        {\usc@value@ch@declare@rule}

        \vspace*{3ex}

        {\hfill{} {\usc@label@ch@declare@author \hspace*{10em} \usc@label@ch@declare@advisor \hspace*{9em}}}

        {\hfill{} {\usc@label@ch@declare@date \hspace*{10em} \usc@label@ch@declare@date \hspace*{9em}}}

        \vspace*{3ex}
    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
% -------------------------------------------------- --------------%
% ->> 新环境
% -------------------------------------------------- --------------%
% - 定义中文关键字
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \usc@label@ch@keywords} #1}
%- define engish keywords
\newcommand{\KEYWORDS}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \usc@label@en@keywords} #1}

% -------------------------------------------------- --------------%
% ->> 结构元素
% -------------------------------------------------- --------------%
\ifucas@plain%
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

% -------------------------------------------------- --------------%
% ->> 结构布局
% -------------------------------------------------- --------------%
% - 章节
\ctexset {
    chapter = {
        format = \linespread{1.0}\zihao{4}\bfseries\sffamily\centering,
        nameformat = {},
        titleformat = {},
        number = \arabic{chapter},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {7pt},
        afterskip = {18pt},
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},
        afterskip = {6pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- appendix
\ctexset {
    appendix = {
        %numbering = true|false,
        %number = \rmfamily\Alph{chapter},
    }
}
% -------------------------------------------------- --------------%
% ->> 配置目录
% -------------------------------------------------- --------------%
% - 通过定义 \l@chapter, \l@section, ... 来指定目录
% - 大多数命令随后用 \@dottedtocline 定义：
% - \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
% - ⟨level⟩ 只有当 ⟨level⟩ <= tocdepth 计数器的值时才会生成条目
% - 注意，\chapter 是 0 级，\section 是 1 级，等等
% - ⟨indent⟩ 从内容行开头的左外边距缩进
% - ⟨numwidth⟩ 节号所在框的宽度
% - <title> 标题
% - <page> 页码

% - toc 中的间距和长度参数

\def\@dotsep{1.5mu}% 以 mu 为单位的点之间的百分比分隔
\def\@pnumwidth{2em}% 放置页码的框的宽度
\def\@tocrmarg{2em}% 多行条目的右边距，\@tocrmarg ≥ \@pnumwidth
\def\@chaptervspace{1ex}% 章节标题之间的垂直空间

% - 从 classes.dtx 和 latex.ltx 重新定义 dottedtocline
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
% - 从 book.cls 重新定义 l@part 以添加虚线 toc
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
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
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
% - 从 book.cls 重新定义 l@chapter 以添加虚线 toc
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
% - 为另外的需求重新定义缩进
\renewcommand*\l@section{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{3.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4em}{4.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5em}{5.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{1em}{1.8em}}
%---------------------------------------------------------------------------%
\endinput