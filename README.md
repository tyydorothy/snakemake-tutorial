# Snakemake Tutorial

This repository follows snakemake tutorial provided by Snakemake Documentation version 9.16.3. This markdown will mainly mark down the bash commands.


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



### Basic: An example workflow

Step one:
 - create input and output files before running commands
 - run commands:`snakemake -np mapped_reads/A.bam`
