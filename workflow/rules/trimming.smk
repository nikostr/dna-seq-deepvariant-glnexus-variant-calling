rule fastp_se:
    input:
        sample=gatk.get_fastp_input
    output:
        trimmed="results/trimmed/se/{sample}-{unit}.fastq",
        html="results/report/fastp/se/{sample}-{unit}.html",
        json="results/report/fastp/se/{sample}-{unit}.json"
    log:
        "results/logs/fastp/se/{sample}-{unit}.log"
    params:
        adapters=config['fastp_se']['adapter'],
        extra=config['fastp_se']['extra']
    threads: config['fastp_se']['threads']
    wrapper:
        "0.73.0/bio/fastp"


rule fastp_pe:
    input:
        sample=gatk.get_fastp_input
    output:
        trimmed=["results/trimmed/pe/{sample}-{unit}.1.fastq", "results/trimmed/pe/{sample}-{unit}.2.fastq"],
        html="results/report/fastp/pe/{sample}-{unit}.html",
        json="results/report/fastp/pe/{sample}-{unit}.json"
    log:
        "results/logs/fastp/pe/{sample}-{unit}.log"
    params:
        adapters=config['fastp_pe']['adapter']),
        extra=config['fastp_pe']['extra']
    threads: config['fastp_pe']['threads']
    wrapper:
        "0.73.0/bio/fastp"

