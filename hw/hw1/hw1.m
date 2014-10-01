%{
\documentclass{article}
\input{commonheader}
\usepackage{comment}


\newenvironment{matlabc}{}{}
\newenvironment{octavec}{}{}
\excludecomment{matlabc}
%\newenvironment{matlabv}{\verbatim}{\endverbatim}
%\newenvironment{octavev}{\verbatim}{\endverbatim}
\usepackage{enumitem}

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
\begin{enumerate}[label=\Alph*)]
\item Use dimensional analysis to determine the functional dependence
  of $N$ on $U$, $r$, $\rho$, and $\sigma$. Express your answer in
  terms of the Weber number $W = \frac{\rho U^2 r}{\sigma}$.
\item[] Let's find a way to represent $N$ in terms of the other
  parameters $U$, $r$, $\rho$, and $\sigma$.  Let's take a look at the
  dimension matrix
  \begin{equation}
    \begin{split}
      & \qquad
      \begin{matrix}
        U & \; r & \;\; \rho & \;\;\; \sigma
      \end{matrix}\\
    &
%    \begin{matrix}
%      \\ L \\ T \\ M
%    \end{matrix}
    \begin{matrix}
       L & 1 & 1 &  -3  &   0    \\
       T &-1 & 0 &   0  &  -2    \\
       M & 0 & 0 &   1  &   1   
    \end{matrix}
    \end{split}
  \end{equation}
So, we get that 
\begin{equation}
  A =
  \begin{bmatrix}
        1 & 1 &  -3  &   0    \\
       -1 & 0 &   0  &  -2    \\
        0 & 0 &   1  &   1  
  \end{bmatrix}.
\end{equation}
The rank is $\rank(A) = 3$, so there is only one dimensionless
quantity. Looking at the units of the parameters we can see that we
can put them together as
\begin{equation}
  \left[\frac{\rho U^2 r}{\sigma}\right] 
  = \frac{\left[\rho\right]\left[ U\right]^2
    \left[r\right]}{\left[\sigma\right]} 
  = \left[\rho\right]\left[U\right]^2
    \left[r\right]\frac{1}{\left[\sigma\right]}
  = \frac{M}{L^3} \left(\frac{L}{T}\right)^2 \frac{L}{1}
  \frac{1}{\frac{M}{T^2}}
  = \frac{M L^2 L T^2}{L^3 T^2 M} = 1.
\end{equation}
Thus, we should be able to find a function such that $N =
f\left(\frac{\rho U^2 r}{\sigma}\right) = f(W)$.  A decent guess could
be that $f(\cdot)$ is a linear function of  $W$, that is,
$N = K\cdot W = K\frac{\rho U^2 r}{\sigma}$, for some constant $K$.

\item The value of $N$ has been measured as a function of the initial
  height $h$ of the drop and the results are shown in Figure
  \ref{fig:b}. Express your answer in part A in terms of $h$ by writing $U$ in
  terms of $h$ and $g$, the acceleration due to gravity. Assume the
  drop starts with zero velocity.

\begin{matlabc}
%}
%% Let's plot the data like it is in the assignment...
d = [10 0; 46 11; 49 9; 61 13; 89 21; 91 22; 123 23; 130 31; 161 40; 199 48];
f1 = figure;
%set(f1,'outerposition',[894 1003 549 340]);
set(f1,'outerposition',[914 1023 529 300]);
%set(f1,'paperposition',[914 1023 529 300]);
%set(f1,'paperposition',[1 1 530 300]);

plot(d(:,1),d(:,2),'ro','markersize',7),grid on
ylabel('Number of Points','fontsize',14)
xlabel('Height (cm)','fontsize',14)
a1 = gca;
set(a1,'ytick',[0:10:50])
set(a1,'xtick',[0:50:200])

print(f1,'-depsc2','-loose','figb.eps')
system('ps2pdf -dEPSCrop figb.eps')
close(f1);
%{
\end{matlabc}
  \begin{figure}[h]
    \centering
    \includegraphics[width=0.5\linewidth,height=.25\textheight]{figb}
    \caption{ }
    \label{fig:b}
  \end{figure}
\item[]
Let $g = 9.81 m/s^2 = 981 cm/s^2$. Now, let's look at the height of a
falling object.  The equation for the height $h$ that a falling object
has traveled is given by
\begin{equation}
  h = \frac{1}{2} gt^2.
\end{equation}
From this we can find the amount of time it took the object to drop
from height $h$ as
\begin{equation}
  \frac{2h}{g} = t^2 \qquad \Rightarrow \qquad t = \sqrt{\frac{2h}{g}}.
\end{equation}
Now, the speed that a falling object achieves in time $t$ is given by 
\begin{equation}
  U = gt = g\sqrt{\frac{2h}{g}} = \sqrt{2hg}.
\end{equation}
Putting this into the equation from the previous part, we get an
equation of the form
\begin{equation}
  N = K\frac{\rho U^2 r}{\sigma} = K\frac{2 g\rho r}{\sigma}h.
\end{equation}



\item The data in Figure \ref{fig:b} show a piecewise linear dependence on
  $h$, specifically, $N$ can be described as a continuous function
  made up of two linear segments. Use this, and your result from part
  B, to find the unknown function in part A. In the experiments, $r =
  3.6 mm$, $\rho = 1.1014 gram/cm^3$ and $\sigma = 50.5 dyn/cm$.

I simulated the data as closely as possible and entered it into
\matlab. I fit the data to a least squares fit using the code
below. 

{\singlespacing
\begin{lstlisting}
%}
x = d(:,1);
y = d(:,2);
xx = 0:200;
m1 = (x'*x)^(-1)*x'*y;
yy = m1*xx;
f2 = figure;
plot(d(:,1),d(:,2),'ro','markersize',7)
hold on
plot(xx,yy)
grid on

% Second fit: with y intercept...
x2  = [x ones(size(x))];
xx2 = [xx; ones(size(xx))];
m2  = ((x2'*x2)\(x2'*y));
yy2 = m2'*xx2;

hold on 
plot(xx2(1,:),yy2,'m')

legend('Data','lin-fit y(0)=0','lin-fit y(0)=b',...
       'Location','southeast')
ylabel('Number of Points')
xlabel('Height (cm)')
%{
\end{lstlisting}}% end singlespacing
The fits can be seen in Figure \ref{fig:c}.  There are two fits, each
with slope and intercept.  The slope and intercept values are
tabulated in Table \ref{tab:1}.  We only really use the first fit with
the y-intercept 0.  This may be a source of error in our analysis, but
the fit still seems fairly good, so I went with it.
\begin{table}
  \centering
  \begin{tabular}{ccc}
    \toprule
     & slope & y-intercept \\ 
    \midrule
    \input{table.tex}
    \bottomrule
  \end{tabular}
  \caption{Slope and intercept for the two fits of the data.}
  \label{tab:1}
\end{table}

\begin{figure}
  \centering
  \includegraphics[width=.6\linewidth]{figc}
  \caption{Graphs of the 2 linear fits to the data.}
  \label{fig:c}
\end{figure}

\begin{matlabc}
%}

fid = fopen('table.tex','w');
t = [1 m1 0; 2  m2']
fprintf(fid,'%s',...
        sprintf([ 'fit %d \t & %g\t & %g\t \\\\\n'],t'));
fclose(fid);

print(f2,'-depsc2','figc.eps')
system('ps2pdf -dEPSCrop figc.eps')
close(f2);
%{
\end{matlabc}

We will model the function after the first fit.  Thus, we are assuming
that
\begin{equation}
  N = K\frac{2g\rho r}{\sigma}h \sim 0.2331 h.
\end{equation}
Let's plug in the given values for the known parameters to find out
what $K$ would need to be.
We get that
\begin{equation}
  \frac{2g\rho r}{\sigma} = \frac{2(981)(1.1014)(.36)}{50.6} \approx
  15.37.
\end{equation}
Solving for $K$, we get $K \approx \input{K.tex}$. This let's us say that
our function is
\begin{equation}
  N = \input{K.tex} \frac{2g\rho r}{\sigma}h.
\end{equation}



\item According to your result from part C, what must the initial
  height of the drop be to produce at least 80 points?

\item[]
To find this, let's solve for $h$
\begin{equation}
  h = \input{Kinv.tex} \frac{\sigma}{2g\rho r}N.
\end{equation}
Plugging in we get

{\singlespacing
\begin{lstlisting}
%}  
r = .36;
rho = 1.1014;
sig = 50.5;
g = 981;
W_ = 2*g*rho*r/sig;
K = m1/W_;

N = 80;

h = 1/K*sig/(2*g*rho*r)*N;
%{
\end{lstlisting}}

From this we get that the height $h$ that we need to have to obtain at
least 80 points is somewhere around $h = \input{h.tex} cm$.
\begin{matlabc}
%}
fid = fopen('K.tex','w')
fprintf(fid,'%s',sprintf('%g',K));
fclose(fid);

fid = fopen('Kinv.tex','w')
fprintf(fid,'%s',sprintf('%g',1/K));
fclose(fid);

fid = fopen('h.tex','w')
fprintf(fid,'%s',sprintf('%g',h));
fclose(fid);
%{
\end{matlabc}


\item According to your result from part C, how many points are
  generated for a drop of mercury when $h = 200 cm$? Assume $r = 3.6
  mm$, $\rho = 13.5 gram/cm^3$, and $\sigma = 435 dyn/cm$.
\item[]

Let's plug in the new values into \matlab and see what we get.

{\singlespacing
\begin{lstlisting}
%}  
r = .36;
rho = 13.5;
sig = 435;
g = 981;
h = 200;

K = m1/W_;

N = K*2*g*rho*r/sig*h
%{
\end{lstlisting}}
\begin{matlabc}
%}
fid = fopen('N.tex','w')
fprintf(fid,'%s',sprintf('%g',N));
fclose(fid);
%{
\end{matlabc}

We get that the number of points on the crown is $N = \input{N.tex}$.

\end{enumerate}


\end{document}
%}