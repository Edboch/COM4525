#!/bin/bash

# Delete all pre-existing symbolic links
#find -L .git/hooks/ -xtype l -delete
find .git/hooks -type l -delete

link_hook() {
  chmod +x .hooks/$1
  ln -s $(readlink -f .hooks/$1) ./.git/hooks/$1
}

link_hook pre-push

