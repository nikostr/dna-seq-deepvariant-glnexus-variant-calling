rule deepvariant:
    input:
        bam=rules.samtools_merge.output[0],
        idx=rules.samtools_index.output,
        ref=rules.get_genome.output,
        ref_idx=rules.genome_faidx.output
    output:
        vcf="results/calls/{sample}.vcf.gz"
    params:
        model=config['deepvariant']['model'],
        extra=config['deepvariant']['extra']
    threads: config['deepvariant']['threads']
    log:
        "results/logs/deepvariant/{sample}/stdout.log"
    wrapper:
        "file:///home/nikos/src/snakemake-wrappers/bio/deepvariant"
        #"0.73.0/bio/deepvariant"


rule deepvariant_gvcf:
    input:
        bam=rules.samtools_merge.output[0],
        idx=rules.samtools_index.output,
        ref=rules.get_genome.output,
        ref_idx=rules.genome_faidx.output
    output:
        vcf="results/individual_calls/{sample}.vcf.gz",
        gvcf="results/individual_calls/{sample}.g.vcf.gz"
    params:
        model=config['deepvariant_gvcf']['model'],
        extra=config['deepvariant_gvcf']['extra']
    threads: config['deepvariant_gvcf']['threads']
    log:
        "results/logs/deepvariant_gvcf/{sample}/stdout.log"
    wrapper:
        "file:///home/nikos/src/snakemake-wrappers/bio/deepvariant"
        #"0.73.0/bio/deepvariant"


rule glnexus:
    input:
        gvcfs=lambda w: expand('results/individual_calls/{sample}.g.vcf.gz',
                sample=joint_calling_group_lists.loc[w.joint_calling_group])
    output:
        vcf=tmp('results/all_group_samples_joint_calls/{joint_calling_group}.vcf.gz'),
        scratch=temp(directory('results/all_group_samples_joint_calls/{joint_calling_group}.DB'))
    params:
        config=config['glnexus']['config']
    threads: config['glnexus']['threads']
    log:
        'results/logs/glnexus/{joint_calling_group}/stdout.log'
    container:
        'docker://quay.io/mlin/glnexus:v1.3.1'
    shell:
        '/usr/local/bin/glnexus_cli '
        '--config DeepVariantWGS '
        '--dir {output.scratch} '
        '--threads {threads} '
        '{input} '
        '2> {log} '
        '| bcftools view - '
        '| bgzip -c '
        '> {output.vcf} '


rule bcftools_index:
    input:
        "{vcffile}.vcf.gz"
    output:
        "{vcffile}.vcf.gz.csi"
    params:
        extra=config['bcftools_index']['extra'] + ' --threads {}'.format(config['bcftools_index']['threads'])  # optional parameters for bcftools index
    threads: config['bcftools_index']['threads']
    wrapper:
        "0.73.0/bio/bcftools/index"


rule remove_duplicate_samples:
    input:
        vcf=rules.glnexus.output.vcf
    output:
        vcf='results/joint_calls/{joint_calling_group}.vcf.gz',
    params:
        extra=get_joint_calling_group_samples
    threads: config['bcftools_index']['threads']
    wrapper:
        "0.73.0/bio/bcftools/view"


rule bcftools_merge:
    input:
        calls=[
            *expand("results/calls/{sample}.vcf.gz", sample=(samples
                .loc[~ samples.sample_id.isin(joint_calling_groups.query('keep==1').sample_id)]
                .index)),
            *expand('results/joint_calls/{joint_calling_group}.vcf.gz',
                joint_calling_group=joint_calling_group_lists.index)
            ],
        idxs=[
            *expand("results/calls/{sample}.vcf.gz.csi", sample=(samples
                .loc[~ samples.sample_id.isin(joint_calling_groups.query('keep==1').sample_id)]
                .index)),
            *expand('results/joint_calls/{joint_calling_group}.vcf.gz.csi',
                joint_calling_group=joint_calling_group_lists.index)
            ]
    output:
        "results/merged_calls/all.bcf"
    params:
        config['bcftools_merge']['params']  # optional parameters for bcftools concat (except -o)
    wrapper:
        "0.73.0/bio/bcftools/merge"
