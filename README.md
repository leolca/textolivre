![TextoLivre](template/logo.png)

This repository contains the LaTeX templates for the journal [Texto Livre](https://periodicos.ufmg.br/index.php/textolivre/) and the final articles after the peer review and editorial process.

The file ```textolivre.cls``` implements the LaTeX class to create PDFs and the file ```textolivre-html.cls``` implements the LaTeX class to create HTMLs. To create a new article using the template, use the file ```tl-article-template.tex``` as a starting point and read the instructions it provides. The template files should not be edited. If you require an additional package, inserted it directly in the header of your ```.tex``` file.

## creating your ```article.tex```
Copy the example file ```tl-article-template.tex``` and use it as your starting point. Note that, the ```.tex``` file must be encoded in UTF-8. Use the journal document class ```textolivre```:
```
\documentclass{textolivre}
```
to switch for an anonymous submission, provide the parameter ```anonymous``` to the class:
```
\documentclass[anonymous]{textolivre}
```

#### packages 
The provided template already uses a few LaTeX packages. You might check which are already included by running:
``` 
cat template/textolivre.cls | sed -n -e 's/\(^\\RequirePackage\)\(\[[-,a-z0-9=]*\]\)\?{\(.*\)}/\3/p' | sort | tr '\n' ','

abstract,academicons,adjustbox,amsmath,amsfonts,amssymb,amsthm,authblk,biblatex,caption,subcaption,cleveref,cmbright,datetime2,enumitem,etoolbox,xpatch,fancyhdr,fontspec,footmisc,geometry,graphicx,hyperref,ifxetex,ifluatex,inputenc,lastpage,lineno,listings,longtable,booktabs,tabularx,mfirstuc,microtype,pdfx,polyglossia ,relsize,rotating,setspace,textcomp,textpos,titlecaps,titlesec,xcolor,xstring,
```
Any other additional package might be included in the heading of your ```.tex``` file.

#### language support
Multilanguage support is included through the polyglossia package. You just have to set the article default language by means of the ```\setdefaultlanguage``` command, as exemplified in the template example. Also set the second, third, ... languaged used by the command ```\setotherlanguage```. The text in language, other than the default one, should comes inside this language environment. See the example provided. For more information on this package and usage information, visit https://ctan.org/pkg/polyglossia.

#### title, author, abstract, keywords
Provided the title of the document using the standard ```\title``` command and the title in other language using the command ```\othertitle``` defined in the template. You might use ```\othertitle``` as many times as desired (usually just once and three times seldom).

Authors are inserted using the ```authblk``` package. For more information on the package, visit https://www.ctan.org/pkg/authblk. You might also provide the author ORCID by the ```\orcid```  command (see the usage in the example file).

To create multiple abstracts use the environment ```polyabstracts```. For the abstract using the default language, just provided it using the usual ```abstract``` environment. For an abstract in another language, use the language environment provided by polyglossia. You may use as many abstracts as you need. See the example:

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
Use XeLaTeX to compile you document using the commmand:  
```
xelatex -shell-escape -output-driver="xdvipdfmx -z 0" article.tex
```
note that we have opted (```-z 0```) to suppress compression in XMP Metadata packet, in orther to create a PDF/A compliant.

```-shell-escape``` is required by ```pdfx```. See the package documentation: https://ctan.org/pkg/pdfx. If you don't feel save using it, you need to comment the PDF/A block in the end of the template file (```textolivre.cls```).

#### bibliography
Use ```biber``` to generate a bibliography in LaTeX. Biber has full Unicode support, that means you ```.bib``` might has any unicode character.
```
biber article
```

#### creating a PDF/A compliant file
Fill in the metadata information in your ```.tex``` file. See the example file.
You will also need to install tha package ```icc-profiles``` and convert all images to PDF/A files.
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
Change the class in your ```.tex``` file to ```textolivre-html```. And compile the document using ```make4ht```. 
We use some hooks written in the configuration file ```textolivre-html.cfg```. To compile, use the command
```
make4ht -c textolivre-html.cfg -u -x article "fn-in,svg,pic-align"
```
we have added the parameter *fn-in* to have inline footnotes; *svg* for dvi pictures in svg format and *pic-align* for pictorial align environment.
If you wish to get MathML equations, use
```
make4ht -c textolivre-html.cfg -u -x article "fn-in,mathml,mathjax"
```
The HTML generated by ```make4ht``` has many breaklines which as misinterpreted by some tools (like Marcalyc). If you need to remove them and any other cleaning/prettifying, use ```tidy```. The following command might be used to remove breaklines 
```
tidy -m --output-xhtml --break-before-br --wrap 0 article.html 2> errs.txt
```
For more information on ```tidy```, visit https://www.html-tidy.org/documentation/.

#### creating the ```.zip``` file for Marcalyc
You should have created the HTMLs as described above. Now you need to zip all files and change the ```article.html``` name into ```index.html```.
The following command will create this intended zip using the current folder name as the name of the zip file:
```
ARTICLE=${PWD##*/} && zip ${ARTICLE}.zip article.html *.svg *.css && printf "@ article.html\n@=index.html\n" | zipnote -w ${ARTICLE}.zip
```
