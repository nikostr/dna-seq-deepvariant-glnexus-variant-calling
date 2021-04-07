rule bwa_mem:
    input:
        reads=rules.fastp.output.trimmed,
        idx=rules.bwa_index.output
        #add index dependecy as in https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/blob/master/rules/mapping.smk
    output:
        "results/mapped/{sample}.bam",
        "results/mapped/{sample}.bam.csi",
    log:
        "results/logs/bwa_mem/{sample}.log"
    params:
        index="genome",
        extra=config['bwa_mem']['extra'],
        sort=config['bwa_mem']['sort'],             # Can be 'none', 'samtools' or 'picard'.
        sort_order=config['bwa_mem']['sort_order'],  # Can be 'queryname' or 'coordinate'.
        sort_extra=config['bwa_mem']['sort_extra'] + ' --write-index'            # Extra args for samtools/picard.
    threads: config['bwa_mem']['threads']
    wrapper:
        "0.73.0/bio/bwa/mem"

#rule samtools_index:
#    input:
#        "results/mapped/{sample}.bam"
#    output:
#        "results/mapped/{sample}.bam.bai"
#    params:
#        "" # optional params string
#    wrapper:
#        "0.73.0/bio/samtools/index"
