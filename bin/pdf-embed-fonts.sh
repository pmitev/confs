#/bin/sh

if [ -z "$1" ]; then
  list=$(echo *.pdf)
else
  list=$*
fi


for file in $list
do
  fileb=$(basename $file .pdf)
  echo "Processing ...  "$file

  mv $file $fileb.bak.pdf

  gs -q -dSAFER -dPARANOIDSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dAutoRotatePages=/None -dPDFSETTINGS=/prepress -sOutputFile=$fileb.pdf -c '.setpdfwrite'  -f $fileb.bak.pdf

done
