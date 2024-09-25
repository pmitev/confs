#!/bin/bash
# source of the script
# https://www.eessi.io/docs/getting_access/eessi_container/
# https://github.com/EESSI/eessi-demo/blob/main/scripts/start_singularity_eessi_pilot.sh

# honor $TMPDIR if it is already defined, use /tmp otherwise
if [ -z $TMPDIR ]; then
    export WORKDIR=/tmp/$USER
else
    export WORKDIR=$TMPDIR/$USER
fi

mkdir -p ${WORKDIR}/{var-lib-cvmfs,var-run-cvmfs,home}
export SINGULARITY_BIND="${WORKDIR}/var-run-cvmfs:/var/run/cvmfs,${WORKDIR}/var-lib-cvmfs:/var/lib/cvmfs"
export SINGULARITY_HOME="${WORKDIR}/home:/home/$USER"
export EESSI_PILOT="container:cvmfs2 pilot.eessi-hpc.org /cvmfs/pilot.eessi-hpc.org"
singularity shell --fusemount "$EESSI_PILOT" docker://eessi/client-pilot:centos7-$(uname -m)

# notes
# https://eessi.github.io/docs/pilot/#accessing-the-eessi-pilot-repository-through-singularity
# https://www.youtube.com/watch?v=sreSIQHTGL8
# https://www.youtube.com/watch?v=bZTM4seSI3c&list=PLhnGtSmEGEQgCneeSQvYoIZrbv7wIKlo2
