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
\title{Torrecelli's Leaky Bucket}             
\author{Ben Pound, Isaac Cocar, Andrew Pound}
%\date{\input{date.tex}}

\begin{document}
\maketitle


\section{Methods}
The preliminary model that we used to model the drainage rate of water
from a small hole in a water bottle was based on Torrecelli's Law,
where the height of the water level at a given time is given by 

\begin{equation}
  h= \ledt[\sqrt{h_0} \frac{a}{A} \sqrt{\frac{g}{2}}t\right]^2
\end{equation}

where h = height of water in the bottle,  = the initial height, a =
the area of the hole in the bottle, A = cross sectional area of the
bottle, and t = elapsed time. This, however, is a highly idealized
model and may not accurately describe the actual behavior of how the
water level varies with time. 

Data collection was straightforward. The bottle was filled, with the 
hole at the bottom being plugged. The stopwatch was started the moment
that the hole was unplugged, and the time elapsed between each
full-centimeter decrease of water level was recorded. Four data runs
were performed, and the average time was calculated for each height. 

\section{Results}

Our data always starts when h_0 = 12 cm. We estimated a to be around
.275 cm2, and the cross sectional area to be 30.88 cm2. We assumed g
was the standard physics class value of 980 cm/s2.  

In the graph below we show the results of three models, one of which
is Torrecelli's Law from above, and two others derived using
dimensional analysis. 

%% Figure here...

First model:   c1 =  1.3374  c2 = -1.3898   c3 = 0.2390
H = c1*h0+c2*(t^2*g/h0)^c3
Second model:   c1 = 1.0180   c2 = 0.0025  c3 =  0.6833
H = c1*h0 * exp(-c2*(t^2*g/h0)
The other dimensionless quantities only include the hole area, the
cross dimensional area, and the initial height, and since those
quantities are all fixed as far as this experiment is concerned, I
``wrapped'' them up into the constants of the equations above so that I
only effectively had to deal with one dimensional quantity, t^2 *
g/h0. 

The first model fits the data points the best, but its value at t=0 is
around 16, so not so good, and also it dips below zero for its end
behavior, which is obviously not correct. 

The second model has a better initial value, of about 12, and better
end behavior than the first model, though it does not match each point
as well as the first model. 




{\singlespacing
\begin{lstlisting}
%}

%        h h0  a  A  t  g
Amat = [ 1  1  2  2  0  3;
         0  0  0  0  1 -2;
         0  0  0  0  0 -1];

%        h h0  a  A  t  g
Amat = [ 1  1  2  2  0  1;
         0  0  0  0  1 -2];

rank(Amat)

null(Amat)*100

P = [ -1  0  0  0  2  1;
       0 -1  0  0  2  1;
       1  0 -1  0  2  1;
       1  0  0 -1  2  1];
rank(P)

P*Amat.' % P => is in the Null space of Amat

%%

h = [12 11 10 9 8 7 6 5 4 3 2 1 0];
t= [nan 0.82 1.46 2.16 3.19 4.4  5.57 6.67 8.09  9.43 11.3  13.49 16.83]; 
t = [t; [nan 1.13 2.34 3.37  4.4 5.65 6.73 8.16 8.72 11.33 13.53 16.78 19.27]];
t = [t;  [1.22 1.98 2.73 3.74 4.92 5.95 6.93 8.55 10.2 12.16 14.07 16.75 nan]]; 
t = [t; [1.06 1.99 3.12 4.22 5.5  6.65 8.02 9.61 11.3 13.31 16.43 18.47 nan]]; 
t = [t; [.79  1.73 2.65 3.84 4.9  6.14 7.32 8.51 10.17 12.2 14.39 17.25 19.91]]; 


T = nanmean(t);

Type2 = @(a,N) a(1)*N./(1+ a(1)*a(2)*N);


g = 9.81; % m/sec
g = g*100; % cm/sec

A = 30.876; % Area of the crosssection of the bottle. cm^2

a = .275; % Area of the hole. cm^2

h0 = h(1);

tt = 0:0.1:20;
h_est = (sqrt(h0) - a/A*sqrt(g/2)*tt).^2;

%a = nlinfit(N,P,Type2,[0 0])

%% Graph the average of the data and the Toricelli's model
f1 = figure(4);
clf
plot(tt, h_est)

hold on, plot(T-T(1),h,'r','linewidth',2)
grid on
ylabel('height')
xlabel('time')
legend('Torricelli''s Law','Average data')

% Output to .eps and .pdf:
print(f1, '-depsc2', 'orbit.eps')
system('ps2pdf -dEPSCrop orbit.eps')

 
%{
\end{lstlisting}}


\end{document}
%}

