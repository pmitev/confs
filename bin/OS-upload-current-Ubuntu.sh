#!/bin/bash

CMD_qemu_cmd="qemu-img"
#CMD_qemu_cmd="singularity exec /crex/proj/staff/pmitev/nobackup/sbin/qemu-utils.sif qemu-img"


TMP_DIR=$(mktemp -d) && \
cd ${TMP_DIR} && echo "TMP_DIR: "${TMP_DIR} && \
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img && \
${CMD_qemu_cmd} convert -p -f qcow2 -O raw focal-server-cloudimg-amd64.img  focal-server-cloudimg-amd64.raw && \
IMAGE_NAME=$(date -r focal-server-cloudimg-amd64.img +"Ubuntu 20.04 - %Y.%m.%d") && \
openstack image create --min-disk 20 --private --file focal-server-cloudimg-amd64.raw "${IMAGE_NAME}" && \
cd -

