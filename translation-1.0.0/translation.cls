%NAME: translation.cls

% 外文翻译文档类
% Author: Zhu Liucheng
% E-mail: 2576950110@qq.com
% Date : 2022/3/8

%------------------------------------------------------------------------------------
% 初始化
\NeedsTeXFormat{LaTeX2e} % 告诉编译器该包适用于LaTeX2e版本
\ProvidesClass{translation}[2022/03/08 My custom LaTeX class]  % 给编译器关于软件包的信息。
% 第一个参数应该与class文件的文件名一致。
% 第二个参数是可选的，它提供了一个class文件的描述，这个会出现在日志和其他地方。
% 该描述必须以一个日期开头，其格式与上面的格式完全一致，而且应该是项目最后一次被修改的日期。

\LoadClass{article} % 在article基础上修改

% \RequirePackage{xpatch}

% \xpatchcmd{\maketitle}
%   {\thispagestyle{plain}} % 查找内容
%   {}                      % 替换内容
%   {}                      % 若成功，执行的代码
%   {\ddt}                  % 若失败，执行的代码。此处的 \ddt 是一个未定义命令，目的是通过报错来提醒失败
% \pagestyle{empty}


% \RequirePackage{titlesec}

% \titleformat{\section}%定义标题类型和标题样式，字体
%   {\fontsize{15.75pt}\textbf\heiti\centering}%定义标题格式:字号（大小），加粗，斜体
%   {}%定义标题的标签，即标题的标号等
%   {0em}%定义标题和标号之间的水平距离
%   {} %定义标题前的内容
%   [] %定义标题后的内容
 
% \titleformat{\subsection}%定义标题类型和标题样式，字体
%   {\fontsize{14pt}\textbf\heiti}%定义标题格式:字号（大小），加粗，斜体
%   {\bfseries\arabic{section}.\bfseries\arabic{subsection}}%定义标题的标签，即标题的标号等
%   {1em}%定义标题和标号之间的水平距离
%   {} %定义标题前的内容
%   [] %定义标题后的内容
 
% \titleformat{\subsubsection}%定义标题类型和标题样式，字体
%   {\fontsize{12pt}\textbf\heiti}%定义标题格式:字号（大小），加粗，斜体
%   {\bfseries\arabic{section}.\bfseries\arabic{subsection}.\bfseries\arabic{subsubsection}}%定义标题的标签，即标题的标号等
%   {1em}%定义标题和标号之间的水平距离
%   {} %定义标题前的内容
%   [] %定义标题后的内容


%---------------------------------------------------------------------
% laTeX内部命令修改标题
% \@startsection {NAME}{LEVEL}{INDENT}{BEFORESKIP}{AFTERSKIP}{STYLE}
% \makeatletter
%   \renewcommand\section{
%       \@startsection{section}{1}{\z@}% 定义节标题的命令层次。定义节标题到版心左边的距离。此度量若是负数则标题进入边空
%       {-3.5ex \@plus -1ex \@minus -.2ex} % 是一个长度，其绝对值表示标题到上文之间的距离。
%       {2.3ex \@plus.2ex} % 是一个长度，其绝对值表示独立显示的标题到下文之间的垂直间距或者是段内显示的标题到下文之间的距离。
%       {\centering\normalfont\normalsize\CJKfamily{heiti}}
%     }
% \makeatother
%-----------------------------------------------------------------
% \RequirePackage[raggedright]{titlesec}%raggedleft (居左，默认), raggedright (居右)。
% \titleformat{\section}{\centering\Huge\bfseries}{第\,\thechapter\,章}{1em}{}

% \titleformat{command}[shape]{format}{label}{sep}{before}[after]
% format rm sf tt md bf up it sl sc ||||big medium small tiny |||raggedleft center raggedright
% command 是要重新定义的各种标题命令,比如 \part，\chapter，\section，\subsection，\subsubsection，\paragraph，\subparagraph等
% shape 是用来设定段落形状的,可选的参数有 hang 、 block 、 display 等,详见 titlesec 文档,
% label 用于定义定义标题的标签,就是标题内容前面的标号；
% sep 定义标题的标签与标题内容之间的间隔距离。
% before 用于在标题内容前再加些内容；
% after 用于在标题内容后再加些内容。