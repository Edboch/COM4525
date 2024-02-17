#!/bin/bash

link_hook() {
  chmod +x .hooks/$1
  ln -s $(readlink -f .hooks/$1) ./.git/hooks/$1
}

link_hook pre-commit

