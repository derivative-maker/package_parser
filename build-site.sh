#!/bin/bash

# This script is for building and testing the site locally.

OS_TYPE=$1
OUTPUT_PATH=$2
WORKDIR=$(pwd)
set -e

main() {
  check_dependencies
  generate_markdown
  generate_html
}

check_dependencies() {
  git checkout main
  git pull origin main
  ruby --version
  gem install bundler
  echo "Ruby and Bundler installed successfully"
  check_os_content
}

generate_markdown() {
  ruby runner.rb $OS_TYPE ../$OS_TYPE-repository  
  cp -r ./docs ../$OS_TYPE-packages/docs
}

generate_html() {
  cd ../$OS_TYPE-packages
  git checkout main
  git pull origin main
  bundle install
  bundle exec jekyll build
  write_html
}

write_html() {
  cd $WORKDIR
  if [ ! -d "$OUTPUT_PATH" ]; then
    rm -rf $OUTPUT_PATH
  fi

  mkdir $OUTPUT_PATH
  mv ../$OS_TYPE-packages/_site $OUTPUT_PATH
}

check_os_content() {
  if [ "$OS_TYPE" == "whonix" ]; then
    if [ ! -d "../$OS_TYPE-repository" ]; then
       echo "../$OS_TYPE-repository does not exist in the parent directory. See README for more info." >&2
       exit 1
    elif [ ! -d "../$OS_TYPE-packages" ]; then
       echo "../$OS_TYPE-packages does not exist in the parent directory. See README for more info." >&2
       exit 1
    else
      echo "$OS_TYPE OS dependencies installed"
    fi
  elif [ "$OS_TYPE" == "kicksecure" ]; then
    if [ ! -d "../$OS_TYPE-repository" ]; then
       echo "../$OS_TYPE-repository does not exist in the parent directory. See README for more info." >&2
       exit 1
    elif [ ! -d "../$OS_TYPE-packages" ]; then
       echo "../$OS_TYPE-packages does not exist in the parent directory. See README for more info." >&2
       exit 1
    else
      echo "$OS_TYPE OS dependencies installed"
    fi
  else
    echo "Invalid OS_TYPE supplied. Accepted options are 'whonix' or 'kicksecure'" >&2
    exit 1
  fi
}

main
