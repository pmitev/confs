#!/bin/bash

inpfile=${1:-./conda.yml}
inpyml=$(<"${inpfile}")
tmpfile=$(mktemp /tmp/container.def.XXXXXX)
logfile=${tmpfile/def/log}
line="============================================="

DEF="BootStrap: docker\n\
From: mambaorg/micromamba:1.5.10-noble\n\
\n\
%environment\n\
  export PYTHONNOUSERSITE=True\n\
  export PATH=\"\$MAMBA_ROOT_PREFIX/bin:\$PATH\"\n\
\n\
%post\n\
  export PYTHONNOUSERSITE=True\n\
  export DEBIAN_FRONTEND=noninteractive\n\
  export CONDA_PKGS_DIRS=/tmp/conda_pkgs && mkdir -p \${CONDA_PKGS_DIRS}\n\
  export PIP_CACHE_DIR=/tmp/pip-cache && mkdir -p \${PIP_CACHE_DIR}\n\
\n\
mkdir -p /install\n\
cat << EOF > /install/conda.yml\n\
"${inpyml}"\n\
EOF\
\n\
\n\
  micromamba install -y -n base -f /install/conda.yml\n\
  micromamba install -y -n base conda-forge::procps-ng\n\
  micromamba env export --name base --explicit > /install/environment.lock\n\
  #micromamba clean -a -y\n\
\n\
%runscript\n\
#!/bin/sh\n\
  if command -v \$SINGULARITY_NAME > /dev/null 2> /dev/null; then\n\
    exec \$SINGULARITY_NAME \"\$@\"\n\
  else\n\
    echo \"# ERROR !!! Command $SINGULARITY_NAME not found in the container\"\n\
  fi"

echo "[I]: container.def in: ${tmpfile}" | tee ${logfile}
echo "[I]: ${line}" | tee -a ${logfile}
echo -e "${DEF}" | tee ${tmpfile} | tee -a ${logfile}
echo -e "[I]: ${line}\n" | tee -a ${logfile}

apptainer build container.sif ${tmpfile} |& tee -a ${logfile}
