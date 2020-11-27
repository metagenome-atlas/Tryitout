#!/usr/bin/env bash
set -e

## install in docker with python 3
# docker pull conda/miniconda3
# docker run -i -t conda/miniconda3 /bin/bash

# databases can be replaced with a shared location
db_dir=$HOME/databases

this_folder=$(pwd)

mkdir -p $db_dir
cp human_genome.fasta $db_dir

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
conda init bash
# install python3.6 in base environment
mamba install python=3.6

# install dependencies in env
mamba env update -n base -f part2/jupyter_env.yaml


#install nano if not available
mamba install -y nano wget

# install metagenome-atlas in its own environemnt
mamba create -n adminenv metagenome-atlas

source activate adminenv

atlas --version

nano --version

# set up profile for each user
mkdir -p ~/.config/snakemake/
cp -r profile ~/.config/snakemake/Demo

#copy script
cp get_part2.sh ~

# go Home
cd

# get example data
wget https://zenodo.org/record/3992790/files/test_reads.tar.gz
tar -xzf test_reads.tar.gz

rm -f test_reads.tar.gz # id this deleted by defautl?

echo "Test reads memory usage is"
du -h -d1 test_reads

snakemake_args=" -w working_dir --profile Demo -p "


atlas init -w working_dir --db-dir $db_dir test_reads

cat working_dir/samples.tsv


# run atlas this installs software via conda
atlas run assembly  $snakemake_args

atlas run genecatalog  $snakemake_args

atlas run binning  $snakemake_args

#set +e # might trow an error in rule maxbin
#atlas run binning  $snakemake_args
#set -e

# clean up so participants can restart from the beginning
rm -r working_dir

# remove environment so it will be installed again
qc_env=$(grep pigz  $db_dir/conda_envs/*.yaml | cut -f1 -d'.')
rm -r $qc_env

conda deactivate
unset CONDA_ALWAYS_YES
echo "finished setup"

echo "Software memory usage is "
du -h -d1 $db_dir


# remove folder
echo "remove $this_folder"
rm -r $this_folder
