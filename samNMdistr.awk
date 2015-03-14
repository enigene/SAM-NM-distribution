# SAM NM distribution v1.0, 20 Feb 2015
# Reads per reference distribution by NM tag.
# <=90%; 91%; 92%; 93%; 94%; 95%; 96%; 97%; 98%; 99%; 100%
#
# Usage: gawk -f samNMdistr.awk input.sam > output.txt

BEGIN {
  pList = "100,99,98,97,96,95,94,93,92,91,<=90";
  pListLen = split(pList, pListA, ",");
}

!/^@/&&($3!="*"){
  RNAME = $3;
  SEQLen = length($10);
  NMTag = substr($18, 6);

  percBaseAligned = ((SEQLen - NMTag) * 100) / SEQLen;

  if (percBaseAligned <= 90) {
    percBaseAligned = "<=90";
  }

  a[RNAME][percBaseAligned]++;
}

END {
  printf("name\t");
  for (p=1; p<=pListLen; p++) {
    printf("%s", pListA[p]);
    if (p < pListLen) {
      printf("\t");
    }
  }
  printf("\n");

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
