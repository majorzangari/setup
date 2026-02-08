#!/usr/bin/env bash

echo "@@@ Updating and installing packages"
sudo pacman -Syu --needed - < packages.txt

echo "@@@ Setup complete"
