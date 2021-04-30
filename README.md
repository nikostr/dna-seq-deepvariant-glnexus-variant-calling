# Snakemake workflow: dna-seq-deepvariant-glnexus-variant-calling

[![Snakemake](https://img.shields.io/badge/snakemake-≥6-brightgreen.svg)](https://snakemake.bitbucket.io)
[![Tests](https://github.com/nikostr/dna-seq-deepvariant-glnexus-variant-calling/actions/workflows/python-package-conda.yml/badge.svg)](https://github.com/nikostr/dna-seq-deepvariant-glnexus-variant-calling/actions/workflows/python-package-conda.yml)

This is a Snakemake pipeline implementing the [multi-sample variant calling with DeepVariant and GLnexus](https://github.com/google/deepvariant/blob/master/docs/trio-merge-case-study.md). It also allows for single-sample variant calling, and creating a merged vcf containing both individual call sets and merged call sets.

## Authors

* Nikos Tsardakas Renhuldt (@nikostr)

## Usage

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://varlociraptor.github.io/snakemake-workflow-catalog?usage=nikostr/dna-seq-deepvariant-glnexus-variant-calling).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and, if available, its DOI (see above).

Of course, also make sure to credit the tools this pipeline uses:


  - R. Poplin et al., “A universal SNP and small-indel variant caller using deep neural networks,” Nat Biotechnol, vol. 36, no. 10, pp. 983–987, Nov. 2018, doi: 10.1038/nbt.4235.
  - T. Yun, H. Li, P.-C. Chang, M. F. Lin, A. Carroll, and C. Y. McLean, “Accurate, scalable cohort variant calls using DeepVariant and GLnexus,” Bioinformatics, vol. 36, no. 24, pp. 5582–5589, Apr. 2021, doi: 10.1093/bioinformatics/btaa1081.
  - H. Li, “Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM,” arXiv:1303.3997 [q-bio], May 2013, Accessed: Apr. 27, 2021. [Online]. Available: http://arxiv.org/abs/1303.3997.
  - A. D. Yates et al., “Ensembl 2020,” Nucleic Acids Research, p. gkz966, Nov. 2019, doi: 10.1093/nar/gkz966.
  - S. Chen, Y. Zhou, Y. Chen, and J. Gu, “fastp: an ultra-fast all-in-one FASTQ preprocessor,” Bioinformatics, vol. 34, no. 17, pp. i884–i890, Sep. 2018, doi: 10.1093/bioinformatics/bty560.
  - S. Andrews, FastQC: A Quality Control tool for High Throughput Sequence Data. .
  - O. Tange, Gnu Parallel 20150322 ('Hellwig’). Zenodo, 2015.
  - P. Ewels, M. Magnusson, S. Lundin, and M. Käller, “MultiQC: summarize analysis results for multiple tools and samples in a single report,” Bioinformatics, vol. 32, no. 19, pp. 3047–3048, Oct. 2016, doi: 10.1093/bioinformatics/btw354.
  - J. Reback et al., pandas-dev/pandas: Pandas 1.2.4. Zenodo, 2021.
  - F. Mölder et al., “Sustainable data analysis with Snakemake,” F1000Res, vol. 10, p. 33, Apr. 2021, doi: 10.12688/f1000research.29032.2.
  - P. Danecek et al., “Twelve years of SAMtools and BCFtools,” GigaScience, vol. 10, no. 2, p. giab008, Jan. 2021, doi: 10.1093/gigascience/giab008.
