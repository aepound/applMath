%{
\documentclass{article}
\input{commonheader}
\usepackage{comment}


\newenvironment{matlabc}{}{}
\newenvironment{octavec}{}{}
\excludecomment{matlabc}
%\newenvironment{matlabv}{\verbatim}{\endverbatim}
%\newenvironment{octavev}{\verbatim}{\endverbatim}


% ******** For code: ******************
\usepackage{listings}
%\usepackage[usenames,dvipsnames]{color}
% ******** Define the language: *******
\lstdefinelanguage{matlabfloz}{%
	alsoletter={...},%
	morekeywords={% 						% keywords
	break,case,catch,continue,elseif,else,end,for,function,global,%
	if,otherwise,persistent,return,switch,try,while,...,
        classdef,properties,methods},%
	comment=[l]\%,% 						% comments
	morecomment=[l]...,% 					% comments
	morestring=[m]',%   						% strings 
}[keywords,comments,strings]%
\lstdefinestyle{matlab}{language=matlabfloz,							
		keywordstyle=\color[rgb]{0,0,1},					
		commentstyle=\color[rgb]{0.133,0.545,0.133},	% comments
		stringstyle=\color[rgb]{0.627,0.126,0.941},	% strings
		numbersep=3mm, numbers=left, numberstyle=\tiny% number style
}
% ******** Set the style: **************
\lstset{style=matlab}

\begin{matlabc}
%}
% Start some Matlabe startup stuffs:
clear all
close all

% Record version of MATLAB/Octave
a = ver('octave');
if length(a) == 0
    a = ver('matlab');
end
fid = fopen('vers.tex', 'w');
fprintf(fid, [a.Name ' version ' a.Version]);
fclose(fid);

% Record computer architecture.
fid = fopen('computer.tex', 'w');
fprintf(fid, ['\\verb+' computer '+']);
fclose(fid);

% Record date of run.
fid = fopen('date.tex', 'w');
fprintf(fid, datestr(now, 'dd/mm/yyyy'));
fclose(fid);

%{
\end{matlabc}
\title{MATH 5410: Homework 1}             
\author{Andrew Pound}
%\date{\input{date.tex}}

\begin{document}
\maketitle

\section{}
When a drop of liquid hits a wetted surface a crown formation appears,
as shown in Figure \ref{fig:a}. 

\begin{figure}[h!]
  \centering
%  \includegraphics[viewport=100 200 800 320, width=.7\linewidth]{HW1}
  \includegraphics[width=.25\linewidth]{figa}
  \caption{Crown drops.}
  \label{fig:a}
\end{figure}

It has been found that the number of points $N$ on the crown depends
on the speed $U$ at which the drop hits the surface, the radius $r$
and density $\rho$ of the drop, and the surface tension $\sigma$ of the
liquid making up the drop.
\begin{enumerate}
\item Use dimensional analysis to determine the functional dependence
  of $N$ on $U$, $r$, $\rho$, and $\sigma$. Express your answer in
  terms of the Weber number $W = \frac{\rho U^2 r}{\sigma}$.

\item The value of $N$ has been measured as a function of the initial
  height $h$ of the drop and the results are shown in Figure
  (b). Express your answer in part A in terms of $h$ by writing $U$ in
  terms of $h$ and $g$, the acceleration due to gravity. Assume the
  drop starts with zero velocity.

\begin{matlabc}
%}
% Let's plot the data like it is in the assignment...
d = [10 0; 46 11; 49 9; 61 13; 89 21; 91 22; 123 23; 130 31; 161 40; 199 48];
f1 = figure;
set(f1,'outerposition',[914 1023 529 300]);
plot(d(:,1),d(:,2),'ro','markersize',7),grid on
ylabel('Number of Points')
xlabel('Height (cm)')

print(f1,'-depsc2','figb.eps')
system('ps2pdf -dEPSCrop figb.eps')
%{
\end{matlabc}
  \begin{figure}[h]
    \centering
    \includegraphics[width=0.3\linewidth]{figb}
    \caption{ }
    \label{fig:b}
  \end{figure}

\begin{matlabc}
%}
x = d(:,1);
y = d(:,2);
xx = 0:200;
yy = (x'*x)^(-1)*x'*y.*xx;
f2 = figure;
plot(d(:,1),d(:,2),'ro','markersize',7)
hold on
plot(xx,yy)
grid on

% Second fit: with y intercept...
x2 = [x ones(size(x))];
xx2 = [xx; ones(size(xx))];
yy2 = ((x2'*x2)\(x2'*y))'*xx2;

hold on 
plot(xx2(1,:),yy2,'m')

legend('Data','lin-fit y(0)=0','lin-fit y(0)=b',...
       'Location','southeast')
ylabel('Number of Points')
xlabel('Height (cm)')

print(f2,'-depsc2','figc.eps')
system('ps2pdf -dEPSCrop figc.eps')
%{
\end{matlabc}


\end{enumerate}


\end{document}
%}