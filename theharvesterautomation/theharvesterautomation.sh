#!/bin/sh

    cat sources.txt | while read source; do theHarvester -d "$1" -b $source -f "${source}_$1";done
    cat *.json | jq -r '.hosts[]' 2>/dev/null | cut -d':' -f 1 | sort -u > "$1_theHarvester.txt"
    cat $1_*.txt | sort -u > $1_subdomains_passive.txt
    cat $1_subdomains_passive.txt | wc -l