#!/bin/bash

kill -9 $(lsof -i:8000 -t)

nohup python -m http.server --directory build/html > log.out 2>&1 &