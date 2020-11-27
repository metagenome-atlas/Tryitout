#!/usr/bin/env bash
set -e

#download and copy files to PArt2 folder
git clone https://github.com/metagenome-atlas/Tutorial.git

mkdir Part2
mv Tutorial/R Tutorial/Python Tutorial/Example Part2
rm -rf Tutorial

# Remove output from Jupyter notebooks
cd Part2
jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace Python/Analyis_genome_abundances.ipynb
jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace Python/Differential_abundance.ipynb
jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace Python/Draw_Tree.ipynb
