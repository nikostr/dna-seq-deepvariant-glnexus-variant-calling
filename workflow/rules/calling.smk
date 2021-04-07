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
        "logs/deepvariant/{sample}/stdout.log"
    wrapper:
        "0.73.0/bio/deepvariant"
