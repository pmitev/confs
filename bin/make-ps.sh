#!/bin/bash
# in gnuplot `make-ps file.ps`

fo=$1
if [ -z $1 ]; then fo="plot.ps"; fi

echo "set term postscript enhanced color;"
echo "set out '$fo';"
echo "replot;"
echo "set term x11;"
echo "set out;" 
