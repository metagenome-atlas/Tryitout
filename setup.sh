#!/usr/bin/env bash


# python version should be 3.6 or 3.7

set -e

# setupt conda and mamba
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

conda install -y mamba

# install metagenome-atlas
mamba install -y metagenome-atlas

atlas --version


# get example data
wget https://zenodo.org/record/3992790/files/test_reads.tar.gz
tar -xzf test_reads.tar.gz

# set up profile

mkdir ~/.config/snakemake/
mv profile ~/.config/snakemake/Demo

# Todo: rename stub data
atlas init test_reads

cat samples.tsv

atlas run assembly --profile Demo
