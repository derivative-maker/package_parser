#!/bin/bash

# USAGE_EXAMPLE: ./build-site.sh whonix ../whonix-repository/
OS=$1
REPO_DIR=$2

main() {
  prepare_dependencies
  ruby runner.rb $OS $REPO_DIR
  build_site  
}

prepare_dependencies() {
  ruby --version
  git --version
  echo "Please make sure to install Ruby 3 and git :)"
  gem install bundler jekyll
}

build_site() {
  git clone https://github.com/$OS/$OS-packages
  cd ./$OS-packages
  git pull origin main
  mkdir docs
  cp -r ../docs/ docs
  bundle exec jekyll build
  mv _site ../$OS-packages-site
  cd ../
  rm -rf $OS-packages/
}

main
