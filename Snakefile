##### Snakemake rule
# applies rule from top-down
# job --> the application of a rule to generate a set of output files
#
# To run a job:
### 1. snakemake first identify the input file 
### 2. find where/which job this (or these) file(s) can be generated
### 3. this run recursively
### 4. results a directed acyclic graph (DAG)




### Python 
# for Step 5
SAMPLES = ["A","B","C","D","E"]




### Step 7: Adding target rule
rule all:
  input:
      "plots/quals.svg"

# snakemake automatically execute the top rule if not specified



### Step 0: Generate Random Samples (Extra Steps)

rule gen_random_fasta:
  output:
    fasta="data/genome.fa",
    fasta_idx="data/genome.fa.bwt"
  
  shell:
    "python scripts/fastq_generator.py generate_fasta Chr1 10000 > {output.fasta} && "
    "bwa index {output.fasta}"



rule gen_random_fastq:
  output:
    "data/samples/{sample}.fastq"
  shell:
    "python scripts/fastq_generator.py generate_mapped_fastq_SE data/genome.fa 100 3 > {output}"





### Step 1: Mapping Reads

rule bwa_map:
  input:
    genome = "data/genome.fa",
    reads = "data/samples/A.fastq"
  output:
    "mapped_reads/A.bam"
  shell:
    "bwa mem {input.genome} {input.reads} | samtools view -Sb - > {output}"





### Step 2: Generalising the read mapping rule

rule bwa_map_2:
  input:
    genome = "data/genome.fa",
    sample = "data/samples/{sample}.fastq"
  output:
    "mapped_reads/{sample}.bam"
  shell:
    "bwa mem {input.genome} {input.sample} | samtools view -Sb - > {output}"





### Step 3: Sorting read alignments

rule samtools_sort:
  input:
    "mapped_reads/{sample}.bam"
  output:
    "sorted_reads/{sample}.bam"
  shell:
   "samtools sort -T {output}.tmp -O bam {input} > {output}"

# Issues in tutorial sample #1
# "samtools sort -T sorted_reads/{wildcards.sample} " 
#  -> "sorted_reads" is hard code; need to update manually if path change
#  -> {wildcards.sample} refers to {sample} wildcard defined at input  
#  -> redundant





### Step 4: Indexing read alignments

rule samtools_index:
  input:
    "sorted_reads/{sample}.bam"
  output:
    "sorted_reads/{sample}.bam.bai"
  shell:
    "samtools index {input}"





### Step 5: Variant Calling
rule bcftools_call:
  input:
    fa="data/genome.fa",
    bam=expand("sorted_reads/{sample}.bam", sample=SAMPLES),
    bai=expand("sorted_reads/{sample}.bam.bai", sample=SAMPLES)
  output:
    "calls/all.vcf"
  shell:
    "bcftools mpileup -f {input.fa} {input.bam} | " # long shell commands can be split into two
    "bcftools call -mv - > {output}"

### expand()
# snakemake built-in function
# generate list of strings by filling in wildcards value
# SAMPLES = ["A","B","C"] --> ["sorted_reads/A.bam","sorted_reads/B.bam","sorted_reads/C.bam"]




### Step 6: Using scripts (Python, R)
rule plot_quals:
  input:
    "calls/all.vcf"
  output:
    "plots/quals.svg"
  script:
    "scripts/plot-quals.py"





