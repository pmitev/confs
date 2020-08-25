#!/bin/sh

cat $1 | sed -e 's/\"\"/\"/g' |\
         sed -e 's/<i name=\(.*\)"string/<i name=\1"string">/g' |\
         sed -e 's/name\([[:alnum:]_]*\"\)/name=\"\1>/g' | \
         sed -e 's/<v name=\"\(.*\)\" /<v name=\"\1\" >/g' |\
         sed -e 's/<i name=\"\(.*\)\" /<i name=\"\1\">/' |\
         sed -e 's/<i name=\"\(.*\)\"-/<i name=\"\1\"> -/' |\
         sed -e 's/<time name=\"\([[:alnum:]_]*\"\)/<time name=\"\1>/g' |\
         sed -e 's/<v type=\"logical\"/<v type=\"logical\">/' |\
         \
         sed -e 's/name=\"positions\">/name=\"positions\" >/' |\
         sed -e 's/<varray name=\"basis\">/<varray name=\"basis\" >/'
