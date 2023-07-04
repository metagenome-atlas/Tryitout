#!/usr/bin/env bash
set -eo pipefail

conda --version
conda config --set channel_priority strict

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda install -y mamba


## download test reads
if [ -d "test_reads" ] ;
then
echo "test_reads already downloaded"

else

wget https://zenodo.org/record/3992790/files/test_reads.tar.gz
tar -xzf test_reads.tar.gz
rm -r test_reads.tar.gz

fi


echo "Memory usage is"
du -h -d1 .


echo "> contig_1\nAAAAAAAAAAATTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT" > host_genome.fasta


echo "finished setup"


mamba init
