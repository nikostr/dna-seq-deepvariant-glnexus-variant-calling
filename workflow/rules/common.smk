from snakemake.utils import validate
import pandas as pd
import numpy as np
import os

##### load config and sample sheets #####


configfile: "config/config.yaml"


validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_table(config["samples"], dtype=str).set_index(
    ["sample_id", "unit"], drop=False
)
samples.index = samples.index.set_levels(
    [i.astype(str) for i in samples.index.levels]
)  # enforce str in index
validate(samples, schema="../schemas/samples.schema.yaml")

joint_calling_groups = pd.read_csv(config["joint_calling_groups"], sep="\t")
validate(joint_calling_groups, schema="../schemas/joint_calling_groups.schema.yaml")
# List of samples for each joint calling group
joint_calling_group_lists = joint_calling_groups.groupby("group").sample_id.apply(set)

## Helper functions


def get_fastq(wildcards):
    """Get fastq files of given sample-unit."""
    fastqs = samples.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    if len(fastqs) == 2:
        return {"sample": [fastqs.fq1, fastqs.fq2]}
    return {"sample": [fastqs.fq1]}


def is_single_end(sample, unit):
    """Return True if sample-unit is single end."""
    return pd.isnull(samples.loc[(sample, unit), "fq2"])


def get_trimmed_reads(wildcards):
    """Get trimmed reads of given sample-unit."""
    if not is_single_end(**wildcards):
        # paired-end sample
        return expand(
            "results/trimmed/{sample}-{unit}.{group}.fastq.gz",
            group=[1, 2],
            **wildcards
        )
    # single end sample
    return "results/trimmed/{sample}-{unit}.fastq.gz".format(**wildcards)


def get_bwa_index(wildcards):
    assert config["bwa_mem"]["wrapper"] in [
        "bwa/mem",
        "bwa-mem2/mem",
    ], "BWA-MEM wrapper must be either bwa/mem or bwa-mem2/mem"
    if config["bwa_mem"]["wrapper"] == "bwa/mem":
        return "resources/genome.fasta.sa"
    else:
        return "resources/genome.fasta.0123"
