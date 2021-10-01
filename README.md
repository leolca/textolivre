![TextoLivre](template/logo.png)

This repository contains the LaTeX templates for the journal [Texto Livre](https://periodicos.ufmg.br/index.php/textolivre/) and the final articles after the peer review and editorial process.

The file ```textolivre.cls``` implements the LaTeX class to create PDFs and the file ```textolivre-html.cls``` implements the LaTeX class to create HTMLs. To create a new article using the template, use the file ```article.tex``` as a starting point and read the instructions it provides. The template files should not be edited. If you require an additional package, insert it directly in the header of your ```.tex``` file.

## creating your ```article.tex```
Copy the example file ```article.tex``` and use it as your starting point. Note that the ```.tex``` file must be encoded in UTF-8. Use the journal document class ```textolivre```:
```
\documentclass{textolivre}
```
The class provides the template for portuguese, english, spanish and french. The default behaviour is to select portuguese as the manuscript main language. You may switch to a different language by specifying it as a parameter when loading the class. 
```
\documentclass[english]{textolivre}
```

#### packages 
The provided template already uses a few LaTeX packages. You might check which are already included by running:
``` 
cat template/textolivre.cls | sed -n -e 's/\(^\\RequirePackage\)\(\[[-,a-z0-9=]*\]\)\?{\(.*\)}/\3/p' | sort | tr '\n' ','
```
As a result, we see that the packages already included are: *abstract, adjustbox, amsmath, amsfonts, amssymb, amsthm, authblk, biblatex, caption, subcaption, cleveref, cmbright, csquotes, datetime2, enumitem, etoolbox, xpatch, fancyhdr, footmisc, geometry, graphicx, hyperref, hyperref, listings, longtable, booktabs, tabularx, colortbl, mfirstuc, polyglossia, relsize, setspace, textpos, titlesec, totpages, translations, xcolor, xstring*.

Any other additional package might be included in the preamble of your ```.tex``` file.

#### language support
Multilanguage support is included through the ```polyglossia``` package. The main language should be setted when loading the class. The class will also set a secondary (and tertiary language, if necessary). Other languages might be used by means of the ```\setotherlanguage{...}``` command.  The text in language, other than the default one, should come inside this language environment. Read the instruction in the template usage example provided. For further information on the ```polyglossia``` package, visit https://ctan.org/pkg/polyglossia.

#### title, author, abstract, keywords
Provided the title of the document using the standard ```\title``` command and the title in other language using the command ```\othertitle``` defined in the template. You might use ```\othertitle``` as many times as desired (usually just once and three times seldom).

Authors are inserted using the ```authblk``` package. For more information on the package, visit https://www.ctan.org/pkg/authblk. You might also provide the author ORCID by the ```\orcid```  command (see the usage in the example file).

To create multiple abstracts use the environment ```polyabstracts```. For the abstract using the default language, just provide it using the usual ```abstract``` environment. For an abstract in another language, use the language environment provided by polyglossia. You may use as many abstracts as you need. See the example:

``` 
\begin{polyabstract}
\begin{abstract}
...

\keywords{word1 \sep word2 ...}
\end{abstract}

\begin{french}
\begin{abstract}
...

\keywords{mot1 \sep mot2 ...}
\end{abstract}
\end{french}
\end{polyabstract}
```

The example above also shows the usage of ```keywords```. Use ```\sep``` between words.

### compiling your document
Use XeLaTeX to compile you document using the command:  
```
xelatex article.tex
```
If a PDF/A is required, compile using:

```
xelatex -shell-escape -output-driver="xdvipdfmx -z 0" article.tex
```
note that we have opted (```-z 0```) to suppress compression in XMP Metadata packet, in order to create a PDF/A compliant.

```-shell-escape``` is required by ```pdfx```. See the package documentation: https://ctan.org/pkg/pdfx. If you don't feel safe using it, you need to comment the PDF/A block in the end of the template file (```textolivre.cls```).

#### bibliography
Use ```biber``` to generate a bibliography in LaTeX. Biber has full Unicode support, that means your ```.bib``` might have any unicode character.
```
biber article
```

#### creating a PDF/A compliant file
Fill in the metadata information in your ```.tex``` file. See the example file.
You will also need to install the package ```icc-profiles``` and convert all images to PDF/A files.
To convert a PDF figure into a PDF/A version, use the following command in ```gv```:
```
gs -dPDFA -dBATCH -dNOPAUSE -sColorConversionStrategy=UseDeviceIndependentColor -dCompatibilityLevel=1.4 -sDEVICE=pdfwrite -sProcessColorModel=DeviceCMYK -dPDFACompatibilityPolicy=2 -sOutputFile=figure-a.pdf figure.pdf
```
If you are using a raster image format, such as PNG, convert it to EPS and then to PDF/A:
```
convert figure.png figure.eps
gs -dPDFA -dBATCH -dNOPAUSE -sColorConversionStrategy=UseDeviceIndependentColor -dCompatibilityLevel=1.4 -sDEVICE=pdfwrite -sProcessColorModel=DeviceCMYK -dPDFACompatibilityPolicy=2 -dEPSCrop -sOutputFile=figure.pdf figure.eps
```
To batch convert multiple files, use the following script:
```
for img in $( ls figure*.png ); do convert $img ${img%png}eps; gs -dPDFA -dBATCH -dNOPAUSE -sColorConversionStrategy=UseDeviceIndependentColor -dCompatibilityLevel=1.4 -sDEVICE=pdfwrite -sProcessColorModel=DeviceCMYK -dPDFACompatibilityPolicy=2 -dEPSCrop -sOutputFile=${img%png}pdf ${img%png}eps; done
```

#### compiling errors
Some errors might occur when changing from one class into another, since the compiler tries to use intermediary files previously generated. To overcome these errors, just remove those auxiliary files. Usually removing the ```.aux``` will do. If you wish to remove all of them, here is the command:
```
find . -name 'article.*' ! -name '*.tex' ! -name '*.pdf' ! -name '*.bib' ! -name '*.html' -type f -exec rm {} \;
```

### compiling into HTML
Compile the document using ```make4ht```. 

It might be necessary to get the updated ```.4ht``` files at: https://github.com/michal-h21/files/blob/master/tex4ht-4ht-files.zip

We also use some hooks written in the configuration file ```textolivre-html.cfg```. To compile, use the command
```
make4ht -e build.lua -c textolivre.cfg -x -u article "fn-in,svg,pic-align"
```
we have added the parameter *fn-in* to have inline footnotes; *svg* for dvi pictures in svg format and *pic-align* for pictorial align environment.
If you wish to get MathML equations, use
```
make4ht -e build.lua -c textolivre.cfg -u -x article "fn-in,mathml,mathjax"
```
French manuscrits also require the file ```gloss-french.4ht``` available at the template folder. See https://tex.stackexchange.com/questions/580456/error-when-using-polyglossia-french-and-make4ht

The HTML generated by ```make4ht``` has many breaklines which have been misinterpreted by some tools (like Marcalyc). If you need to remove them and any other cleaning/prettifying, use ```tidy```. The following command might be used to remove breaklines 
```
tidy -m --output-xhtml --break-before-br --wrap 0 article.html 2> errs.txt
```
For more information on ```tidy```, visit https://www.html-tidy.org/documentation/.

#### creating the ```.zip``` file for Marcalyc
Although the HTML created by ```make4ht``` with the ```-u,--utf8``` encodes the output document in utf8 and even writes the tag ```<meta charset='utf-8' />```, Markalyc only accepts if it find the tag ```<meta content="text/html; charset=UTF-8" http-equiv="content-type" />```. Use ```sed``` to change this tag:
```
sed -i 's/<meta\ charset=\x27utf-8\x27\ \/>/<meta\ content="text\/html;\ charset=UTF-8"\ http-equiv="content-type"\ \/>/' article.html
```

You should have created the HTMLs as described above. Now you need to zip all files and change the ```article.html``` name into ```index.html```.
The following command will create this intended zip using the current folder name as the name of the zip file:
```
ARTICLE=${PWD##*/} && zip ${ARTICLE}.zip article.html *.svg *.css && printf "@ article.html\n@=index.html\n" | zipnote -w ${ARTICLE}.zip
```
