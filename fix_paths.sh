#! /bin/bash

CONTENT_DIR="$HOME/Projects/zola-site/content"

for FILE in "$CONTENT_DIR/*.md"; do
    # Add leading slash to internal link paths
    perl -i -pe 's/\]\(\K(?!https?:\/\/)([[:alnum:]][^)]*)/\/$1/g' $FILE

    # Also remove .md extension from internal links
    perl -i -pe 's/\]\([^)]*?\K\.md(?=\))//g' $FILE
done
