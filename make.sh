#!/usr/bin/env bash

# make.sh
#
# Copyright (C) 2020-2025 Kristofer Berggren
# All rights reserved.
#
# See LICENSE for redistribution information.

# exiterr
exiterr()
{
  >&2 echo "${1}"
  exit 1
}

# process arguments
DEPS="0"
BUILD="0"
TESTS="0"
DOC="0"
INSTALL="0"
case "${1%/}" in
  deps)
    DEPS="1"
    ;;

  build)
    BUILD="1"
    ;;

  test*)
    BUILD="1"
    TESTS="1"
    ;;

  doc)
    BUILD="1"
    DOC="1"
    ;;

  install)
    BUILD="1"
    INSTALL="1"
    ;;

  all)
    DEPS="1"
    BUILD="1"
    TESTS="1"
    DOC="1"
    INSTALL="1"
    ;;

  *)
    echo "usage: make.sh <deps|build|tests|doc|install|all>"
    echo "  deps      - install project dependencies"
    echo "  build     - perform build"
    echo "  tests     - perform build and run tests"
    echo "  doc       - perform build and generate documentation"
    echo "  install   - perform build and install"
    echo "  all       - perform all actions above"
    exit 1
    ;;
esac

# deps
if [[ "${DEPS}" == "1" ]]; then
  OS="$(uname)"
  if [ "${OS}" == "Linux" ]; then
    DISTRO="$(lsb_release -i | awk -F':\t' '{print $2}')"
    if [[ "${DISTRO}" == "Ubuntu" ]]; then
      if [[ "$(uname -m)" == "x86_64" ]]; then
        sudo apt update && sudo apt -y install nasm build-essential qemu-system-x86 mkisofs kpartx || exiterr "deps failed (linux), exiting."
      elif [[ "$(uname -m)" == "aarch64" ]]; then
        sudo apt -y install nasm gcc-x86-64-linux-gnu qemu-system-x86 mkisofs kpartx
      else
        exiterr "deps failed (unsupported arch $(uname -m)), exiting."
      fi
    else
      exiterr "deps failed (unsupported linux distro ${DISTRO}), exiting."
    fi
  elif [ "${OS}" == "Darwin" ]; then
    true || exiterr "deps failed (mac), exiting."
  else
    exiterr "deps failed (unsupported os ${OS}), exiting."
  fi
fi

# build
if [[ "${BUILD}" == "1" ]]; then
  if [[ "$(uname -m)" == "x86_64" ]]; then
    ./build.sh -i -y || exiterr "build failed, exiting."
  else
    ./build.sh || exiterr "build failed, exiting."
  fi
fi

# tests
if [[ "${TESTS}" == "1" ]]; then
  true || exiterr "tests failed, exiting."
fi

# doc
if [[ "${DOC}" == "1" ]]; then
  true || exiterr "doc failed, exiting."
fi

# install
if [[ "${INSTALL}" == "1" ]]; then
  true || exiterr "install failed (linux), exiting."
fi

# exit
exit 0
