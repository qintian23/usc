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

%-------------------------------------------------------------------------------------
% 导入宏包
\RequirePackage{titlesec}


%-------------------------------------------------------------------------------------
% 标题格式设置
\titleformat{\section}%定义标题类型和标题样式，字体
  {\fontsize{16dp}\textbf\heiti\centering}%定义标题格式:字号（大小），加粗，斜体
  {}%定义标题的标签，即标题的标号等
  {0em}%定义标题和标号之间的水平距离
  {} %定义标题前的内容
  [] %定义标题后的内容
 
\titleformat{\subsection}%定义标题类型和标题样式，字体
  {\fontsize{14pt}\textbf\heiti}%定义标题格式:字号（大小），加粗，斜体
  {\bfseries\arabic{section}.\bfseries\arabic{subsection}}%定义标题的标签，即标题的标号等
  {1em}%定义标题和标号之间的水平距离
  {} %定义标题前的内容
  [] %定义标题后的内容
 
\titleformat{\subsubsection}%定义标题类型和标题样式，字体
  {\fontsize{12pt}\textbf\heiti}%定义标题格式:字号（大小），加粗，斜体
  {\bfseries\arabic{section}.\bfseries\arabic{subsection}.\bfseries\arabic{subsubsection}}%定义标题的标签，即标题的标号等
  {1em}%定义标题和标号之间的水平距离
  {} %定义标题前的内容
  [] %定义标题后的内容

%---------------------------------------------------------------------
% laTeX内部命令修改标题
% \makeatletter
%   \renewcommand\section{
%       \@startsection{section}{1}{\z@}%
%       {-3.5ex \@plus -1ex \@minus -.2ex}%
%       {2.3ex \@plus.2ex}%
%       {\normalfont\normalsize\CJKfamily{hei}}}
% \makeatother