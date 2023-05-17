#!/bin/bash

# ----------------------------- USAGE ----------------------------------------
# ./publish-site.sh whonix ../whonix-repository ../whonix-packages
# ./publish-site.sh kicksecure ../kicksecure-repository ../kicksecure-packages
# ----------------------------------------------------------------------------

set -e
set -o nounset

OS_TYPE="$1"
REPOSITORY_PATH="$2"
GENERATOR_PATH="$3"

main() {
  generate_markdown
  stage_changes
  handle_ci
}

generate_markdown() {
  ruby runner.rb "$OS_TYPE" "$REPOSITORY_PATH"
  PARSERDIR=$(pwd)
  cd "$GENERATOR_PATH"
}

stage_changes() {
  git checkout main
  git reset --hard origin/main
  rm -rf ./docs/*
  mv $PARSERDIR/docs/* ./docs
  changes=$(git status | grep -i 'nothing to commit') || true
}

handle_ci() {
  if [[ -z "$changes" ]]; then
    git add .
    git commit --no-gpg-sign -m "Update packages at $(date)"
    git push origin main
  else
    echo "No changes to commit"
    exit 0
  fi
}

main
