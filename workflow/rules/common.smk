from snakemake.utils import validate
import pandas as pd

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

##### load config and sample sheets #####

configfile: "config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], sep="\t").set_index("sample", drop=False)
samples.index.names = ["sample_id"]
validate(samples, schema="../schemas/samples.schema.yaml")

joint_calling_groups = (pd.read_csv(config["joint_calling_groups"], sep="\t")
        .groupby('group')
        .sample_id
        .apply(list))
validate(joint_calling_groups, schema="../schemas/joint_calling_groups.schema.yaml")
