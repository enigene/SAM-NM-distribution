# SAM NM distribution v1.1, 14 Mar 2015
# Reads per reference distribution by NM tag.
# v1.0, 20 Feb 2015 - Initial release
# v1.1, 14 Mar 2015 - Added group option, fixed errors
#
# Usage: gawk -v groups=1 -f samNMdistr.awk input.sam > output.txt

BEGIN {
  pList = "100,99,98,97,96,95,94,93,92,91,<=90";
  pListLen = split(pList, pListA, ",");

  pGroupList = "98,95,91,All";
  pGroupListLen = split(pGroupList, pGroupListA, ",");
}

!/^@/ && ($3!="*") {
  RNAME = $3;
  SEQLen = length($10);
  NMTag = substr($(NF-2), 6);

  percBaseAligned = sprintf("%.f", ((SEQLen - NMTag) * 100) / SEQLen);

  if (groups) {
    for (i in pGroupListA) {
      if (percBaseAligned+0 >= pGroupListA[i]+0) {
        a[RNAME][pGroupListA[i]]++;
      }
    }
  } else {
    if (percBaseAligned+0 < pListA[pListLen-1]+0) {
      percBaseAligned = "<=90";
    }
    a[RNAME][percBaseAligned]++;
  }
}

END {
  printf("name\t");
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
