#! /bin/bash

# Copy markdown files from vault
./sync_files.sh

# Fix some internal link formatting
./fix_paths.sh

# Build site
zola build

# Sync files to VPS
./publish_site.sh

printf "Finished deploying site\n"
