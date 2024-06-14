# Workflow for nuclear Maximum likelihood tree building


Merge outgroup Typha with ingroup assemblies: 

./concatenate_fasta_file.sh

'''
#!/bin/bash

DIR1="/home/bli283/Deuterocohnia_paper/Hybpiper_output"
DIR2="/home/bli283/Pitcairnia_May_2024/Hybpiper_v1_assembly/outgroup_assemblies"
OUTPUT_DIR="/home/bli283/Deuterocohnia_paper/merged_alignment"

for file in "$DIR1"/*.fasta; do
    
    filename=$(basename "$file")
    
    if [ -f "$DIR2/$filename" ]; then
        cat "$DIR1/$filename" "$DIR2/$filename" > "$OUTPUT_DIR/$filename"
    else
        echo "File $filename does not exist in the outgroup directories"
    fi
done
'''

./mafft.sh

```
#!/bin/bash
for file in *.fasta
do
	name=`basename $file .fasta`
	mafft --maxiterate 5000 --auto --adjustdirectionaccurately --thread 8 --op 3 --leavegappyregion $file > /home/bli283/Deuterocohnia_paper/mafft_alignment/$name.MAFFT.fasta
done
```