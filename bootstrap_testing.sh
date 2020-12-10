#!/bin/bash

sudo apt -y --install-recommends install virtualenv build-essential python3-pip

rm testing_env -rf
virtualenv testing_env --python=python3
. testing_env/bin/activate
pip install -r testing-requirements.txt