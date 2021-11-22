#!/usr/bin/env bash
set -eo pipefail

## install in docker with python 3
# docker pull conda/miniconda3
# docker run -i -t conda/miniconda3 /bin/bash

# databases can be replaced with a shared location
db_base_dir="."
db_dir=$db_base_dir/databases

this_folder=$(pwd)

mkdir -p $db_dir


#set langauge locale
#export LC_ALL=C.UTF-8
#export LANG=C.UTF-8



# setupt conda and mamba
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
export CONDA_ALWAYS_YES="true"


#mamba is faster version of conda
conda install -y mamba

#update conda
mamba update -n base -c defaults conda
#conda init bash
# install python3.8 in base environment
mamba install python=3.8


#install nano if not available
mamba install -y nano wget
nano --version

# install metagenome-atlas in its own environemnt
mamba create -n adminenv metagenome-atlas=2.8
source activate adminenv
atlas --version

# go Home
cd

# get example data
echo "Get example data"
wget --quiet https://zenodo.org/record/3992790/files/test_reads.tar.gz
tar -xzf test_reads.tar.gz --directory $db_base_dir
rm -f test_reads.tar.gz

echo "Test reads memory usage is"
du -h -d1 $db_base_dir/test_reads


echo "> contig_1\nAAAAAAAAAAATTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT" > $db_dir/human_genome.fasta


## Test

echo "Run atlas test"
snakemake_args=" -w working_dir -j 2 --resources mem=5 java_mem=5 "


atlas init -w working_dir --db-dir $db_dir $db_base_dir/test_reads

cat working_dir/samples.tsv


echo "run atlas this installs software via conda"
atlas run assembly  $snakemake_args

atlas run genecatalog  $snakemake_args

atlas run binning  $snakemake_args


# clean up so participants can restart from the beginning
rm -r working_dir



conda deactivate
unset CONDA_ALWAYS_YES
echo "finished setup"

echo "Software memory usage is "
du -h -d1 $db_dir


