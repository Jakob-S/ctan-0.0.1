Issues:
If you're familiar with bash, you'll may find the issue and post the issue and it's solution.
If yoi're not familiar, please post the issue and I'll try to fix it as fast as I can.

CTAN:
If you are not able to install some packages from CTAN or if you think, there's one missing, visit the FTP of CTAN:
http://ftp.tu-chemnitz.de/pub/tex/macros/latex2e/contrib/

If there are any issues installing the wanted package automatically by the program, please post the issue and try it manually.
If there is a .sty file availabe, just copy it into your texmf-directory (which you can find like this: kpsewhich -var-value=TEXMFHOME
 [wasn't working for me sadly]). Then execute "sudo texhash" to update the texlive's package index.
If there are an .ins and a .dtx file, download them both and execute "latex <package>.ins" to generate a .sty file.
Then copy the .sty as mentioned above.

If there is none of the mentioned files, please view the README, the <package>,pdf, the <package>-doc.pdf or the <package>-doc.tex.
Otherwise look in the LaTeX forums to get to know, if there's any known bug with the specific package.

And please take care of the requirements some packages need. Some packages are really old and CTAN doesn't host the Requirements. Look for alternatives then, before posting an issue.
