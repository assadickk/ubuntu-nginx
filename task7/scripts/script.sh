#!/bin/bash

ssh -i "/home/trainee-key-Virginia" ubuntu@10.0.20.229 \
  'sudo apt-get update ; sudo apt-get upgrade ssh -y && echo packages upgrade done || echo packages upgrade errored'


