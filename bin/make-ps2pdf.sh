#/bin/bash

if [ -z "$1" ]; then
  list=$(echo *.ps)
else
  list=$*
fi


for file in $list
do
  fileb=$(basename $file .ps)
  if [ $file -nt $fileb.pdf ]; then
    echo "Processing ...  "$file


#   bbox=$(awk '/%%BoundingBox:/{print $2,$3,$4,$5 }' $file)
    bbox=$(gs -dQUIET -dBATCH -dNOPAUSE -sDEVICE=bbox $file 2>&1 | head -n 1| awk '/%%BoundingBox:/{print $2,$3,$4,$5 }')

    #ps2pdf13 $file
    gs -q -dSAFER -dPARANOIDSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$fileb.pdf $file

    if [ ! -z "$bbox" ]; then
      sed -i -e "s/\/Type\/Page\/MediaBox.*$/\/Type\/Page\/MediaBox [$bbox]/" $fileb.pdf
    else
      echo "WARNING! %%BoundingBox: information was not found in the source file"
    fi

  fi
done
