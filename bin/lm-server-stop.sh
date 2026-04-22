#!/bin/bash

apptainer exec instance://lm /home/pmitev/.lmstudio/bin/lms server stop

apptainer instance stop lm

