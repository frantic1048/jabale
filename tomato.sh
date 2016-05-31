#!/bin/env sh

function tomato_help() {
  echo "Usage: tomato.sh <command>"
  echo "Commands:"
  echo "  help     show this help"
  echo "  build    build Jabale"
  echo "  clean    clean builded stuff"
  echo "  test     build and run tests"
  echo "  tdd      continous build && testing"
  echo "Dependencies:"
  echo "  - inotify-tools"
  echo "  - frantic1048/ctest-chalk"
}

function tomato_build() {
  mkdir -p build;
  cd build;
  cmake ../src/ && make;
  cd ..;
}

function tomato_clean() {
  rm -rf ./build/;
}

function tomato_test() {
  cd build;
  ctest | ctest-chalk;
  cd ..;
}

function tomato_tdd() {
  cd build;
  inotifywait -mqe CLOSE_WRITE ../src/ | tee /dev/tty | while read ; do cmake ../src/ && make && ctest | ctest-chalk ; done;
  cd ..;
}

if [[ -z $1 ]];
then
  tomato_help;
elif [[ $1 == "help" ]]
then
  tomato_help;
elif [[ $1 == "build" ]]
then
  tomato_build;
elif [[ $1 == "clean" ]]
then
  tomato_clean;
elif [[ $1 == "test" ]]
then
  tomato_test;
elif [[ $1 == "tdd" ]]
then
  tomato_build;
  tomato_test;
  tomato_tdd;
fi
