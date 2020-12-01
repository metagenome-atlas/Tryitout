# Try out Atlas

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/metagenome-atlas/Tryitout/main)

This repo contains the instruction to setup Metagenome-Atlas with limited resources specified in the profile.
It uses a small test dataset that contain two samples with some small genomes that could be assembled and binned.

The goal is that users can install metagenome-atlas and initialize a new project. Not the whole pipeline can be executed due to the high memory usage and limited resources.  Quality control, assembly, genecatalog and binning (up to CheckM) work.



## Setup

[![CircleCI](https://circleci.com/gh/circleci/circleci-docs.svg?style=svg)](https://circleci.com/gh/metagenome-atlas/Tryitout)


Run the setup.sh script

## Usage

```
mamba install metagenome-atlas
```
