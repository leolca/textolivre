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
