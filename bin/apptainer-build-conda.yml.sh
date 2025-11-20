#!/bin/bash

inpfile=${1:-./conda.yml}
tmpfile=$(mktemp /tmp/container.def.XXXXXX)
logfile=${tmpfile/def/log}
line="============================================="

DEF="BootStrap: docker\n\
From: mambaorg/micromamba:1.5.10-noble\n\
\n\
%files\n\
  ${inpfile} /scratch/conda.yml\n\
\n\
%environment\n\
  export PATH=\"\$MAMBA_ROOT_PREFIX/bin:\$PATH\"\n\
\n\
%post\n\
  micromamba install -y -n base -f /scratch/conda.yml\n\
  micromamba install -y -n base conda-forge::procps-ng\n\
  micromamba env export --name base --explicit > environment.lock\n\
  echo \">> CONDA_LOCK_START\"\n\
  cat environment.lock\n\
  echo \"<< CONDA_LOCK_END\"\n\
  micromamba clean -a -y\n\
\n\
%runscript\n\
#!/bin/sh\n\
  if command -v \$SINGULARITY_NAME > /dev/null 2> /dev/null; then\n\
    exec \$SINGULARITY_NAME \"\$@\"\n\
  else\n\
    echo \"# ERROR !!! Command $SINGULARITY_NAME not found in the container\"\n\
  fi"

echo -e "${DEF}"
exit

echo "[I]: container.def in: ${tmpfile}" | tee ${logfile}
echo "[I]: ${line}" | tee -a ${logfile}
echo -e ${DEF} | tee ${tmpfile} | tee -a ${logfile}
echo -e "[I]: ${line}\n" | tee -a ${logfile}

apptainer build container.sif ${tmpfile} |& tee -a ${logfile}


