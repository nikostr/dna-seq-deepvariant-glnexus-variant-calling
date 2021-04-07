rule fastp:
    input:
        #sample=["reads/pe/{sample}.1.fastq", "reads/pe/{sample}.2.fastq"] 
        get_fastp_input
    output:
        trimmed=["results/trimmed/{sample}.1.fastq", "results/trimmed/{sample}.2.fastq"],
        html="results/report/fastp/{sample}.html",
        json="results/report/fastp/{sample}.json"
    log:
        "logs/fastp/{sample}.log"
    params:
        adapters="--adapter_sequence {} --adapter_sequence_r2 {}".format(config['fastp']['adapter_r1'], config['fastp']['adapter_r2']),
        extra=config['fastp']['extra']
    threads: config['fastp']['threads']
    wrapper:
        "0.73.0/bio/fastp"

