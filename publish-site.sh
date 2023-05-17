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
  ruby runner.rb "$OS_TYPE" "$REPOSITORY_PATH"
  rm -rf "$GENERATOR_PATH/docs/"*
  mv ./docs/* "$GENERATOR_PATH/docs"
  cd "$GENERATOR_PATH"
  git checkout main
  changes=$(git status | grep -i 'nothing to commit') || true
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
