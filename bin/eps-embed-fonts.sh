#/bin/sh

if [ -z "$1" ]; then
  list=$(echo *.eps)
else
  list=$*
fi


for file in $list
do
  fileb=$(basename $file .eps)
  dir=$(dirname $file)
  echo "Processing ...  "$file

  ps2pdf14 -dPDFSETTINGS=/prepress $file /tmp/$USER-$fileb.pdf
 
  pdftops -eps /tmp/$USER-$fileb.pdf /tmp/$USER-$fileb.eps

  ps2epsi "/tmp/$USER-$fileb.eps" "$dir/$fileb.epsi"
done
