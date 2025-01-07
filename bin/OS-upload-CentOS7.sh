#!/bin/bash

CMD_qemu_cmd="qemu-img"
CMD_qemu_cmd="singularity exec /crex/proj/staff/pmitev/nobackup/sbin/qemu-utils.sif qemu-img"


TMP_DIR=$(mktemp -d) && \
cd ${TMP_DIR} && echo "TMP_DIR: "${TMP_DIR} && \
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2111.qcow2c && \
${CMD_qemu_cmd} convert -p -f qcow2 -O raw CentOS-7-x86_64-GenericCloud-2111.qcow2c  CentOS-7.raw && \
IMAGE_NAME=$(date -r CentOS-7.raw +"Centos-7 - %Y.%m.%d") && \
openstack image create --min-disk 20 --private --file CentOS-7.raw "${IMAGE_NAME}" && \
cd -

