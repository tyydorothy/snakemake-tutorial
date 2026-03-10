### Snakemake rule

rule bwa_map:
  input:
    "data/genome.fa",
    "data/samples/A.fastq"
  output:
    "mapped_reads/A.bam"
  shell:
    "bwa mem {input} | samstools view -Sb - > {output}"


 