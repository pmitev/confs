export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y default-jre less mc python3-pip python3-setuptools &>>  /tmp/install.log && \
cd /usr/bin && wget https://github.com/nextflow-io/nextflow/releases/download/v24.10.4/nextflow-24.10.4-dist  &>>  /tmp/install.log && \
chmod a+rx /usr/bin/nextflow-24.10.4-dist && ln -s nextflow-24.10.4-dist nextflow &>>  /tmp/install.log &&\
python3 -m pip install --no-cache-dir --break-system-packages nf-core &>>  /tmp/install.log
cd /tmp/ && wget https://github.com/apptainer/apptainer/releases/download/v1.3.5/apptainer_1.3.5_amd64.deb && apt install -y ./apptainer_1.3.5_amd64.deb &>>  /tmp/install.log
echo "### Done ###" &>>  /tmp/install.log
