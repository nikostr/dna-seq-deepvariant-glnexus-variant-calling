from snakemake.utils import validate
import pandas as pd
import numpy as np
import os

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

##### load config and sample sheets #####

configfile: "config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index("sample_id", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

units = pd.read_table(config["units"], dtype=str).set_index(
    ["sample_id", "unit"], drop=False
)
units.index = units.index.set_levels(
    [i.astype(str) for i in units.index.levels]
)  # enforce str in index
validate(units, schema="../schemas/units.schema.yaml")

joint_calling_groups = pd.read_csv(config["joint_calling_groups"], sep="\t")
validate(joint_calling_groups, schema="../schemas/joint_calling_groups.schema.yaml")
# List of samples for each joint calling group
joint_calling_group_lists = (joint_calling_groups
        .groupby('group')
        .sample_id
        .apply(set))

# jcg logic
# for each sample present in more than two calling groups
# find the union of the calling groups they are present in
# and do joint calling on these
merged_joint_calling_groups = (joint_calling_groups
        .groupby('sample_id')
        .group
        .apply(set)
        .reset_index()
        .assign(n=lambda x: x.group.str.len())
        .query('n>2')
        .drop('n', axis=1)
        .assign(sample_set=lambda x: (x.
            .group
            .apply(lambda y: (joint_calling_groups
                .loc[joint_calling_groups.isin(y), 'sample_id']))
            .agg(set, axis=1)
            .apply(lambda y: y - {np.nan})))
        )

## Helper functions

def get_fastq(wildcards):
    """Get fastq files of given sample-unit."""
    fastqs = units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    if len(fastqs) == 2:
        return {"sample": [fastqs.fq1, fastqs.fq2]}
    return {"sample": [fastqs.fq1]}


def is_single_end(sample, unit):
    """Return True if sample-unit is single end."""
    return pd.isnull(units.loc[(sample, unit), "fq2"])


def get_trimmed_reads(wildcards):
    """Get trimmed reads of given sample-unit."""
    if not is_single_end(**wildcards):
        # paired-end sample
        return expand(
            "results/trimmed/{sample}-{unit}.{group}.fastq.gz", group=[1, 2], **wildcards
        )
    # single end sample
    return "results/trimmed/{sample}-{unit}.fastq.gz".format(**wildcards)
