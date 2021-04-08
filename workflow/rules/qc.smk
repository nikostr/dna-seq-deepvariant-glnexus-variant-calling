rule fastqc:
    input:
        #"reads/{sample}.fastq"
        unpack(get_fastq)
    output:
        html="results/qc/fastqc/{sample}.html",
        zip="results/qc/fastqc/{sample}_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params: "--quiet"
    log:
        "results/logs/fastqc/{sample}.log"
    threads: 1
    wrapper:
        "0.73.0/bio/fastqc"


rule samtools_stats:
    input:
        rules.samtools_merge.output
    output:
        "results/qc/samtools_stats/{sample}.txt"
    params:
        extra="",                       # Optional: extra arguments.
        region=""      # Optional: region string.
    log:
        "results/logs/samtools_stats/{sample}.log"
    wrapper:
        "0.73.0/bio/samtools/stats"


rule multiqc:
    input:
        rules.fastqc.output.zip,
        rules.samtools_stats.output,
        rules.fastp_se.output.json,
        rules.fastp_pe.output.json,
    output:
        "results/qc/multiqc/{sample}.html"
    params:
        ""  # Optional: extra parameters for multiqc.
    log:
        "results/logs/multiqc/{sample}.log"
    wrapper:
        "0.73.0/bio/multiqc"


rule multiqc:
    input:
        expand(
            [
                "results/qc/samtools-stats/{u.sample}.txt",
                "results/qc/fastqc/{u.sample}-{u.unit}.zip",
                "results/qc/fastp/{u.sample}-{u.unit}.json",
            ],
            u=units.itertuples(),
        ),
    output:
        "results/qc/multiqc.html",
        #report(
        #    "results/qc/multiqc.html",
        #    caption="../report/multiqc.rst",
        #    category="Quality control",
        #),
    log:
        "results/logs/multiqc.log",
    wrapper:
        "0.59.2/bio/multiqc"
