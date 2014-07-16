#!/bin/bash

for size in a4 a5 a6 a7 ; do
	for rot in portrait landscape ; do
		cat >$size-${rot}.tex <<EOD
\documentclass{article}
\usepackage{fontspec}
\usepackage[${size}paper,hmargin=0mm,vmargin=7mm,$rot]{geometry}

\setlength{\\parindent}{0pt}
\pagestyle{empty}

\\begin{document}

\\begin{center}
\Large
\input{inner}
\end{center}

\end{document}
EOD
	done
done
