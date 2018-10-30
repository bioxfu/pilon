. init.sh
mkdir index
mkdir bam
mkdir asm

#### Correction Round 1
bowtie2-build --threads 10 $GENOME index/$NAME.origin
bash -c "bowtie2 -p 20 -x index/$NAME.origin -1 $READ1 -2 $READ2 | samtools view -Shub -F 4 | samtools sort - -o bam/$NAME.round1.bam"
samtools index bam/$NAME.round1.bam
java -Xmx1024G -jar ~/pilon/pilon-1.22.jar --threads 20 --genome $GENOME --frags bam/$NAME.round1.bam --outdir asm --output $NAME.round1 --changes

#### Correction Round 2
bowtie2-build --threads 10 asm/$NAME.round1.fasta index/$NAME.round1
bash -c "bowtie2 -p 20 -x index/$NAME.round1 -1 $READ1 -2 $READ2 | samtools view -Shub -F 4 | samtools sort - -o bam/$NAME.round2.bam"
samtools index bam/$NAME.round2.bam
java -Xmx1024G -jar ~/pilon/pilon-1.22.jar --threads 20 --genome asm/$NAME.round1.fasta --frags bam/$NAME.round2.bam --outdir asm --output $NAME.round2 --changes

#### Correction Round 3
bowtie2-build --threads 10 asm/$NAME.round2.fasta index/$NAME.round2
bash -c "bowtie2 -p 20 -x index/$NAME.round2 -1 $READ1 -2 $READ2 | samtools view -Shub -F 4 | samtools sort - -o bam/$NAME.round3.bam"
samtools index bam/$NAME.round3.bam
java -Xmx1024G -jar ~/pilon/pilon-1.22.jar --threads 20 --genome asm/$NAME.round2.fasta --frags bam/$NAME.round3.bam --outdir asm --output $NAME.round3 --changes

#### Correction Round 4
bowtie2-build --threads 10 asm/$NAME.round3.fasta index/$NAME.round3
bash -c "bowtie2 -p 20 -x index/$NAME.round3 -1 $READ1 -2 $READ2 | samtools view -Shub -F 4 | samtools sort - -o bam/$NAME.round4.bam"
samtools index bam/$NAME.round4.bam
java -Xmx1024G -jar ~/pilon/pilon-1.22.jar --threads 20 --genome asm/$NAME.round3.fasta --frags bam/$NAME.round4.bam --outdir asm --output $NAME.round4 --changes

#### Summary
echo -e 'round1\tunmapped\t\nround1\tunique_mapped\t\nround1\tmultiple_mapped\t' >  tmp1
echo -e 'round2\tunmapped\t\nround2\tunique_mapped\t\nround2\tmultiple_mapped\t' >> tmp1
echo -e 'round3\tunmapped\t\nround3\tunique_mapped\t\nround3\tmultiple_mapped\t' >> tmp1
echo -e 'round4\tunmapped\t\nround4\tunique_mapped\t\nround4\tmultiple_mapped\t' >> tmp1
cat nohup.out | grep 'aligned concordantly'|grep '('|awk '{print $1" "$2}' > tmp2
paste tmp1 tmp2 > mapping_summary.tsv
rm tmp1 tmp2
