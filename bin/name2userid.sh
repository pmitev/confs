#!/bin/bash

#last | awk '{d[$1]++} END{for(i in d) print i}' | xargs -n1 getent passwd | grep -i $1

sacctmgr -n list user format=user | xargs -n1 getent passwd | grep -i $1

