---
title: Curriculum vitae
layout: single
modified: 2025-05-14
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

My current research is focused on using and developing computational approaches to better understand genomic integration, intrinsically disordered proteins, and nuclear compartmentalization. This work is applicable to basic and clinical virology, gene therapy, cell therapy, protein design, and cell biology. I have developed novel tools for the improved mapping and analysis of genomic integration sites; applied machine learning algorithms and wet-bench experiments to better understand the conformational ensembles, solution behavior, and sequence determinants of specific properties of intrinsically disordered proteins; and identified conserved chromatin states related to nuclear compartmentalization. Through this interdisciplinary work, I hope to advance our understanding of complex biological problems and contribute to the development of novel therapeutic strategies.

**Consulting** - Freelance.

I have consulted companies on processing and wrangling large, asynchronous data into smaller, harmonized, and user-friendly formats. I am open to more consulting opportunities in data wrangling, bioinformatics, and data analysis. If interested, please [get in touch](mailto:gregoryjbedwell@gmail.com)!


## <i class="fas fa-map-marker-alt"></i> Previous positions

**Post-doctoral fellow** - Dana-Farber Cancer Institute/Harvard Medical School

During my post-doctoral fellowship, I developed a novel computational approach to better define the preferred gene targets of HIV-1 integration. This work resulted in the identification of previously un/under-appreciated target genes with implications for viral persistence. I additionally developed and optimized protein expression and purification protocols for challening protein targets -- namely intrinsically disordered proteins with a propensity to undergo phase separation in solution. This work has resulted in the biochemical and structural characterization of some of these proteins for the first time.

**Graduate student** - University of Alabama at Birmingham.

As a graduate student, I was interested in understanding and exploiting the architecture of the bacteriophage P22. I utilized the architectural features of the viral capsid to direct the synthesis of photocatalytic materials within the capsid interior, effectively solubilizing the otherwise insoluble material. I additionally worked to better define the packaging mechanism of dsDNA viruses.


## <i class="fas fa-chart-bar"></i> Programming and statistics

**Languages**: R, Python, and Bash.

**Computing**: Git, SLURM, Grid Engine, VS Code, Quarto, conda, etc.

**Bioinformatics**: GenomicRanges, bedtools, samtools, cutadapt, Bowtie(2), BWA, STAR, MACS2, epigraHMM, edgeR, limma, AlphaFold, MMseqs2, ESM(-fold), bio-embeddings, etc.

**Data Science**: Tidyverse, NumPy, DuckDB, tidymodels, k-NN, FAISS, DBSCAN, PCA, t-SNE, union-find, HMMs, ggplot2, etc.

**Statistics**: GLMs, nonlinear regression, regularization, change point detection, null hypothesis testing, expectation-maximization, etc.

## <i class="fas fa-code"></i> Software

- [intmap](https://github.com/gbedwell/intmap): An end-to-end pipeline for mapping positions of genomic integration from NGS data.

- [xInt](https://github.com/gbedwell/xInt): An R/Bioconductor package to analyze integration site data post-mapping. Incoporates a wide variety of functionalities intended to provide users with a comprehensive toolkit for rigorously assessing integration site targeting trends/biases.

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



