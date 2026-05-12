#!/bin/bash
export APPTAINER_BINDPATH="/crex,/gorilla,/proj,/scratch"
export APPTAINER_NO_MOUNT="/domus/h1"


apptainer instance start --nv /sw/apps/pm-tools/latest/rackham/bin/Ubuntu_24.04.sif lm

apptainer exec instance://lm /home/pmitev/.lmstudio/bin/lms server start

# lms runtime select llama.cpp-linux-x86_64-avx2
# lms runtime select llama.cpp-linux-x86_64-nvidia-cuda-avx2
# lms runtime select llama.cpp-linux-x86_64-vulkan-avx2

