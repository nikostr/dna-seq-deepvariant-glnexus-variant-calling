rule map_reads:
    input:
        reads=get_trimmed_reads,
        idx=rules.bwa_index.output
        #add index dependecy as in https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/blob/master/rules/mapping.smk
    output:
        temp("results/mapped/{sample}-{unit}.sorted.bam"),
        temp("results/mapped/{sample}-{unit}.bam.csi"),
    log:
        "results/logs/bwa_mem/{sample}-{unit}.log"
    params:
        index=lambda w, input: os.path.splitext(input.idx[0])[0],
        extra=config['bwa_mem']['extra'],
        sort=config['bwa_mem']['sort'],             # Can be 'none', 'samtools' or 'picard'.
        sort_order=config['bwa_mem']['sort_order'],  # Can be 'queryname' or 'coordinate'.
        sort_extra=config['bwa_mem']['sort_extra'] + ' --write-index'            # Extra args for samtools/picard.
    threads: config['bwa_mem']['threads']
    wrapper:
        "0.73.0/bio/bwa/mem"

rule samtools_merge:
    input:
        lambda w: expand(
                "results/mapped/{sample}-{unit}.sorted.bam",
                sample=w.sample,
                unit=units.loc[w.sample].unit
                )
    output:
        "results/mapped/{sample}.bam"
    params: config['samtools_merge']['params'] # optional additional parameters as string
    threads: config['samtools_merge']['threads'] # Samtools takes additional threads through its option -@
    wrapper:
        "0.73.0/bio/samtools/merge"


rule samtools_index:
    input:
        "results/mapped/{sample}.bam"
    output:
        "results/mapped/{sample}.bam.csi"
    params: config['samtools_index']['params'] + ' -c '# optional params string
    wrapper:
        "0.73.0/bio/samtools/index"
