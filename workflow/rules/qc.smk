rule fastqc:
    input:
        #"reads/{sample}.fastq"
        get_fastqc_input
    output:
        html="results/report/fastqc/{sample}.html",
        zip="results/report/fastqc/{sample}_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params: "--quiet"
    log:
        "logs/fastqc/{sample}.log"
    threads: 1
    wrapper:
        "0.73.0/bio/fastqc"


rule samtools_stats:
    input:
        rules.bwa_mem.output
    output:
        "results/report/samtools_stats/{sample}.txt"
    params:
        extra="",                       # Optional: extra arguments.
        region=""      # Optional: region string.
    log:
        "logs/samtools_stats/{sample}.log"
    wrapper:
        "0.73.0/bio/samtools/stats"


rule multiqc:
    input:
        rules.fastqc.output.zip,
        rules.samtools_stats.output,
        rules.fastp.output.json
    output:
        "results/report/multiqc/{sample}.html"
    params:
        ""  # Optional: extra parameters for multiqc.
    log:
        "logs/multiqc/{sample}.log"
    wrapper:
        "0.73.0/bio/multiqc"
