# SAM NM distribution
Reads distribution by NM tag in the SAM alignment file.


Sample usage:

```sh
# Get Mapping Identity values distributed by groups for each SAM-alignment file in current directory
find -maxdepth 1 -type f -name "*.sam" -exec sh -c 'gawk -v groups=1 -f ~/scripts/SAM-NM-distribution/samNMdistr.awk {} > $(basename {} .sam)-MIgroups.txt' \;
# Get GC-content distributed by Mapping Identity groups for each SAM-alignment file in current directory
find -maxdepth 1 -type f -name "*.sam" -exec sh -c 'gawk -v groups=1 -v gc=1 -f ~/scripts/SAM-NM-distribution/samNMdistr.awk {} > $(basename {} .sam)-MIgroupsGC.txt' \;
# Sort content of txt files by first column
find -maxdepth 1 -type f -name "*.txt" -exec bash -c '(read -r; printf "%s\n" "$REPLY"; sort -k1V) < {} > $(basename {} .txt)-sort.txt' \;
# Delete txt files except those which name has a "-sort"
find -maxdepth 1 -type f \( -iname "*.txt" ! -iname "*-sort*.txt" \) -exec rm {} \;
# Join all sorted txt files
~/scripts/rjoin.sh *-MIgroups-sort.txt > join-MIgroups.txt
```


Sample results:

|name	     |./sample1.sam|     |     |     |./sample2.sam|     |     |     |
|:---------|----:|----:|----:|----:|----:|----:|----:|----:|
|Mapping identity|98-100%|95-100%|91-100%|All|98-100%|95-100%|91-100%|All|
|CM000663.2|19317|20973|21774|22456|19170|20860|21649|22319|
|CM000664.2|18242|19472|20228|21186|18172|19306|20092|21017|
|CM000665.2|15205|16281|16987|17544|15168|16267|16976|17519|
|CM000666.2|14556|15698|16847|18393|14419|15529|16696|18322|
|CM000667.2|13621|14646|15649|16429|13741|14868|15861|16648|
|CM000668.2|12722|13529|14023|14441|12728|13523|14015|14434|
|CM000669.2|12108|12917|13438|13959|11879|12648|13151|13636|
|CM000670.2|11288|12001|12400|12744|11212|11874|12269|12671|
|CM000671.2|9352|10019|10451|10809|9236|9871|10326|10718|
|CM000672.2|10450|11360|12087|13227|10515|11402|12173|13328|
|CM000673.2|10457|11152|11587|11926|10219|10893|11336|11690|
|CM000674.2|10303|10910|11343|11707|10558|11194|11623|12004|
|CM000675.2|7272|7752|8030|8263|7404|7854|8109|8302|
|CM000676.2|6665|7124|7428|7700|6866|7356|7653|7921|
|CM000677.2|6739|7231|7500|7768|6605|7054|7318|7569|
|CM000678.2|6797|7402|7751|8083|6820|7484|7840|8234|
|CM000679.2|6433|7037|7432|8108|6586|7151|7562|8230|
|CM000680.2|6455|6906|7199|7427|6347|6805|7145|7367|
|CM000681.2|4637|5095|5385|5664|4518|4964|5214|5453|
|CM000682.2|5069|5590|5943|6445|5287|5811|6212|6743|
|CM000683.2|4462|5085|5489|5965|4456|5072|5465|5920|
|CM000684.2|3514|3891|4096|4355|3556|3981|4228|4489|
|CM000685.2|11902|12570|12988|13332|11650|12285|12730|13099|
|CM000686.2|323|474|791|1550|332|523|865|1572|
