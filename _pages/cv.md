---
title: Curriculum vitae
layout: single
modified: 2022-11-21
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

These days, my principal scientific interests are in computational and systems biology. I am particularly interested in developing ways to better understand retroviral integration targeting biases and how those biases relate to provirus expression and/or latency. To this end, I am developing a statistical method, xInt, to define the "expected" levels of integration into each genomic feature (e.g. a single gene) within a pre-defined feature-set (e.g. all genes). Conceptually, this is a formalization and an expansion of the rigrag methodology that I worked on previously (see below), but with improved statistical rigor and the introduction of expected integration levels for wild-type integration. I am additionally involved in collaborations looking at integration site locations in patients harboring certain clinical phenotypes and I am actively involved in designing, performing, and analyzing biophysical experiments related to protein phase separation.


**Consulting** - Freelance.

I have consulted companies on processing and wrangling large data files into smaller, more user-friendly data formats. I am open to more consulting opportunities in data wrangling, bioinformatics, and data analysis. If interested, please [get in touch](mailto:gregoryjbedwell@gmail.com)!


## <i class="fas fa-map-marker-alt"></i> Previous positions

**Post-doctoral fellow** - Dana-Farber Cancer Institute/Harvard Medical School

As a post-doctoral fellow, I devised a recombinant protein expression system and purification scheme for the human protein CPSF6, a protein with low sequence complexity and strong compositional biases. This expression system has been extended to several similar protein targets that could not be easily purified previously. I additionally began my foray into conceptualizing and developing computational methods to better define HIV-1 integration targeting preferences. To this end, I built phenomenological models of theoretical random integration in order to define genes preferentially integrated into or avoided during HIV-1 infection. The methodology and findings were published in Nucleic Acids Research. This approach, however, has since been superseded by a newer, more robust method: xInt (not yet published).

**Graduate student** - University of Alabama at Birmingham.

As a graduate student, I was interested in understanding and exploiting the architecture of bacteriophage P22. I devised a system to selectively mineralize photocatalytic titanium dioxide within the pseudo-icosahedral shell of procapsid-like particles. Confining highly insoluble titanium dioxide within the capsid shell works to effectively "solubilize" the material, making it potentially more tractable for use in aqueous environments. In addition, I sought to understand the mechanism of so-called "headful" packaging. In this packaging strategy, dsDNA bacteriophage are able to effectively "sense" the amount of DNA that has been packaged within their capsid and stop when the capsids are full. I was able to show that the P22 portal protein acts as a biological pressure sensor that responds to pressure introduced by genome packaging.


## <i class="fas fa-chart-bar"></i> Programming and statistics

**Languages**: Proficiency in R. Competency with Python, AWK, sed, etc. Exposure to Julia.

**Computing tools and technologies**: bash scripting, git and GitHub, tidy data and R tidyverse, jq, knitr/Rmarkdown/quarto/xaringan, HPC clusters (SLURM and Grid Engine).

**Bioinformatic tools**: 
  - <u>Bioconductor</u>: GenomicRanges, BSgenome, Biostrings, DESeq2, Rsamtools, biomaRt, plyranges, etc. 
  - <u>Miscellaneous software</u>: bedtools, samtools, MACS2. 
  - <u>Sequence (pseudo)aligners</u>: Rsubread, BWA, STAR, kallisto.
  - <u>Multiple sequence alignment</u>: hh-suite, Clustal Omega, MUSCLE.
  - <u>Macromolecular modeling</u>: hullrad, HYDROPRO.
  - <u>Structure prediction</u>: ColabFold (AlphaFold), OmegaFold, MODELLER.

**Statistics**: categorical data analysis, linear and nonlinear least squares, generalized linear models, parametric and nonparametric hypothesis testing, bootstrapping, maximum likelihood estimation.


## <i class="fas fa-code"></i> Software
Coming soon!


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



