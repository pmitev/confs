#!/bin/bash
if [[ ! -z $PREFIX ]]; then
  wget -c https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
  sh Miniforge3-Linux-x86_64.sh -b -p $PREFIX -s
  eval "$($PREFIX/bin/conda shell.bash hook)"
  conda config --set auto_activate_base false
else
  echo 'ERROR: $PREFIX not set'
fi
