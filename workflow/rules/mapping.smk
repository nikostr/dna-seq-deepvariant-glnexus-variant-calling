rule map_reads:
    input:
        reads=get_trimmed_reads,
        idx=get_bwa_index,
    output:
        temp("results/mapped/{sample}-{unit}.sorted.bam"),
        temp("results/mapped/{sample}-{unit}.sorted.bam.csi"),
    log:
        "results/logs/bwa_mem/{sample}-{unit}.log",
    params:
        index=lambda w, input: os.path.splitext(input.idx)[0],
        extra=config["bwa_mem"]["extra"],
        sort=config["bwa_mem"]["sort"],  # Can be 'none', 'samtools' or 'picard'.
        sort_order=config["bwa_mem"]["sort_order"],  # Can be 'queryname' or 'coordinate'.
        sort_extra=config["bwa_mem"]["sort_extra"] + " --write-index",  # Extra args for samtools/picard.
    threads: config["bwa_mem"]["threads"]
    wrapper:
        "0.75.0/bio/{}".format(config["bwa_mem"]["wrapper"])


rule samtools_merge:
    input:
        lambda w: expand(
            "results/mapped/{sample}-{unit}.sorted.bam",
            sample=w.sample,
            unit=samples.loc[w.sample].unit,
        ),
    output:
        bam="results/mapped/{sample}.bam",
        idx="results/mapped/{sample}.bam.csi",
    log:
        "results/logs/samtools_merge/{sample}.log",
    params:
        config["samtools_merge"]["params"] + " --write-index",  # optional additional parameters as string
    threads: config["samtools_merge"]["threads"]  # Samtools takes additional threads through its option -@
    wrapper:
        "0.75.0/bio/samtools/merge"
