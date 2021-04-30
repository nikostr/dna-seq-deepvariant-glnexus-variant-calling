# General settings

Adjust `config.yaml` to configure the workflow execution. The config files `samples.tsv`, `units.tsv`, and `joint_calling_groups.tsv` contain the following sample information:

- `sample.tsv` lists the samples.
- `units.tsv` lists the read sets for each sample, with one set of reads for each `sample_id-unit`. Note that `sample_id-unit` combinations should be unique.
- `joint_calling_groups.tsv` groups samples for joint calling. Note that jointly called samples will be named with the format `group:sample_id` in the GLnexus output and in the final `all.vcf.gz` file.

The pipeline will call all samples individually. Samples specified as belonging to the same joint calling group will be called jointly by GLnexus. To call all samples jointly, specify them as all belonging to the same joint calling group. Samples that are only called individually do not need to be specified in `joint_calling_groups.tsv`.
