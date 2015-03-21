# SAM NM distribution v1.2, 15 Mar 2015
# Reads per reference distribution by NM tag.
# v1.0, 20 Feb 2015 - Initial release
# v1.1, 14 Mar 2015 - Added group option, fixed errors
# v1.2, 15 Mar 2015 - Added gc option. Prints GC-content distributed by mapping identity.
#
# Usage: gawk -v groups=1 -v gc=1 -f samNMdistr.awk input.sam > output.txt

BEGIN {
  pList = "100,99,98,97,96,95,94,93,92,91,<=90";
  pListLen = split(pList, pListA, ",");

  pGroupList = "98,95,91,All";
  pGroupListLen = split(pGroupList, pGroupListA, ",");
}

!/^@/ && ($3!="*") {
  RNAME = $3;
  seq = $10;
  SEQLen = length($10);
  NMTag = substr($(NF-2), 6);

  percBaseAligned = sprintf("%.f", ((SEQLen - NMTag) * 100) / SEQLen);

  if (gc) {
    split(seq, seqA, "");
    for (i in seqA) {
      currSeqBasesA[seqA[i]]++;
    }
    currSeqBasesA["AT"] = currSeqBasesA["A"] + currSeqBasesA["T"]+0;
    currSeqBasesA["GC"] = currSeqBasesA["G"] + currSeqBasesA["C"]+0;
  }

  if (groups) {
    for (i in pGroupListA) {
      if (percBaseAligned+0 >= pGroupListA[i]+0) {
        a[RNAME][pGroupListA[i]]++;
        if (gc) {
          b[RNAME][pGroupListA[i]]["AT"] += currSeqBasesA["AT"];
          b[RNAME][pGroupListA[i]]["GC"] += currSeqBasesA["GC"];
        }
      }
    }
  } else {
    if (percBaseAligned+0 < pListA[pListLen-1]+0) {
      percBaseAligned = "<=90";
    }
    a[RNAME][percBaseAligned]++;
    if (gc) {
      b[RNAME][percBaseAligned]["AT"] += currSeqBasesA["AT"];
      b[RNAME][percBaseAligned]["GC"] += currSeqBasesA["GC"];
    }
  }
  delete currSeqBasesA;
}

END {
  printf("%s\t%s", "name", FILENAME);
  if (groups) {
    for (p=1; p<pGroupListLen; p++) {
      printf("\t");
    }
  } else {
    for (p=1; p<pListLen; p++) {
      printf("\t");
    }
  }
  printf("\n");
  printf("Mapping identity\t");
  if (groups) {
    for (p=1; p<=pGroupListLen; p++) {
      printf("%s", pGroupListA[p]);
      if (p < pGroupListLen) {
        printf("-100%\t");
      }
    }
  } else {
    for (p=1; p<=pListLen; p++) {
      printf("%s", pListA[p]);
      if (p < pListLen) {
        printf("%\t");
      }
    }
    printf("%");
  }
  printf("\n");

  if (groups) {
    if (gc) {
      for (r in a) {
        printf("%s\t", r);
        for (p=1; p<=pGroupListLen; p++) {
          atBaseGroup = b[r][pGroupListA[p]]["AT"]+0;
          gcBaseGroup = b[r][pGroupListA[p]]["GC"]+0;
          if (atBaseGroup + gcBaseGroup > 0) {
            gcContent = (gcBaseGroup / (atBaseGroup + gcBaseGroup) * 100);
          } else {
            gcContent = 0.0;
          }
          printf("%.2f", gcContent);
          if (p < pGroupListLen) {
            printf("\t");
          }
        }
        printf("\n");
      }
    } else {
      for (r in a) {
        printf("%s\t", r);
        for (p=1; p<=pGroupListLen; p++) {
          printf("%d", a[r][pGroupListA[p]]);
          if (p < pGroupListLen) {
            printf("\t");
          }
        }
        printf("\n");
      }
    }
  } else {
    if (gc) {
      for (r in a) {
        printf("%s\t", r);
        for (p=1; p<=pListLen; p++) {
          atBaseGroup = b[r][pListA[p]]["AT"]+0;
          gcBaseGroup = b[r][pListA[p]]["GC"]+0;
          if (atBaseGroup + gcBaseGroup > 0) {
            gcContent = (gcBaseGroup / (atBaseGroup + gcBaseGroup) * 100);
          } else {
            gcContent = 0.0;
          }
          printf("%.2f", gcContent);
          if (p < pListLen) {
            printf("\t");
          }
        }
        printf("\n");
      }
    } else {
      for (r in a) {
        printf("%s\t", r);
        for (p=1; p<=pListLen; p++) {
          printf("%d", a[r][pListA[p]]);
          if (p < pListLen) {
            printf("\t");
          }
        }
        printf("\n");
      }
    }
  }
}
