#!/bin/bash

echo "Cleaning host environment."

function remove_pkg(){
    echo "--- Remove: $@"
    sudo apt remove $@ -y --purge > /dev/null 
}

remove_pkg clang-*-16 clang-*-17 clang-*-18
remove_pkg llvm-16* llvm-17* llvm-18*
remove_pkg gcc-12 gcc-13 gcc-14
remove_pkg g++-12 g++-13 g++-14
remove_pkg mysql-server-8.0 mysql-client-8.0
remove_pkg php8.3 php8.3-*

sudo apt autoremove -y --purge > /dev/null

