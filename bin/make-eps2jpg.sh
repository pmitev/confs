#/bin/bash

if [ -z "$1" ]; then
  list=$(echo *.eps)
else
  list=$*
fi

for file in "$list"
do
  fileb=$(basename "$file" .eps)
  if [ "$file" -nt "$fileb".jpg ]; then
    echo "Processing ...  "$file

    orient=$(awk '/%%Orientation:/{print $2}' "$file")
    if [ "$orient" == "Landscape" ]; then
      #convert -quality 90 -density 300 -geometry 50% -rotate 90 $file -trim +repage "$fileb".jpg
      convert -quality 90 -density 300               -rotate 90 $file -trim +repage "$fileb".jpg
    else
      #convert -quality 90 -density 300 -geometry 50%            $file -trim +repage "$fileb".jpg
      convert -quality 90 -density 300                          $file -trim +repage "$fileb".jpg
    fi

  fi
done
