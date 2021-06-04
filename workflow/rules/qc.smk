rule fastqc:
    input:
        #"reads/{sample}.fastq"
        unpack(get_fastq),
    output:
        html="results/qc/fastqc/{sample}.html",
        zip="results/qc/fastqc/{sample}_fastqc.zip",  # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params:
        "--quiet",
    log:
        "results/logs/fastqc/{sample}.log",
    threads: 1
    wrapper:
        "0.75.0/bio/fastqc"


rule samtools_stats:
    input:
        rules.samtools_merge.output.bam,
    output:
        "results/qc/samtools_stats/{sample}.txt",
    params:
        extra="",  # Optional: extra arguments.
        region="",  # Optional: region string.
    log:
        "results/logs/samtools_stats/{sample}.log",
    wrapper:
        "0.75.0/bio/samtools/stats"


rule multiqc:
    input:
        expand(
            [
                "results/qc/samtools_stats/{s.sample_id}.txt",
                "results/qc/fastqc/{s.sample_id}-{s.unit}.zip",
                "results/qc/fastp/{s.sample_id}-{s.unit}.json",
            ],
            s=samples.itertuples(),
        ),
    output:
        report(
            "results/qc/multiqc.html",
            caption="../report/multiqc.rst",
            category="Quality control",
        ),
    log:
        "results/logs/multiqc.log",
    wrapper:
        "0.75.0/bio/multiqc"
