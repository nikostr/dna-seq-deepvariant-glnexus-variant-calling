rule deepvariant:
    input:
        bam="results/mapped/{sample}.bam",
        ref="resources/genome.fasta"
    output:
        vcf="results/calls/{sample}.vcf.gz"
    params:
        model=config['deepvariant']['model'],
        extra=config['deepvariant']['extra']
    threads: config['deepvariant']['threads']
    log:
        "results/logs/deepvariant/{sample}/stdout.log"
    wrapper:
        "0.73.0/bio/deepvariant"


rule deepvariant_gvcf:
    input:
        bam="results/mapped/{sample}.bam",
        ref="resources/genome.fasta"
    output:
        vcf=temp("results/individual_calls/{sample}.vcf.gz"),
        gvcf=temp("results/individual_calls/{sample}.g.vcf.gz")
    params:
        model=config['deepvariant_gvcf']['model'],
        extra=config['deepvariant_gvcf']['extra']
    threads: config['deepvariant_gvcf']['threads']
    log:
        "results/logs/deepvariant_gvcf/{sample}/stdout.log"
    wrapper:
        "0.73.0/bio/deepvariant"


rule glnexus:
    input:
        gvcfs=lambda w: expand('results/individual_calls/{samples}.g.vcf.gz',
                sample=joint_calling_groups.loc[w.joint_call_group])
    output:
        vcf='results/joint_calls/{joint_call_group}.vcf.gz'
    params:
        config=config['glnexus']['config']
    threads: config['glnexus']['threads']
    log:
        'results/logs/glnexus/{sample}/stdout.log'
    wrapper:
        ''
