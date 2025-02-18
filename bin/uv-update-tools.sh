#!/bin/bash
uv self update
uv tool list | awk '$1 != "-"{print $1}' | xargs -n1 uv tool upgrade
