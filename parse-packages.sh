#!/bin/bash

OS=$1
REPO_DIR=$2

main() {
  ruby ./runner.rb $OS $REPO_DIR
}

main
