---
title: Curriculum vitae
layout: single
modified: 2024-02-29
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

My current work lies at the intersection of computational and systems biology. I am working to better define the genomic landscape of retroviral integration and the factors that influence that landscape. I have performed bioinformatic analyses for numerous collaborative projects across Harvard Medical School, the National Institutes of Health, and other scientific insitutions across the world. I am additionally working to develop tools and strategies that will enable scientists to more robustly characterize patterns of integration in their system-of-interest. These efforts include software/pipeline development and improvement, leveraging publically available datasets to better define genomic regions pertinent to integration, and developing methods to improve the resolution of integration site analysis. Beyond my research efforts, I actively mentor and advise undergraduate students, graduate students, research technicians, and others in the lab in both wet and dry lab research.

**Consulting** - Freelance.

I have consulted companies on processing and wrangling large data files into smaller, more user-friendly formats. I am open to more consulting opportunities in data wrangling, bioinformatics, and data analysis. If interested, please [get in touch](mailto:gregoryjbedwell@gmail.com)!


## <i class="fas fa-map-marker-alt"></i> Previous positions

**Post-doctoral fellow** - Dana-Farber Cancer Institute/Harvard Medical School

I began my post-doctoral fellowship leveraging my knowledge of protein chemsitry and biophysics to devise a recombinant protein expression system for difficult human protein targets. These proteins often exhibit low sequence complexity, strong compositional biases, and a large degree of disorder. The expression system I devised has been successfully applied to several protein targets, enabling their biochemical and biophysical characterization for the first time. Over time, I began to pursue my long-standing interests in computational biology and bioinformatics with increasing seriousness. In pursuing these interests, I was able to devise a new strategy for better defining the preferred gene targets of HIV-1 integration. This project formed the conceptual basis for the work that I continue to develop today.

**Graduate student** - University of Alabama at Birmingham.

As a graduate student, I was interested in understanding and exploiting the architecture of the bacteriophage P22. I devised a system to selectively mineralize photocatalytic titanium dioxide within the pseudo-icosahedral shell of P22 procapsid-like particles. Confining highly insoluble titanium dioxide within the capsid shell works to effectively solubilize the material, making it more tractable for use in aqueous environments. In addition, I sought to understand the mechanism of so-called "headful" packaging, a packaging strategy utilized by many dsDNA viruses. I was able to show that the P22 portal acts as a biological pressure sensor that responds to the increasing internal pressure within the viral procapsid during genome packaging.


## <i class="fas fa-chart-bar"></i> Programming and statistics

**Languages**: Proficiency in R. Competency with Python, AWK, etc. Exposure to Julia.

**Computing tools and technologies**: bash scripting, HPC clusters (SLURM and Grid Engine), git and GitHub, tidy data, knitr/Rmarkdown/quarto/xaringan, LaTeX, SageMath.

**Bioinformatic tools**: 
  - <u>Bioconductor</u>: GenomicRanges, Biostrings, rtracklayer, BSgenome, SummarizedExperiment, and many more. 
  - <u>Miscellaneous bioinformatics software</u>: FastQC, bedtools, samtools, MACS2, and more. 
  - <u>Sequence aligners</u>: BWA-MEM, Bowtie2, Rsubread, STAR.
  - <u>Multiple sequence alignment</u>: hh-suite, Clustal Omega, MUSCLE.
  - <u>Hydrodynamic modeling</u>: hullrad, HYDROPRO.
  - <u>Structure prediction</u>: AlphaFold, ESMFold.
  - <u>Molecular dynamics</u>: CALVADOS.

**Statistics**: nonlinear least squares, generalized linear models, bootstrapping, hidden Markov models, changepoint detection, hull hypothesis significance testing, etc.

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



