#!/bin/bash

#
# usage example:
# ./overleaf2github.sh 36965
# ./overleaf2github.sh 36965 37426 37557 37569
# ./overleaf2github.sh `sed -n '/36965/,$p' overleafprojectlist.csv | cut -d, -f1 | cut -d/ -f4 | tr '\n' ' '`
# ./overleaf2github.sh `./listOverLeafArticlesNotInGitHub.sh | grep -Po '/[0-9]+,' | tr -d '/,' | tr '\n' ' '`
#
# github x overleaf equivalence codes are stored in overleafprojectlist.csv
#
# This script clones from overleaf, makes bib files tidy (using bibtex-tidy), remove unused references from bib file, compiles and add to github.
#
# requires
# bibtex-tidy: https://github.com/FlamingTempura/bibtex-tidy

if ! command -v bibtex-tidy &> /dev/null
then
    echo "bibtex-tidy could not be found, please install it before running this script"
    exit
fi
if ! command -v checkcites &> /dev/null
then
    echo "checkcites could not be found, please install it before running this script"
    exit
fi

IDs=( "$@" )
ALWAYSOW=false
OVERWRITE=false
ALWAYSAG=false
ADDGITHUB=false
PUSHGITHUB=false
ALWAYSCL=false
CLEAN=false
ALWAYSAO=false # add to overleaf in case bib file changed after tindify
ADDOVERLEAF=false
CURRENTFOLDER=$(pwd)
TEXCOMPILER=1 # 1) XeLaTeX, 2) LuaLateX, 3) always XeLaTeX, 4) always LuaLateX
ALWAYSTEXCOMP=false

TL_FOLDER=$(dirname $CURRENTFOLDER)
for (( i=0; i<${#IDs[@]}; i++ ));
do
  echo "${IDs[$i]}"
  gresult=$(grep "${IDs[$i]}" overleafprojectlist.csv)
  DEST_FOLDER="$TL_FOLDER/$(echo $gresult | cut -d, -f1)"
  OVERLEAFID=$(echo $gresult | cut -d, -f2)
  if [ ! -z $DEST_FOLDER ] && [ ! -z $OVERLEAFID ]
  then
      #echo "$DEST_FOLDER $OID"
      if [ -d $DEST_FOLDER ]
      then
	  if [ $ALWAYSOW = false ]; then
	      while true; do
		  read -u 2 -p "Overwrite existing folder (y/n/a)?" yn
		  case $yn in
		      [Yy]* ) OVERWRITE=true; break;;
		      [Nn]* ) OVERWRITE=false; exit;;
		      [Aa]* ) ALWAYSOW=true; OVERWRITE=true; break;;
		      * ) echo "Please answer yes or no.";;
		  esac
	      done
	  else
	      OVERWRITE=true
	  fi
      else
	  mkdir -p $DEST_FOLDER
	  OVERWRITE=true
      fi

      if [ $OVERWRITE = true ]
      then
	  TMPFOLDER=$(mktemp -d)
	  trap '{ rm -rf "$TMPFOLDER"; }' INT TERM
	  until git clone -q --depth=1 https://leolca%40gmail.com@git.overleaf.com/$OVERLEAFID "$TMPFOLDER"
	  do
	      echo -e "\e[1;33mFailed to clone. Waiting 5 minutes to try again...\e[0m"
	      sleep 300
	  done
	  if [ $? -eq 0 ]
	  then
	      cp $TMPFOLDER/*.{pdf,PDF,ps,PS,png,PNG,jpg,JPG,jpeg,JPEG,eps,EPS,tex,TEX,bib,BIB} $DEST_FOLDER 2>/dev/null
	      ls -d $TMPFOLDER/*/ 2>/dev/null | while read d; do if [ -d "$d" ]; then cp -R $d $DEST_FOLDER 2>/dev/null; fi; done
	      rm -rf $DEST_FOLDER/article.pdf $DEST_FOLDER/internationalization.tex $DEST_FOLDER/listingconfig.tex $DEST_FOLDER/logo.pdf
	      cd $DEST_FOLDER
	      ln -sf "$TL_FOLDER/template/internationalization.tex"; 
	      ln -sf "$TL_FOLDER/template/listingconfig.tex";
	      ln -sf "$TL_FOLDER/template/logo.pdf";
	      ln -sf "$TL_FOLDER/template/textolivre.cls";
	      ln -sf "$TL_FOLDER/template/textolivre.cfg";
	      echo "compiling ${IDs[$i]}..."
	      if [ $ALWAYSTEXCOMP = false ]; then 
		  while true; do
		      read -u 2 -p "Which TeX compiler? 1) XeLaTeX, 2) LuaLateX, 3) always XeLaTeX, 4) always LuaLateX:" wtc
		      case $wtc in
			  [1]* ) TEXCOMPILER=1; break;;
			  [2]* ) TEXCOMPILER=2; break;;
			  [3]* ) TEXCOMPILER=1; ALWAYSTEXCOMP=true; break;;
			  [4]* ) TEXCOMPILER=2; ALWAYSTEXCOMP=true; break;;
			  * ) echo "Please choose an option.";;
		      esac
		  done
	      fi
	      if [ $TEXCOMPILER = 1 ]; then
		 xelatex --interaction=batchmode article.tex; biber --quiet article; xelatex --interaction=batchmode article.tex; xelatex --interaction=batchmode article.tex;
	      else
	         lualatex --interaction=batchmode article.tex; biber --quiet article; lualatex --interaction=batchmode article.tex; lualatex --interaction=batchmode article.tex;
	      fi
	      bibtex-tidy --omit=abstract --curly --space=4 --blank-lines --sort=name,year --merge --sort-fields --strip-comments --no-trailing-commas --remove-empty-fields --no-wrap article.bib 
	      # https://tex.stackexchange.com/questions/43276/unused-bibliography-entries-how-to-check-which-entries-were-not-used
	      checkcites --backend biber --unused article.bcf | grep "=>" | cut -d' ' -f2 | 
		  while read -r key 
		  do 
		      START=$(grep -Pn "^@\w+\{$key" article.bib | cut -d: -f1)
		      END=$(tail -n +$START article.bib | grep -Pn "^\}" | head -n 1 | cut -d: -f1)
		      END=$(($START+$END))
		      sed -i "${START},${END}d" article.bib
		  done
	      if ! diff article.bib $TMPFOLDER/article.bib > /dev/null; then 
		  if [ $ALWAYSAO = false ]; then
		      while true; do
			  read -u 2 -p ".bib file chaged after tidying... add chages to OverLeaf (y/n/a)?" yn
			  case $yn in
			      [Yy]* ) ADDOVERLEAF=true; break;;
			      [Nn]* ) ADDOVERLEAF=false; exit;;
			      [Aa]* ) ALWAYSAO=true; ADDOVERLEAF=true; break;;
			      * ) echo "Please answer yes or no.";;
			  esac
	              done
	          else
		      ADDOVERLEAF=true
	          fi
	          if [ $ADDOVERLEAF = true ]; then
		      cp article.bib $TMPFOLDER/article.bib
		      cd $TMPFOLDER
		      git add article.bib
		      git commit -m 'tidying bib file'
		      git push origin master
		      cd $DEST_FOLDER
		      ADDOVERLEAF=false
	          fi
	      fi
	      rm -rf "$TMPFOLDER"
	      cd $CURRENTFOLDER 
	  fi
          if [ $ALWAYSAG = false ]; then
	      while true; do
		  read -u 2 -p "Add to GitHub (y/n/a)?" yn
		  case $yn in
		      [Yy]* ) ADDGITHUB=true; break;;
		      [Nn]* ) ADDGITHUB=false; exit;;
		      [Aa]* ) ALWAYSAG=true; ADDGITHUB=true; break;;
		      * ) echo "Please answer yes or no.";;
		  esac
	      done
	  else
	      ADDGITHUB=true
	  fi
	  if [ $ADDGITHUB = true ]; then
	      git add $DEST_FOLDER/*
	      git commit -m "adding ${IDs[$i]}"
	      PUSHGITHUB=true
	      ADDGITHUB=false
	  fi
	  if [ $ALWAYSCL = false ]; then
	      while true; do
		  read -u 2 -p "Clean (y/n/a)?" yn
		  case $yn in
		      [Yy]* ) CLEAN=true; break;;
		      [Nn]* ) CLEAN=false; exit;;
		      [Aa]* ) ALWAYSCL=true; CLEAN=true; break;;
		      * ) echo "Please answer yes or no.";;
		  esac
	      done
	  else
	      CLEAN=true
	  fi
	  if [ $CLEAN = true ]; then
	      git clean -dxf $DEST_FOLDER
	      CLEAN=false
	  fi
      fi
  fi
done

if [ $PUSHGITHUB = true ]; then
    git push origin master
fi
