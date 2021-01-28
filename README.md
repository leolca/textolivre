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

The provided template already uses a few LaTeX packages. You might check which are already included by running:
``` 
$ cat template/textolivre.cls | sed -n -e 's/\(^\\RequirePackage\)\(\[[-,a-z0-9=]*\]\)\?{\(.*\)}/\3/p' | sort | tr '\n' ','
abstract,academicons,adjustbox,amsmath,amsfonts,amssymb,amsthm,authblk,biblatex,caption,subcaption,cleveref,cmbright,datetime2,enumitem,etoolbox,xpatch,fancyhdr,fontspec,footmisc,geometry,graphicx,hyperref,ifxetex,ifluatex,inputenc,lastpage,lineno,listings,longtable,booktabs,tabularx,mfirstuc,microtype,pdfx,polyglossia ,relsize,rotating,setspace,textcomp,textpos,titlecaps,titlesec,xcolor,xstring,
```
Any other additional package might be included in the heading of your ```.tex``` file.

Multilanguage support is included through the polyglossia package. You just have to set the article default language by means of the ```\setdefaultlanguage``` command, as exemplified in the template example. Also set the second, third, ... languaged used by the command ```\setotherlanguage```. The text in language, other than the default one, should comes inside this language environment. See the example provided. For more information on this package and usage information, visit https://ctan.org/pkg/polyglossia.

Provided the title of the document using the standard ```\title``` command and the title in other language using the command ```\othertitle``` defined in the template. You might use ```\othertitle``` as many times as desired (usually just once and three times seldom).

Authors are inserted using the ```authblk``` package. For more information on the package, visit https://www.ctan.org/pkg/authblk. You might also provide the author ORCID by the ```\orcid```  command (see the usage in the example file).
