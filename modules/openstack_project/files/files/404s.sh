#!/bin/bash

SOURCE_FILE=$1
OUTPUT_DIR=$2
INTERMEDIATE_FILE=$(mktemp)

# Get just the lines with 404s in them
grep ' 404 ' $SOURCE_FILE | sed -n -e 's/.*"GET \(\/.*\) HTTP\/1\.." 404 .*/\1/p' > $INTERMEDIATE_FILE

if [ -f "$SOURCE_FILE.1" ] ; then
    # We get roughly the last day's worth of logs by looking at the last two
    # log files.
    grep ' 404 ' $SOURCE_FILE.1 | sed -n -e 's/.*"GET \(\/.*\) HTTP\/1\.." 404 .*/\1/p' >> $INTERMEDIATE_FILE
fi

# Process those 404s to count them and return sorted by count
sort $INTERMEDIATE_FILE | uniq -c | sort -rn | grep '\(html\|\/$\)' > $OUTPUT_DIR/$(date +%F).txt

# cleanup
rm $INTERMEDIATE_FILE
find $OUTPUT_DIR -type f -name '*.txt' -mtime +30 -delete
