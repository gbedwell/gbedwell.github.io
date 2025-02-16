---
title: Curriculum vitae
layout: single
modified: 2025-02-16
excerpt: ""
share: false
paragraph-indent: false;
permalink: /cv.html
---

## <i class="fas fa-graduation-cap"></i> Education

  - 2021 - Post-doctoral fellow, Dana-Farber Cancer Institute/Harvard Medical School.
  - 2016 - Ph.D., Biophysics, University of Alabama at Birmingham.
      - Dissertation: Exploring bacteriophage P22 as a selective molecular scaffold and molecular sensor.
  - 2010 - B.S., Chemistry, University of Alabama at Birmingham.

## <i class="fas fa-user-astronaut"></i> Current position

**Instructor in Medicine** - Dana-Farber Cancer Institute/Harvard Medical School.

My current research is broadly focused on genomic integration. This work has direct applications to many areas of science, including basic virology, clinical virology, gene/cell therapy, and more. Even more generally, I am very interested in the development and application of computational methods/tools to biological questions. I have developed end-to-end pipelines and packages for the analysis of integration site data, utilized state-of-the-art protein language models and sequence databases to aid in hypothesis generation and data interpretation, used machine learning techniques to better define conserved chromatin states relative to nuclear compartments, and much more. Beyond my research efforts, I actively mentor and advise undergraduate students, graduate students, research technicians, and others in both wet and dry lab research.

**Consulting** - Freelance.

I have consulted companies on processing and wrangling large, asynchronous data into smaller, harmonized, and user-friendly formats. I am open to more consulting opportunities in data wrangling, bioinformatics, and data analysis. If interested, please [get in touch](mailto:gregoryjbedwell@gmail.com)!


## <i class="fas fa-map-marker-alt"></i> Previous positions

**Post-doctoral fellow** - Dana-Farber Cancer Institute/Harvard Medical School

I began my post-doctoral fellowship leveraging my knowledge of protein chemsitry and biophysics to devise a recombinant protein expression system for difficult human protein targets. This work has enabled the biochemical characterization of some of these proteins for the first time. Eventually, I began to more proactively pursue my long-standing interests in computational biology and bioinformatics. To this end, I was able to more granularly define the preferred gene targets of HIV-1 integration. My post-doctoral work ultimately formed the basis of the research that I continue to perform today.

**Graduate student** - University of Alabama at Birmingham.

As a graduate student, I was interested in understanding and exploiting the architecture of the bacteriophage P22. I exploited architectural features of the viral capsid to direct the synthesis of photocatalytic materials within the capsid interior, effectively solubilizing the otherwise insoluble material. I additionally worked to better define the packaging mechanism of dsDNA viruses.


## <i class="fas fa-chart-bar"></i> Programming and statistics

**Languages**: R (primary), Python, and Bash.

**Computing tools and technologies**: bash scripting, HPC clusters (SLURM and Grid Engine), git and GitHub, tidy data, knitr/Rmarkdown/quarto, VS Code, LaTeX, SageMath, conda.

**Software**: 
  - <u>Bioconductor</u>: GenomicRanges, Biostrings, rtracklayer, BSgenome, SummarizedExperiment, GenomicAlignments, bamsignals, edgeR, limma, and many more. 
  - <u>Misc. bioinformatics software</u>: FastQC, bedtools, samtools, Biopython, pysam, BWA, Bowtie2, MMSeqs2, FoldSeek, and more. 
  - <u>Data science and machine learning</u>: Tidyverse, tidymodels, DuckDB, data.table, caret, FAISS, similarity search algorithms (LSH, MinHash, k-NN, etc.), cluster analysis (k-means clustering, hierarchical clustering, DBSCAN, etc.), graph algorithms (DFS, BFS), hidden Markov models, and more.
  - <u>Hydrodynamic modeling</u>: hullrad, HYDROPRO.
  - <u>Structure prediction</u>: AlphaFold/ColabFold, ESMFold, Boltz-1, AlphaFold-Metainference

**Statistics**: nonlinear least squares, generalized linear models, regularized regression, bootstrapping, change point detection, and more.

## <i class="fas fa-code"></i> Software

- [intmap](https://github.com/gbedwell/intmap): An end-to-end pipeline for mapping genomic integration site positions from NGS data.

- [xInt](https://github.com/gbedwell/xInt): An R/Bioconductor package to analyze integration site data post-mapping. Incoporates a wide variety of functionalities intended to provide users with a comprehensive toolkit for rigorously assessing integration site targeting trends/biases.

- [calibrateR](https://github.com/gbedwell/calibrateR): An R package written to streamline common laboratory calculations. A brief description of the package and general usage can be found [here](https://gbedwell.github.io/calibrateR/).

- [nbconv](https://github.com/gbedwell/nbconv): An R package that implements multiple methods for evaluating arbitrary negative binomial convolutions. See [this post](https://gbedwell.github.io/nb-convolutions/) for more information. nbconv can be found on [CRAN](https://cran.r-project.org/web/packages/nbconv/index.html) and [GitHub](https://github.com/gbedwell/nbconv).


## <i class="fas fa-align-left"></i> Selected Publications

{% for pub in site.data.bib.publications %}

{% capture location %}
{% if pub.where %}
{% if pub.where.journal %}_{{ pub.where.journal }}_{% endif %}
{% if pub.where.volume %}, _{{ pub.where.volume }}_{% endif %}
{% if pub.where.pages %}, {{ pub.where.pages }}{% endif %}
.{% endif %}
{% endcapture %}

{% capture doi %}{% if pub.doi %} [{{pub.doi}}](http://doi.org/{{pub.doi}}). {% endif %}{% endcapture %}
{% capture bonus %}
{% if pub.bonus %}
[{{pub.bonus.text}}]
{% endif %}
{% endcapture %}

{% capture author_line %}
{% for author in pub.authors %}
{% if forloop.first %} {{author}}
{% elsif forloop.last %}, & {{author}}
{% else %}, {{author}}
{% endif %}
{% endfor %}
{% endcapture %}

{{ author_line | strip_newlines }} ({{ pub.when.year }}). **{{ pub.title | strip_newlines }}**. {{ location | strip_newlines}} {{doi}} {{ bonus  | strip_newlines }}
{% endfor %}

<br>

**A complete list of my peer-reviewed publications, can be found [here](https://pubmed.ncbi.nlm.nih.gov/?term=%28Bedwell+GJ+AND+Prevelige+PE%29+OR+%28Bedwell+GJ+AND+Engelman%29+OR+%28Bedwell+GJ+AND+Schneider%29+OR+%28Bedwell+GJ+AND+Saad%29+OR+%28Bedwell+GJ+AND+Bedwell+DM%29).**



