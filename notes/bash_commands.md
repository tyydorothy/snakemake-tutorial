This is a note for bash commands used in the tutorial.

### Set Up

 - OS: Mac
 - Terminal: iTerm/Homebrew

Global Environment:

`brew install miniforge <- Conda Package manager`

`conda init zsh`

<br>

Project Directory (git initialised):

<br>

Create conda environment:
`conda create -c conda-forge -c bioconda -c nodefaults -n myproj snakemake`
`conda activate myproj`

<br>

Alternatively:
`conda create -n myproj python=3.14`
`conda activate myproj`
`conda install -c conda-forge -c bioconda -c nodefaults snakemake pandas`

<br>

Create `environment.yaml` for reproducibility
`conda env export --from-history > environment.yaml`

<br>

Search through `bioconda` to install `samtools` and `bwa` : 
`conda -c bioconda install samtools bwa`



### Basic: An example workflow

##### Step 1: Mapping Reads
 - `$ snakemake -np mapped_reads/A.bam`
    - `-n`: dry run
    - `-p`: print the resulting shell command
 - `$ snakemake --cores 1 mapped_reads/A.bam`
    - --cores 1 --> use 1 core for this job
 - Job will be executed only when: 
    - output file does not exist, or
    - one of the input file is ***newer*** than one of the output file

##### Step 2: Generalise the rule
 - `$ snakemake -np mapped_reads/B.bam`
 - `$ snakemake -p --cores 1 mapped_reads/{A,B,C,D}.bam` 
    - `{ }` Brace expansion of bash --> produce multiple outputs at once
    - job execution criteria same as above. (*A.bam* will not be produced again)

##### Step 3: Sorting Read alignments
 - `$ snakemake -np sorted_reads/B.bam`

##### Step 4: Indexing Reads Alignments and visualising the DAG
 - `$ snakemake sorted_reads/{A,B}.bam.bai --dag | dot -Tsvg > dag.svg`
   - `--dag`: visualise DAG as DOT format text; all jobs suppressed
   - `dot` is a command provided by Graphviz
 -  `$ open dag.svg`
 - DAG graph 
   - to illustrate DAG of each output {A.bam.bai, B.bam.bai}
   - Solid box -> job need to be run (output missing or outdated);
   - Dotted box -> job completed (output up-to-date)

##### Step 7: Adding a target rule
 - `$ snakemake --cores 1 --forcerun`
   - `forcerun`: force all execution, neglecting whether files are up-to-date or not

