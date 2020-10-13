#!/usr/bin/env bash
set -e

## install in docker with python 3.6
# docker pull conda/miniconda3
# docker run -i -t conda/miniconda3 /bin/bash

# databases can be replaced with a shared location
db_dir="~/databases"


# test if python 3.6
python_version= $(python --version)
if [[ $python_version =~ "3.6" ]]; then
echo "Found python 3.6"
else
echo "I want 3.6"
exit 1
fi



mkdir -p $db_dir
cp human_genome.fasta $db_dir

# setupt conda and mamba
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge


#mamba is faster version of conda
conda install -y mamba


#install nano if not available
mamba install -y nano

# install metagenome-atlas
mamba install -y metagenome-atlas

atlas --version



# set up profile for each user
mkdir -p ~/.config/snakemake/
mv profile ~/.config/snakemake/Demo

# go Home
cd ~

# get example data
wget https://zenodo.org/record/3992790/files/test_reads.tar.gz
tar -xzf test_reads.tar.gz

rm -f test_reads.tar.gz # id this deleted by defautl?

echo "Test reads memory usage is"
du -h -d1 test_reads



atlas init -w working_dir --db-dir $db_dir test_reads

cat samples.tsv


# run atlas this installs software via conda
atlas run assembly -w working_dir --profile Demo

atlas run genecatalog -w working_dir --profile Demo

atlas run binning -w working_dir --profile Demo --omit-from download_checkm_data maxbin

set +e # might trow an error in rule maxbin
atlas run binning -w working_dir --profile Demo
set -e

# clean up so participants can restart from the beginning
rm -r working_dir

# remove environment so it will be installed again
rm -r $db_dir/conda_envs/0e459907

# unisntall metagenome atlas so participants can install it again
mamba uninstall -y metagenome-atlas

echo "finished setup"

echo "Software memory usage is "
du -h -d1 $db_dir
