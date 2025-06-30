#!/bin/bash -eu

DIRECTORY_TO_OBSERVE="."      # might want to change this
function block_for_change {
  inotifywait --recursive \
    --event modify,move,create,delete \
    $DIRECTORY_TO_OBSERVE
}

BUILD_SCRIPT=build.sh          # might want to change this too
function run {

  (
    make all
  ) || true
}


run
while block_for_change; do
  (
    run

  )

done
