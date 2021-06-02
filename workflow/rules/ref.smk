rule get_genome:
    output:
        "resources/genome.fasta",
    log:
        "results/logs/get-genome.log",
    params:
        species=config["ref"]["species"],
        datatype="dna",
        build=config["ref"]["build"],
        release=config["ref"]["release"],
    cache: True
    wrapper:
        "0.75.0/bio/reference/ensembl-sequence"


rule genome_faidx:
    input:
        "resources/genome.fasta",
    output:
        "resources/genome.fasta.fai",
    log:
        "results/logs/genome-faidx.log",
    cache: True
    wrapper:
        "0.75.0/bio/samtools/faidx"


rule bwa_index:
    input:
        "resources/genome.fasta",
    output:
        multiext("resources/genome.fasta", ".amb", ".ann", ".bwt", ".pac", ".sa"),
    log:
        "results/logs/bwa_index.log",
    resources:
        mem_mb=config["bwa_index"]["mem_mb"],
    cache: True
    wrapper:
        "0.75.0/bio/bwa/index"


rule bwa_mem2_index:
    input:
        "resources/genome.fasta",
    output:
        multiext(
            "resources/genome.fasta", ".0123", ".amb", ".ann", ".bwt.2bit.64", ".pac"
        ),
    log:
        "results/logs/bwa-mem2_index.log",
    cache: True
    wrapper:
        "0.75.0/bio/bwa-mem2/index"
