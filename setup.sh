#!/usr/bin/env bash


set -e

# setupt conda and mamba
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge


# if python version not 3.6 use conda Environment
python_version= $(python --version)
if [[ $python_version =~ "3.6" ]]; then
echo "have python 3.6"
else
conda create -n atlasenv python3.6
. activate atlasenv
fi

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




atlas init -w working_dir test_reads
# databases can be replaced with a shared location --db-dir /path/to/databases

cat samples.tsv


# run atlas this installs software via conda
atlas run assembly -w working_dir --profile Demo

atlas run genecaalog -w working_dir --profile Demo

atlas run binning -w working_dir --profile Demo --omit-from download_checkm_data maxbin

set +e # might trow an error in rule maxbin
atlas run binning -w working_dir --profile Demo


# clean up so participants can restart from the beginning

rm -r -w working_dir
