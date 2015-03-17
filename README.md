# SAM NM distribution
Reads distribution by NM tag in the SAM alignment file.


Sample usage:

```sh
# Get Mapping Identity values distributed by groups for each SAM-alignment file in current directory
find -maxdepth 1 -type f -name "*.sam" -exec sh -c 'gawk -v groups=1 -f ~/scripts/SAM-NM-distribution/samNMdistr.awk {} > $(basename {} .sam)-MIgroups.txt' \;`
# Get GC-content distributed by Mapping Identity groups for each SAM-alignment file in current directory
find -maxdepth 1 -type f -name "*.sam" -exec sh -c 'gawk -v groups=1 -v gc=1 -f ~/scripts/SAM-NM-distribution/samNMdistr.awk {} > $(basename {} .sam)-MIgroupsGC.txt' \;
# Sort content of txt files by first column
find -maxdepth 1 -type f -name "*.txt" -exec bash -c '(read -r; printf "%s\n" "$REPLY"; sort -k1V) < {} > $(basename {} .txt)-sort.txt' \;
# Delete txt files except those which name has a "-sort"
find -maxdepth 1 -type f \( -iname "*.txt" ! -iname "*-sort*.txt" \) -exec rm {} \;
# Join all sorted txt files
~/scripts/rjoin.sh *-MIgroups-sort.txt > join-MIgroups.txt
```
