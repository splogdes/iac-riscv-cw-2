#!/bin/bash -e

if [[ ! -f "$1" ]]
then
    echo "Error: no such file $1, exiting"
    exit 1
fi

rm -rf ./scripts/assemble/.build 2> /dev/null

mkdir ./scripts/assemble/.build

cp "$1" ./scripts/assemble/.build/source.s

make -C ./scripts/assemble hexfile

if [[ ! -d "./src/generated" ]] 
then
    mkdir ./src/generated
fi

cp ./scripts/assemble/.build/source.s.hex ./src/generated/instructionmemory.tmp.mem

./scripts/build.sh riscv