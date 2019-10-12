#!/bin/zsh
# Standalone Script to install the gRPC protobuf compiler

sudo apt-get install autoconf automake libtool curl make g++ unzip --yes
if [ ! -x "$(command -v protoc)" ]; then
  cd ~
  curl -O -J -L https://github.com/protocolbuffers/protobuf/releases/download/v3.10.0/protobuf-all-3.10.0.tar.gz
  tar -xvf protobuf-all-3.10.0.tar.gz
  cd protobuf-3.10.0
  ./configure
  make
  make check
  sudo make install
  sudo ldconfig # refresh shared library cache
else 
  exercism upgrade
fi