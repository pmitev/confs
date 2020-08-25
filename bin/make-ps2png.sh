#/bin/bash

if [ -z "$1" ]; then
  list=$(echo *.ps)
else
  list=$*
fi

for file in $list
do
  fileb=$(basename $file .ps)
  if [ $file -nt $fileb.png ]; then
    echo "Processing ...  "$file

    orient=$(awk '/%%Orientation:/{print $2}' $file)
    if [ "$orient" == "Landscape" ]; then
      convert -colors 128 -density 300 -geometry 50% -rotate 90 $file -trim +repage -bordercolor white -border 50x50 $fileb.png
    else
      convert -colors 128 -density 300 -geometry 50%            $file -trim +repage -bordercolor white -border 50x50 $fileb.png
    fi

  fi
done
