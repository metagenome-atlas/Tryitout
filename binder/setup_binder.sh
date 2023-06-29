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





# setupt conda and mamba
conda config --set channel_priority strict
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
export CONDA_ALWAYS_YES="true"


# install metagenome-atlas in its own environemnt
mamba create -n adminenv metagenome-atlas
source activate adminenv
atlas --version
conda deactivate

# uninstall mamba in main env
mamba uninstall -y metagenome-atlas

# go Home
cd

# get example data
echo "Get example data"
wget --quiet https://zenodo.org/record/3992790/files/test_reads.tar.gz
tar -xzf test_reads.tar.gz --directory $db_base_dir
rm -f test_reads.tar.gz

echo "Test reads memory usage is"
du -h -d1 $db_base_dir/test_reads


echo "> contig_1\nAAAAAAAAAAATTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT" > $db_dir/host_genome.fasta



unset CONDA_ALWAYS_YES
echo "finished setup"

echo "Software memory usage is "
du -h -d1 $db_dir


