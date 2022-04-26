#!/bin/bash


a=$(ls -l *_1.fastq.gz | awk '{print $9}' | sed 's/_1.fastq.gz//g' | tr "\n" " ")

# echo $a


REF=/media/bioinfo/Data_1/Preonath_Thesis/Healthy_Data_analysis/Ref_Human/GCF_000001405.39_GRCh38.p13_genomic.fna
mkdir ./Obesity_final_contig
for sra in $a
do
	echo "started running analysis for "${sra}""
	mkdir ${sra}
	
	R1=${sra}_1.fastq.gz
        R2=${sra}_2.fastq.gz
        bwa mem -t 50 $REF $R1 $R2 > ./${sra}/${sra}_bwa.bam
        samtools view -b -f 4 ./${sra}/${sra}_bwa.bam --threads 50 --verbosity 2 > ./${sra}/${sra}_unmap.bam
	samtools bam2fq ./${sra}/${sra}_unmap.bam > ./${sra}/${sra}_unmap.fastq
	awk 'NR%2==1 { print $0 "/1" } ; NR%2==0 { print substr($0,0,length($0)/2) }' ./${sra}/${sra}_unmap.fastq > ./${sra}/${sra}_unmap_1.fastq
	awk 'NR%2==1 { print $0 "/2" } ; NR%2==0 { print substr($0,length($0)/2+1) }' ./${sra}/${sra}_unmap.fastq > ./${sra}/${sra}_unmap_2.fastq
	trimmomatic PE -threads 50 ./${sra}/${sra}_unmap_1.fastq ./${sra}/${sra}_unmap_2.fastq ./${sra}/${sra}_unmap_1_trimmied.fastq ./${sra}/${sra}_unmap_1_trimmied_unpaired.fastq ./${sra}/${sra}_unmap_2_trimmied.fastq ./${sra}/${sra}_unmap_2_trimmied_unpaired.fastq SLIDINGWINDOW:4:30
	megahit -m 0.8 -t 50 -1 ./${sra}/${sra}_unmap_1_trimmied.fastq -2 ./${sra}/${sra}_unmap_2_trimmied.fastq -o ./${sra}/output_${sra}
	mv ./${sra}/output_${sra}/final.contigs.fa ./${sra}/output_${sra}/${sra}_final.contigs.fa

	mv ./${sra}/output_${sra}/${sra}_final.contigs.fa ./Obesity_final_contig
	rm -rf ./${sra}
done;	
