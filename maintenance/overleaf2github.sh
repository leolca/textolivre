#!/bin/bash
IDs=( "$@" )
ALWAYSOW=false
OVERWRITE=false
ALWAYSAG=false
ADDGITHUB=false
CURRENTFOLDER=$(pwd)

for (( i=0; i<${#IDs[@]}; i++ ));
do
  echo "${IDs[$i]}"
  gresult=$(grep "${IDs[$i]}" overleafprojectlist.csv)
  DEST_FOLDER="../$(echo $gresult | cut -d, -f1)"
  OID=$(echo $gresult | cut -d, -f2)
  if [ ! -z $DEST_FOLDER ] && [ ! -z $OID ]
  then
      echo "$DEST_FOLDER $OID"
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
      fi

      if [ $OVERWRITE ]
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
	      cp $TMPFOLDER/*.{pdf,png,jpg,jpeg,eps,tex,bib} $DEST_FOLDER 2>/dev/null
	      rm -rf $TMPFOLDER/article.pdf $TMPFOLDER/internationalization.tex $TMPFOLDER/listingconfig.tex $TMPFOLDER/logo.pdf
	      cd $TMPFOLDER
	      ln -s ../../../../template/internationalization.tex; 
	      ln -s ../../../../template/listingconfig.tex;
	      ln -s ../../../../template/logo.pdf;
	      ln -s ../../../../template/textolivre.cls;
	      ln -s ../../../../template/textolivre.cfg;
	      xelatex article.tex; biber article; xelater article.tex; xelatex article.tex;
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
	      OVERWRITE=true
	  fi
      fi
  fi
done
