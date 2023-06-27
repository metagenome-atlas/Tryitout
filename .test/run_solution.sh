#!/usr/bin/env bash
set -eo pipefail

mamba --version



mamba create -y -n atlasenv metagenome-atlas

. activate atlasenv

atlas --version

atlas init --db-dir databases --working-dir WD test_reads


atlas run assembly -w WD -j4 --max-mem 0.9