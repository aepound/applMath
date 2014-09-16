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
  h= \left[\sqrt{h_0} \frac{a}{A} \sqrt{\frac{g}{2}}t\right]^2,
\end{equation}
where $h$ is the height of water in the bottle, $h_0$ is the initial
height, $a$ is the area of the hole in the bottle, $A$ is the cross
sectional area of the 
bottle, and $t$ is elapsed time. This, however, is a highly idealized
model and may not accurately describe the actual behavior of how the
water level varies with time. 

Data collection was straightforward. The bottle was filled, with the 
hole at the bottom being plugged. The stopwatch was started the moment
that the hole was unplugged, and the time elapsed between each
full-centimeter decrease of water level was recorded. Four data runs
were performed, and the average time was calculated for each height. 



\section{Results}



Our data always starts when $h_0 = 12 cm$. 
The data that we collected can be seen in table \ref{tab:data}.
\begin{table}
  \centering
  \begin{tabular}[ht]{cccccc}
  \toprule
  height($cm$) & time 1 ($sec$) & time 2 ($sec$) & time 3 ($sec$) & time
  4 ($sec$) & time 5 ($sec$) \\  
  \midrule
  \input{data.tex}  
  \bottomrule
  \end{tabular}
  \caption{The data (minus the first and last data points because of
    uncertainty) that was collected during 5 different runs of the
    experiment.}
  \label{tab:data}
\end{table}

\begin{matlabc}
%}
% The data from our run....
h = [12 11 10 9 8 7 6 5 4 3 2 1 0];
t= [nan 0.82 1.46 2.16 3.19 4.4  5.57 6.67 8.09  9.43 11.3  13.49 16.83]; 
t = [t; [nan 1.13 2.34 3.37  4.4 5.65 6.73 8.16 8.72 11.33 13.53 16.78 19.27]];
t = [t;  [1.22 1.98 2.73 3.74 4.92 5.95 6.93 8.55 10.2 12.16 14.07 16.75 nan]]; 
t = [t; [1.06 1.99 3.12 4.22 5.5  6.65 8.02 9.61 11.3 13.31 16.43 18.47 nan]]; 
t = [t; [.79  1.73 2.65 3.84 4.9  6.14 7.32 8.51 10.17 12.2 14.39 17.25 19.91]];

% Chop off the first and the last to keep with the "good" data in the middle.
t1 = t(:,2:end-1);

% Write out the data in the table.
fid = fopen('data.tex','w');
fprintf(fid,'%s',sprintf([ '%d \t & %g\t & %g\t & %g\t & %g\t &' ...
             ' %g \\\\\n'],[(11:-1:1); t1]));
fclose(fid);

%{
\end{matlabc}

We estimated $a$ to be around
$.275 cm^2$, and the cross sectional area to be $30.88 cm^2$. We
assumed $g$ was the standard physics class value of $9.80 cm/s^2$.   

{\singlespacing
\begin{lstlisting}
%} 
T = nanmean(t);
tmod = 0:.01:T(end);

g = 9.81; % m/sec
g = g*100; % cm/sec

A = 30.876; % Area of the crosssection of the bottle. cm^2

a = .275; % Area of the hole. cm^2

h0 = h(1);

tt = 0:0.1:20;
h_est = (sqrt(h0) - a/A*sqrt(g/2)*tt).^2;

% Graph the average of the data and the Toricelli's model
f1 = figure(4);
clf
plot(tt, h_est)

hold on, plot(T-T(1),h,'r','linewidth',2)
grid on
ylabel('height')
xlabel('time')
legend('Torricelli''s Law','Average data')
%{ 
\end{lstlisting}
} %End singlespacing


\begin{matlabc}
%}

% Output to .eps and .pdf:
print(f1, '-depsc2', 'torr.eps')
system('ps2pdf -dEPSCrop torr.eps')

%{ 
\end{matlabc}


\begin{figure}[ht]
  \centering
  \includegraphics[width=.8\linewidth]{torr}
  \caption{The comparison to the average of our runs and what Torrecelli's law predicts.}
  \label{fig:torr}
\end{figure}
In figure \ref{fig:torr}, we show the average of our data runs and
what Torrecelli's Law would predict.  As can be seen, there seems to
be a decent discrepancy between the model and the measurements.  So,
maybe we can take a look at the model and find a better model.

\section{Dimensional Analysis}

So, enter dimensional analysis.  We first identify our parameters that
we are working with and form the \emph{dimension matrix}.  We end up
with the following
\begin{equation}
\begin{split}
    &\qquad\overbrace{
    \begin{matrix}
      h_0 & h & a & A & t & g
    \end{matrix}}^{\text{parameters}}\\
  \Abf &= \left.
  \begin{bmatrix}
    1 & 1& 2 & 2 & 0 & 1\\
    0 & 0 &0 & 0 & 1 &-2
  \end{bmatrix} 
  \begin{matrix}
    L \\ T 
  \end{matrix}\right\} \text{dimensions}
\end{split}
\end{equation}
The rank of $\Abf$ is 2, thus we have 4 independent dimensionless
quantities ($\Pi_i$) that we can use.
In order to make things easier, we kept the constant parameters all in
their own $\Pi_i$'s. Thus, we found the dimensionless quantities
\begin{align}
  \Pi_1 &=
  \begin{bmatrix}
    -1 \\ 1 \\ 0 \\ 0 \\ 0 \\ 0
  \end{bmatrix} = \frac{h}{h_0}
  & \Pi_2 &= 
  \begin{bmatrix}
    0 \\ 0\\ 2 \\ -2 \\0 \\0
  \end{bmatrix} = \frac{a}{A^2}
  & \Pi_3 &= 
  \begin{bmatrix}
    -1 \\ 0 \\ 0\\ 0\\ 2\\ 1
  \end{bmatrix} = \frac{t^2g}{h_0}
   & \Pi_4 &= 
   \begin{bmatrix}
     2 \\ 0 \\ 1\\ -2 \\ 0 \\0
   \end{bmatrix} = \frac{h_0^2a}{A^2}.
\end{align}
We will assume
\begin{equation}
  f(\Pi_1)= 0, \quad \text{where} \quad \Pi_1 = g\left(\Pi_2,\Pi_3,\Pi_4\right).
\end{equation}
Then, let us say that $g(\dot)$ can be written as
\begin{equation}
  g\left(\Pi_2,\Pi_3,\Pi_4\right) = G\left(\Pi_2\right) + H\left(\Pi_3\right) + I\left(Pi_4\right),
\end{equation}
This leads us to the equation
\begin{equation}
\begin{split}
  \Pi_1 &= G\left(\Pi_2\right) + H\left(\Pi_3\right) + I\left(\Pi_4\right),\\
  h &= h_o\left(G\left(\Pi_2\right) + H\left(\Pi_3\right) + I\left(\Pi_4\right)\right)\\
  &= G'\left(\Pi_2\right) + H'\left(\Pi_3\right) + I'\left(\Pi_4\right)\\
  & = \underbrace{G'\left(\frac{a}{A^2}\right)}_{\text{constant}} +
  H'\left(\frac{t^2g}{h_0}\right)  +
  \underbrace{I'\left(\frac{h_0^2a}{A^2}\right)}_{\text{constant}}\\ 
  & = C + H'\left(\frac{t^2g}{h_0}\right).
\end{split}
\end{equation}

The other dimensionless quantities only include the hole area $a$, the 
cross dimensional area $A$, and the initial height $h_0$, and since those
quantities are all fixed as far as this experiment is concerned, we
``wrapped'' them up into the constants of the equations above so that we
only effectively had to deal with one dimensional quantity,
$\Pi_3 = t^2\frac{g}{h_0}$. 

\subsection{A fit}
Thus, we postulate that we can use a model that looks like
\begin{equation}
  h = c_1 + c_2\sqrt{\frac{t^2g}{h_0}}
\end{equation}
or even more generally,
\begin{equation}
   h = c_1 + c_2\left(\frac{t^2g}{h_0}\right)^{c_3}.
\end{equation}

{\singlespacing
\begin{lstlisting}
%}

tor = (sqrt(h0)-a/A*sqrt(g/2).*tmod).^2; % torrecelli's model

% height = constant1 + constant2*sqrt(tmod.^2*g/h0): constant1 = c(1),
% constant 2 = c(2);

F = @(c,xdata) c(1)*h0 + c(2)*(xdata.^2*g/h0).^c(3);
c0 = [5,-1/16,1/2];

c = lsqcurvefit(F,c0,T-T(1),h);


fig = figure(1); % plotting everything
clf
hold on
plot(T-T(1),h,'ro',tmod,tor,'b--',tmod,F(c,tmod),'g-')
title('Models of the Leaky Bucket')
grid on
xlabel('Time (s)')
ylabel('Height (cm)')
legend('Data (mean of runs)','Torricelli''s Model','Model 1')
%{
\end{lstlisting}
} % End singlespacing
\begin{matlabc}
%}

% Output to .eps and .pdf:
print(fig, '-depsc2', 'model.eps')
system('ps2pdf -dEPSCrop model.eps')

% output the coefficients found. 
fid = fopen('coeffs1.tex','w');
fprintf(fid,'%s',sprintf('%g & %g & %g \\\\',c));
fclose(fid);
%{
\end{matlabc}
Figure \ref{fig:mod1} shows the fit of this model compared to
Torrecelli's Law and the mean of the data collected.
\begin{figure}[ht]
  \centering
  \includegraphics[width=.8\linewidth]{model}
  \caption{The fit of model 1 to the data compared to Torrecelli's
    Law.  The mean of the collected data is shown also.} 
  \label{fig:mod1}
\end{figure}
We can see that this fit actually does better at predicting the data. 
The coefficients found are shown in table \ref{tab:mod1}.
\begin{table}[hb]
  \centering
  \begin{tabular}{ccc}
    \toprule
    $c_1$ &    $c_2$ &    $c_3$ \\
    \midrule
    \input{coeffs1.tex}
    \bottomrule
  \end{tabular}
  \caption{The coefficients from model 1, as found in \matlab .}
  \label{tab:mod1}
\end{table}

\subsection{A different fit}
The model above matches very well with the data, but doesn't seem to
capture the end result and slow down all that well.  We tried
a different fit to see if we could come up with something better.
This time we postulated the model as
\begin{equation}
  H = c_1h_0 e^{-c_2\left(\frac{t^2g}{h_0}\right)^{c_3}}
\end{equation}
Following the same procedure as before, we obtain the fit shown in
figure \ref{fig:mod2}.
{\singlespacing
\begin{lstlisting}
%}

tor = (sqrt(h0)-a/A*sqrt(g/2).*tmod).^2; % torrecelli's model

% height = constant1 + constant2*sqrt(tmod.^2*g/h0): constant1 = c(1),
% constant 2 = c(2);

F2 = @(c,xdata) c(1)*h0.*exp(-c(2)*(xdata.^2*g/h0).^c(3));
% c02 = [5,-1/16,1/2]; 
c02 = [ 1.0180, 0.0025, 0.6833]; % A lucky first guess... ;)

%c2 = lsqcurvefit(F2,c02,T-T(1),h);
c2 = nlinfit(T-T(1), h, F2, c02);

fig = figure(1); % plotting everything
clf
hold on
plot(T-T(1),h,'ro',tmod,tor,'b--',tmod,F(c,tmod),'g-',tmod,F2(c2,tmod),'m-')
title('Models of the Leaky Bucket')
grid on
xlabel('Time (s)')
ylabel('Height (cm)')
legend('Data (mean of runs)','Torricelli''s Model','Model 1','Model 2')
%{
\end{lstlisting}
} % End singlespacing
\begin{matlabc}
%}

% Output to .eps and .pdf:
print(fig, '-depsc2', 'model2.eps')
system('ps2pdf -dEPSCrop model2.eps')

% output the coefficients found. 
fid = fopen('coeffs2.tex','w');
fprintf(fid,'%s',sprintf('%g & %g & %g \\\\',c2));
fclose(fid);
%{
\end{matlabc}
\begin{figure}[ht]
  \centering
  \includegraphics[width=.8\linewidth]{model2}
  \caption{The fit of Models 1 and 2 to the data compared to
    Torrecelli's     Law.  The mean of the collected data is shown
    also.}  
  \label{fig:mod2}
\end{figure}
The coefficients for the second model can be seen in table
\ref{tab:mod2}.
\begin{table}[hb]
  \centering
  \begin{tabular}{ccc}
    \toprule
    $c_1$ &    $c_2$ &    $c_3$ \\
    \midrule
    \input{coeffs2.tex}
    \bottomrule
  \end{tabular}
  \caption{The coefficients from model 1, as found in \matlab .}
  \label{tab:mod2}
\end{table}

The first model fits the data points the best, but also it dips below
zero for its end behavior, which is obviously not correct. 

The second model also seems to fit the data well and has better
end behavior than the first model.

\section{Conclusion}
Both of the proposed models fit the data better than Torrecelli's Law,
suggesting that the are better for the modeling of this
experiment. Thus, dimensional analysis proves to be a valid method to
discover a different model that better fits the measured data in this
experiment. 




\begin{matlabc}
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



Type2 = @(a,N) a(1)*N./(1+ a(1)*a(2)*N);

%a = nlinfit(N,P,Type2,[0 0])
 
%{
\end{matlabc}



\end{document}
%}

