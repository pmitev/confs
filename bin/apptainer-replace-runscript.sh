#!/bin/bash

url=${1}
tmpfile=$(mktemp /tmp/container.def.XXXXXX)
logfile=${tmpfile/def/log}
line="============================================="

BOOTSTRAP="${url%%://*}"
FROM="${url#*://}"

DEF="Bootstrap: ${BOOTSTRAP}\n\
From: ${FROM}\n\
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
echo -e ${DEF} | tee ${tmpfile} | tee -a ${logfile}
echo -e "[I]: ${line}\n" | tee -a ${logfile}

apptainer build container.sif ${tmpfile} |& tee -a ${logfile}


