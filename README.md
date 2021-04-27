# Snakemake workflow: dna-seq-deepvariant-glnexus-variant-calling

[![Snakemake](https://img.shields.io/badge/snakemake-≥6-brightgreen.svg)](https://snakemake.bitbucket.io)
[![Build Status](https://travis-ci.org/snakemake-workflows/dna-seq-deepvariant-glnexus-variant-calling.svg?branch=master)](https://travis-ci.org/snakemake-workflows/dna-seq-deepvariant-glnexus-variant-calling)

This is a Snakemake pipeline implementing the [multi-sample variant calling with DeepVariant and GLnexus](https://github.com/google/deepvariant/blob/master/docs/trio-merge-case-study.md). It also allows for single-sample variant calling, and creating a merged vcf containing both individual call sets and merged call sets.

## Authors

* Nikos Tsardakas Renhuldt (@nikostr)

## Usage

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and, if available, its DOI (see above).

Of course, also make sure to credit the tools this pipeline uses:


  - R. Poplin et al., “A universal SNP and small-indel variant caller using deep neural networks,” Nat Biotechnol, vol. 36, no. 10, pp. 983–987, Nov. 2018, doi: 10.1038/nbt.4235.
  - T. Yun, H. Li, P.-C. Chang, M. F. Lin, A. Carroll, and C. Y. McLean, “Accurate, scalable cohort variant calls using DeepVariant and GLnexus,” Bioinformatics, vol. 36, no. 24, pp. 5582–5589, Apr. 2021, doi: 10.1093/bioinformatics/btaa1081.
  - H. Li, “Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM,” arXiv:1303.3997 [q-bio], May 2013, Accessed: Apr. 27, 2021. [Online]. Available: http://arxiv.org/abs/1303.3997.
  - A. D. Yates et al., “Ensembl 2020,” Nucleic Acids Research, p. gkz966, Nov. 2019, doi: 10.1093/nar/gkz966.
  - S. Chen, Y. Zhou, Y. Chen, and J. Gu, “fastp: an ultra-fast all-in-one FASTQ preprocessor,” Bioinformatics, vol. 34, no. 17, pp. i884–i890, Sep. 2018, doi: 10.1093/bioinformatics/bty560.
  - S. Andrews, FastQC: A Quality Control tool for High Throughput Sequence Data. .
  - O. Tange, Gnu Parallel 20150322 ('Hellwig’). Zenodo, 2015.
  - P. Ewels, M. Magnusson, S. Lundin, and M. Käller, “MultiQC: summarize analysis results for multiple tools and samples in a single report,” Bioinformatics, vol. 32, no. 19, pp. 3047–3048, Oct. 2016, doi: 10.1093/bioinformatics/btw354.
  - J. Reback et al., pandas-dev/pandas: Pandas 1.2.4. Zenodo, 2021.
  - F. Mölder et al., “Sustainable data analysis with Snakemake,” F1000Res, vol. 10, p. 33, Apr. 2021, doi: 10.12688/f1000research.29032.2.
  - P. Danecek et al., “Twelve years of SAMtools and BCFtools,” GigaScience, vol. 10, no. 2, p. giab008, Jan. 2021, doi: 10.1093/gigascience/giab008.

### Step 1: Obtain a copy of this workflow

1. Create a new github repository using this workflow [as a template](https://help.github.com/en/articles/creating-a-repository-from-a-template).
2. [Clone](https://help.github.com/en/articles/cloning-a-repository) the newly created repository to your local system, into the place where you want to perform the data analysis.

### Step 2: Configure workflow

Configure the workflow according to your needs via editing the files in the `config/` folder. Adjust `config.yaml` to configure the workflow execution. The config files `samples.tsv`, `units.tsv`, and `joint_calling_groups.tsv` contain the following sample information:

- `sample.tsv` lists the samples.
- `units.tsv` lists the read sets for each sample, with one set of reads for each `sample_id-unit`. Note that `sample_id-unit` combinations should be unique.
- `joint_calling_groups.tsv` groups samples for joint calling. Note that jointly called samples will be named with the format `group:sample_id` in the GLnexus output and in the final `all.bcf` file.

### Step 3: Install Snakemake

Install Snakemake using [conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html):

    conda create -c bioconda -c conda-forge -n snakemake snakemake

For installation details, see the [instructions in the Snakemake documentation](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html).

### Step 4: Execute workflow

Activate the conda environment:

    conda activate snakemake

Test your configuration by performing a dry-run via

    snakemake --use-conda -n

Execute the workflow locally via

    snakemake --use-conda --cores $N

using `$N` cores or run it in a cluster environment via

    snakemake --use-conda --cluster qsub --jobs 100

or

    snakemake --use-conda --drmaa --jobs 100

If you not only want to fix the software stack but also the underlying OS, use

    snakemake --use-conda --use-singularity

in combination with any of the modes above.
See the [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/executable.html) for further details.

### Step 5: Investigate results

After successful execution, you can create a self-contained interactive HTML report with all results via:

    snakemake --report report.html

This report can, e.g., be forwarded to your collaborators.
An example (using some trivial test data) can be seen [here](https://cdn.rawgit.com/snakemake-workflows/rna-seq-kallisto-sleuth/master/.test/report.html).

### Step 6: Commit changes

Whenever you change something, don't forget to commit the changes back to your github copy of the repository:

    git commit -a
    git push

### Step 7: Obtain updates from upstream

Whenever you want to synchronize your workflow copy with new developments from upstream, do the following.

1. Once, register the upstream repository in your local copy: `git remote add -f upstream git@github.com:snakemake-workflows/dna-seq-deepvariant-variant-calling.git` or `git remote add -f upstream https://github.com/snakemake-workflows/dna-seq-deepvariant-variant-calling.git` if you do not have setup ssh keys.
2. Update the upstream version: `git fetch upstream`.
3. Create a diff with the current version: `git diff HEAD upstream/master workflow > upstream-changes.diff`.
4. Investigate the changes: `vim upstream-changes.diff`.
5. Apply the modified diff via: `git apply upstream-changes.diff`.
6. Carefully check whether you need to update the config files: `git diff HEAD upstream/master config`. If so, do it manually, and only where necessary, since you would otherwise likely overwrite your settings and samples.


### Step 8: Contribute back

In case you have also changed or added steps, please consider contributing them back to the original repository:

1. [Fork](https://help.github.com/en/articles/fork-a-repo) the original repo to a personal or lab account.
2. [Clone](https://help.github.com/en/articles/cloning-a-repository) the fork to your local system, to a different place than where you ran your analysis.
3. Copy the modified files from your analysis to the clone of your fork, e.g., `cp -r workflow path/to/fork`. Make sure to **not** accidentally copy config file contents or sample sheets. Instead, manually update the example config files if necessary.
4. Commit and push your changes to your fork.
5. Create a [pull request](https://help.github.com/en/articles/creating-a-pull-request) against the original repository.

## Testing

Test cases are in the subfolder `.test`. They are automatically executed via continuous integration with [Github Actions](https://github.com/features/actions).

