% Copyright (C) 2012,2014  Nicola Fontana <ntd at entidi.it>
%
% This program can be redistributed and/or modified under
% the terms of the LaTeX Project Public License, either
% version 1.3 of this license or (at your option) any later
% version. The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all LaTeX distributions
% version 2005/12/01 or later.
%
% Based on the original idea by Alessandro Plasmati found at
% http://www.latextemplates.com/template/two-column-one-page-cv
%
% The most relevant changes from his work are:
%
% * this is a class, not a template document;
% * tccv is based on scrartcl (from Koma-script), not on article;
% * the fonts are selected from the PSNFSS collection, so no
%   custom font installation should be required;
% * heavily based the implementation on custom environments and
%   macros, so the document is much easier to read (and customize);
% * it is plain LaTeX/Koma-script, so the CV can be compiled
%   with the usual tools, latex and pdflatex included.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tccv}
              [2014/24/06 v1.2
 Two Column Curriculum Vitae]

\LoadClassWithOptions{scrartcl}

\setcounter{secnumdepth}{-1}
\RequirePackage[hmargin=1.25cm,vmargin=1.25cm,twocolumn,columnsep=1.25cm]{geometry}
\RequirePackage{bookman,etoolbox,hyperref,needspace,pifont,tabularx,xcolor}

\usepackage{titlesec}
\titlespacing*{\section} {0pt}{8ex plus 1ex minus .2ex}{0.5ex plus .2ex}
\titlespacing*{\subsection} {0pt}{2ex plus .5ex minus .2ex}{1ex plus .2ex}


% Capitalize words of at least a minimum length (default to 3 chars).
% The text is capitalized before being expanded.
%
% This macro uses Lua to do the job but fails gracefully (that is,
% return the text as is) if \directlua is not available.
%
% |[
% \ucwords[optional: miminum length]{text}
% ]|
\newcommand\ucwords[2][3]{%
    % Fails gracefully if not in LuaLaTeX
    \providecommand\directlua[1]{#2}%
    \directlua{%
	local minlen = tonumber("#1")
	local src = "\luaescapestring{\unexpanded{#2}}"
	local dst = {}
	% Put a % inside \directlua is tricky as hell. Use char(37)
	% instead: still no plans for supporting non-ASCII platforms.
	for w in src:gmatch(string.char(37) .. "S+") do
	    if w:len() >= minlen then
		table.insert(dst, w:sub(1,1):upper() .. w:sub(2))
	    else
		table.insert(dst, w)
	    end
	end
	tex.print(dst)}}

\pagestyle{empty}
\setlength\parindent{0pt}
\color[HTML]{303030} % Default foreground color
\definecolor{link}{HTML}{02304D} % Hyperlinks
\hypersetup{colorlinks,breaklinks,urlcolor=link,linkcolor=link}
\setkomafont{disposition}{\color[HTML]{801010}}
\setkomafont{section}{\scshape\Large\mdseries}

% In tccv \part must contain the subject of the curriculum vitae.
% The command will start a new page and output in onecolumn the
% subject (first and last name) with the hardcoded text
% "Curriculum vitae" under it.
\renewcommand\part[1]{%
    \twocolumn[%
    \begin{center}
	\vskip-\lastskip%
	{\usekomafont{part} #1} \medskip\\
	{\fontfamily{pzc}\selectfont\Huge Curriculum vitae}
	\bigskip
    \end{center}]}

% Overrides the \section command to capitalize every
% word for cosmetic purposes and draws a rule under it.
\makeatletter
\let\old@section\section
\renewcommand\section[2][]{%
    \old@section[#1]{\ucwords{#2}}%
    \newdimen\raising%
    \raising=\dimexpr-0.7\baselineskip\relax%
	\vskip\raising\textcolor[HTML]{999999}{\hrule height 0.5pt}\vskip-\raising}
\makeatother

% Renders a personal data box:
%
% |[
% \personal[optional: web site without scheme (no http:// prefix)]
%          {address}{phone number}{email}
% ]|
\newcommand\personal[4][]{%
    \newcommand\SYMBOL[1]{\raisebox{-2pt}{\Large\ding{##1}}}%
    \needspace{0.5\textheight}%
    \newdimen\boxwidth%
    \boxwidth=\dimexpr\linewidth-3\fboxsep\relax%
    \colorbox[HTML]{FFFFCC}{%
    \begin{tabularx}{\boxwidth}{c|X}
    \SYMBOL{45} & {#2}\smallskip\\
    \SYMBOL{37} & {#3}\smallskip\\
    \SYMBOL{41} & \href{mailto:#4}{#4}
    \ifstrempty{#1}{}{\smallskip\\ \SYMBOL{218} & \href{http://#1}{#1}}
    \end{tabularx}}}

% Use only \item inside this environment: no other macros
% are allowed:
%
% |[
% \item[optional: what has been achieved]{years}{subject}{notes}
% ]|
\newenvironment{yearlist}{%
    \renewcommand\item[4][]{%
	\textsc{##2} & \textbf{##3} \\
	\ifstrempty{##1}{}{& \textsc{##1} \\}
	& \textit{##4}\medskip\\}
    \tabularx{\linewidth}{rX}}
    {\endtabularx}


% Use only \item inside this environment: no other macros
% are allowed:
%
% |[
% \item{fact}{description}
% ]|
\newenvironment{factlist}{%
    \renewcommand\item[2]{%
	\textsc{##1} & {\raggedright ##2}\medskip\\}
    \tabularx{\linewidth}{rX}}
    {\endtabularx}
%%
%% End of file `tccv.cls'.
