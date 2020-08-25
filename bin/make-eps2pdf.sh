#/bin/bash

if [ -z "$1" ]; then
  list=$(echo *.eps)
else
  list=$*
fi


for file in $list
do
  fileb=$(basename $file .eps)
  if [ $file -nt $fileb.pdf ]; then
    echo "Processing ...  "$file


    bbox=$(awk '/%%BoundingBox:/{print $2,$3,$4,$5 }' $file)

    epstopdf $file
    #epstopdf --debug $file

#    if [ ! -z "$bbox" ]; then
#      sed -i -e "s/\/Type\/Page\/MediaBox.*$/\/Type\/Page\/MediaBox [$bbox]/" $fileb.pdf
#    else
#      echo "WARNING! %%BoundingBox: information was not found in the source file"
#    fi

  fi
done
