rule fastqc:
    input:
        unpack(get_fastq),
    output:
        html="results/qc/fastqc/{sample}-{unit}.html",
        zip="results/qc/fastqc/{sample}-{unit}_fastqc.zip",
    params:
        "--quiet",
    log:
        "results/logs/fastqc/{sample}-{unit}.log",
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
        expand("results/qc/samtools_stats/{s.sample_id}.txt", s=samples.itertuples()),
        expand("results/qc/fastqc/{s.sample_id}-{s.unit}_fastqc.zip", s=samples.itertuples()),
        expand("results/qc/fastp/{s.sample_id}-{s.unit}_fastp.json", s=samples.itertuples()),
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
