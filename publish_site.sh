#! /bin/bash

SRC_DIR="$HOME/Projects/zola-site/public/"

rsync -av --delete $SRC_DIR nvps:/var/www/nate-site
