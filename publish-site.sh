#!/bin/bash

# ----------------------------- USAGE ----------------------------------------
# ./publish-site.sh whonix ../whonix-repository ../whonix-packages
# ./publish-site.sh kicksecure ../kicksecure-repository ../kicksecure-packages
# ----------------------------------------------------------------------------

set -x
set -e
set -o nounset

OS_TYPE="$1"
REPOSITORY_PATH="$2"
GENERATOR_PATH="$3"

main() {
  sanity_tests
  generate_markdown
  stage_changes
  handle_ci
}

sanity_tests() {
  test -d "$REPOSITORY_PATH"
  test -d "$GENERATOR_PATH"
}

generate_markdown() {
  ruby runner.rb "$OS_TYPE" "$REPOSITORY_PATH"
  PARSERDIR=$(pwd)
  if ! echo "$PARSERDIR" | grep -q package_parser ; then
    exit 1
  fi
  test -d "$PARSERDIR"
}

stage_changes() {
  cd "$GENERATOR_PATH"
  git checkout main
  git reset --hard origin/main
  rm -rf "$GENERATOR_PATH/docs"
  mv "$PARSERDIR/docs" "$GENERATOR_PATH/docs"
  if git status >/dev/null ; then
    echo "No changes to commit"
    exit 0
  fi
}

handle_ci() {
  git add .
  git commit --no-gpg-sign -m "Update packages at $(date)"
  git push origin main
}

main
