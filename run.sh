#!/bin/bash


set -eux
fpc -Fu./csfml_fpc/binding main.pas
./main