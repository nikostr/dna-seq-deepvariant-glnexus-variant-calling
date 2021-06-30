ruleorder: fastp_pe > fastp_se


rule fastp_se:
    input:
        unpack(get_fastq),
    output:
        trimmed="results/trimmed/{sample}-{unit}.fastq.gz",
        html="results/qc/fastp/{sample}-{unit}.html",
        json="results/qc/fastp/{sample}-{unit}_fastp.json",
    log:
        "results/logs/fastp/{sample}-{unit}.log",
    params:
        adapters=config["fastp_se"]["adapter"],
        extra=config["fastp_se"]["extra"],
    threads: config["fastp_se"]["threads"]
    wrapper:
        "0.75.0/bio/fastp"


rule fastp_pe:
    input:
        unpack(get_fastq),
    output:
        trimmed=[
            "results/trimmed/{sample}-{unit}.1.fastq.gz",
            "results/trimmed/{sample}-{unit}.2.fastq.gz",
        ],
        html="results/qc/fastp/{sample}-{unit}.html",
        json="results/qc/fastp/{sample}-{unit}_fastp.json",
    log:
        "results/logs/fastp/{sample}-{unit}.log",
    params:
        adapters=config["fastp_pe"]["adapter"],
        extra=config["fastp_pe"]["extra"],
    threads: config["fastp_pe"]["threads"]
    wrapper:
        "0.75.0/bio/fastp"
