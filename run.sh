#!/bin/bash


set -eux
fpc -Fu./csfml_fpc/binding -Fu./core -Fu./core/types main.pas
./main