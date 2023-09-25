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

My current work lies at the intersection of computational and systems biology. I am developing ways to better understand retroviral integration targeting biases, how those biases relate to provirus expression and disease progression, and how host factors influence said targeting biases. I pursue these questions using both wet and dry lab approaches. I am actively developing an improved computational and statistical framework for determining integration targeting biases within datasets and assessing differential targeting between them. I am additionally involved in designing, performing, and interpreting biophysical experiments related to understanding the role of liquid-liquid phase separation in HIV-1 infection and integration targeting. Beyond my particular research projects, I actively mentor undergraduate students, research technicians, and other trainees in both wet and dry lab research.

**Consulting** - Freelance.

I have consulted companies on processing and wrangling large data files into smaller, more user-friendly formats. I am open to more consulting opportunities in data wrangling, bioinformatics, and data analysis. If interested, please [get in touch](mailto:gregoryjbedwell@gmail.com)!


## <i class="fas fa-map-marker-alt"></i> Previous positions

**Post-doctoral fellow** - Dana-Farber Cancer Institute/Harvard Medical School

As a post-doctoral fellow, I devised a recombinant protein expression system and purification scheme for the human protein CPSF6, a protein with low sequence complexity and strong compositional biases. This expression system has since been successfully applied to several similar protein targets. I additionally began my foray into conceptualizing and developing computational methods to better define HIV-1 integration targeting preferences. A strategy for categorizing genes into recurrently targeted and recurrently avoided populations was published in Nucleic Acids Research in 2021.

**Graduate student** - University of Alabama at Birmingham.

As a graduate student, I was interested in understanding and exploiting the architecture of bacteriophage P22. I devised a system to selectively mineralize photocatalytic titanium dioxide within the pseudo-icosahedral shell of procapsid-like particles. Confining highly insoluble titanium dioxide within the capsid shell works to effectively "solubilize" the material, making it potentially more tractable for use in aqueous environments. In addition, I sought to understand the mechanism of so-called "headful" packaging. I was able to show that the P22 portal protein acts as a biological pressure sensor that responds to the increasing internal pressure introduced by increasing incorporation of dsDNA.


## <i class="fas fa-chart-bar"></i> Programming and statistics

**Languages**: Proficiency in R. Competency with Python, AWK, sed, etc. Exposure to Julia.

**Computing tools and technologies**: bash scripting, git and GitHub, tidy data and R tidyverse, knitr/Rmarkdown/quarto/xaringan, LaTeX, HPC clusters (SLURM and Grid Engine), SageMath, jq.

**Bioinformatic tools**: 
  - <u>Bioconductor</u>: GenomicRanges, Biostrings, BSgenome, SummarizedExperiment, Rsamtools, DESeq2, and many more. 
  - <u>Miscellaneous bioinformatics software</u>: FastQC, bedtools, samtools, MACS2, and more. 
  - <u>Sequence (pseudo)aligners</u>: Rsubread, BWA, STAR, kallisto.
  - <u>Multiple sequence alignment</u>: hh-suite, Clustal Omega, MUSCLE.
  - <u>Hydrodynamic modeling</u>: hullrad, HYDROPRO.
  - <u>Structure prediction</u>: MODELLER, trRosetta, AlphaFold, OmegaFold, RoseTTAFold, ESMFold. 
  - <u>Protein design</u>: RFdiffusion, ProteinMPNN, EvoDiff.

**Statistics**: discrete/categorical data analysis, linear and nonlinear least squares, generalized linear models, parametric and nonparametric models/tests, null hypothesis significance testing, bootstrapping, maximum likelihood estimation, optimization, hidden Markov models, empirical Bayes, etc.


## <i class="fas fa-code"></i> Software

- [calibrateR](https://github.com/gbedwell/calibrateR): An R package written to streamline common laboratory calculations. A brief description of the package and general usage can be found [here](https://gbedwell.github.io/calibrateR/).

- [nbconv](https://github.com/gbedwell/nbconv): An R package that implements three distinct methods for evaluating the sum of arbitrary negative binomial convolutions. See [this post](https://gbedwell.github.io/nb-convolutions/) for more information. nbconv can be found on [CRAN](https://cran.r-project.org/web/packages/nbconv/index.html).


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



