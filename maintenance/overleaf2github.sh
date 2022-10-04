#!/bin/bash
IDs=( "$@" )
ALWAYSOW=false
OVERWRITE=false
ALWAYSAG=false
ADDGITHUB=false
ALWAYSCL=false
CLEAN=false
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
	      cp $TMPFOLDER/*.{pdf,png,jpg,jpeg,eps,tex,bib} $DEST_FOLDER 2>/dev/null
	      rm -rf "$TMPFOLDER"
	      rm -rf $DEST_FOLDER/article.pdf $DEST_FOLDER/internationalization.tex $DEST_FOLDER/listingconfig.tex $DEST_FOLDER/logo.pdf
	      cd $DEST_FOLDER
	      ln -s ../../../../template/internationalization.tex; 
	      ln -s ../../../../template/listingconfig.tex;
	      ln -s ../../../../template/logo.pdf;
	      ln -s ../../../../template/textolivre.cls;
	      ln -s ../../../../template/textolivre.cfg;
	      xelatex article.tex; biber article; xelater article.tex; xelatex article.tex;
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
	  fi
	  if [ $ALWAYSCL = false ]; then
	      while true; do
		  read -u 2 -p "Clen (y/n/a)?" yn
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
	  if [ $CLEAN = true]; then
	      git clean -dxf $DEST_FOLDER
	  fi
      fi
  fi
done
