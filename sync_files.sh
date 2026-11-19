#! /bin/bash

CONTENT_SRC_DIR="$HOME/Documents/Blog/"
CONTENT_TARGET_DIR="$HOME/Projects/zola-site/content"
PROTECTED="_index.md"

IMAGES_SRC_DIR="$HOME/Documents/Blog/images/"
IMAGES_TARGET_DIR="$HOME/Projects/zola-site/static/images"

rsync -av --delete --include "*.md" --exclude ".*" --exclude "images/" $CONTENT_SRC_DIR $CONTENT_TARGET_DIR
rsync -av --delete $IMAGES_SRC_DIR $IMAGES_TARGET_DIR
