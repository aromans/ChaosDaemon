#!/bin/bash

sudo docker build -t chaos_daemon:latest .

sudo docker run -d -p 5000:5000 chaos_daemon

# ssh -L 1234:0.0.0.0:5000 localhost