from snakemake.utils import validate
import pandas as pd
import os

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

##### load config and sample sheets #####

configfile: "config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], sep="\t").set_index("sample", drop=False)
samples.index.names = ["sample_id"]
validate(samples, schema="../schemas/samples.schema.yaml")

joint_calling_groups = pd.read_csv(config["joint_calling_groups"], sep="\t")
validate(joint_calling_groups, schema="../schemas/joint_calling_groups.schema.yaml")
# List of samples for each joint calling group
joint_calling_group_lists = (joint_calling_groups
        .groupby('group')
        .sample_id
        .apply(list))


## Helper functions

def get_fastq(wildcards):
    """Get fastq files of given sample-unit."""
    fastqs = units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    if len(fastqs) == 2:
        return {"sample": [fastqs.fq1, fastqs.fq2]}
    return {"sample": [fastqs.fq1]}


def get_trimmed_reads(wildcards):
    """Get trimmed reads of given sample-unit."""
    if not gatk.is_single_end(**wildcards):
        # paired-end sample
        return expand(
            "results/trimmed/{sample}-{unit}.{group}.fastq.gz", group=[1, 2], **wildcards
        )
    # single end sample
    return "results/trimmed/{sample}-{unit}.fastq.gz".format(**wildcards)
