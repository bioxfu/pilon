### Pilon Correction Workflow
#### Install Pilon
```
## https://github.com/broadinstitute/pilon/releases
cd ~
mkdir pilon
wget https://github.com/broadinstitute/pilon/releases/download/v1.22/pilon-1.22.jar
java -jar pilon-1.22.jar --help
```

#### Initiate the project
```
cp example/init.sh init.sh
# edit and run init.sh file according to your project
. init.sh
```

#### Correction Round 1
```
## Build index of assembly
bowtie2-build --threads 10 $GENOME index/$NAME.origin

## Mapping NGS reads 
nohup bash -c "bowtie2 -p 20 -x index/$NAME.origin -1 $READ1 -2 $READ2 | samtools view -Shub -F 4 | samtools sort - -o bam/$NAME.round1.bam" &
samtools index bam/$NAME.round1.bam

## Run Pilon
java -jar ~/pilon/pilon-1.22.jar --genome $GENOME --frags bam/$NAME.round1.bam --outdir asm --output $NAME.round1 --change
```

#### Correction Round 2
```
## Build index of assembly
bowtie2-build --threads 10 asm/$NAME.round1.fasta index/$NAME.round1

## Mapping NGS reads 
nohup bash -c "bowtie2 -p 20 -x index/$NAME.round1 -1 $READ1 -2 $READ2 | samtools view -Shub -F 4 | samtools sort - -o bam/$NAME.round2.bam" &
samtools index bam/$NAME.round2.bam

## Run Pilon
java -jar ~/pilon/pilon-1.22.jar --genome asm/$NAME.round1.fasta --frags bam/$NAME.round2.bam --outdir asm --output $NAME.round2 --change
```

#### Correction Round 3
```
## Build index of assembly
bowtie2-build --threads 10 asm/$NAME.round2.fasta index/$NAME.round2

## Mapping NGS reads 
nohup bash -c "bowtie2 -p 20 -x index/$NAME.round2 -1 $READ1 -2 $READ2 | samtools view -Shub -F 4 | samtools sort - -o bam/$NAME.round3.bam" &
samtools index bam/$NAME.round3.bam

## Run Pilon
java -jar ~/pilon/pilon-1.22.jar --genome asm/$NAME.round2.fasta --frags bam/$NAME.round3.bam --outdir asm --output $NAME.round3 --change
```


