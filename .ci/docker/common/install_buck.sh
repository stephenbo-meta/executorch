#!/bin/bash
# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

set -ex

install_ubuntu() {
  apt-get update
  apt-get install -y zstd

  BUCK2=buck2-x86_64-unknown-linux-gnu.zst
  wget -q "https://github.com/facebook/buck2/releases/download/${BUCK2_VERSION}/${BUCK2}"
  zstd -d "${BUCK2}" -o buck2

  chmod +x buck2
  mv buck2 /usr/bin/

  rm "${BUCK2}"
  # Cleanup package manager
  apt-get autoclean && apt-get clean
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}

# Install base packages depending on the base OS
ID=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
case "$ID" in
  ubuntu)
    install_ubuntu
    ;;
  *)
    echo "Unable to determine OS..."
    exit 1
    ;;
esac
