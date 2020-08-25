#/bin/bash

if [ -z "$1" ]; then
  list=$(echo *.ps)
else
  list=$*
fi

for file in $list
do
  fileb=$(basename $file .ps)
  if [ $file -nt $fileb.jpg ]; then
    echo "Processing ...  "$file

    orient=$(awk '/%%Orientation:/{print $2}' $file)
    if [ "$orient" == "Landscape" ]; then
      convert -quality 90 -density 300 -geometry 30% -rotate 90 $file -trim +repage $fileb.jpg
    else
      convert -quality 90 -density 300 -geometry 30%            $file -trim +repage $fileb.jpg
    fi

  fi
done
