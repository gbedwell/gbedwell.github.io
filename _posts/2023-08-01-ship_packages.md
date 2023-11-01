---
title: Ship packages
excerpt: Semi-automating package installation after R updates.
classes: wide
output:
  md_document:
    variant: gfm
    preserve_yaml: true
knit: (function(input, ...) {
    rmarkdown::render(
      input,
      output_file = paste0(
        '/Users/gbedwell/Documents/github/gbedwell.github.io/_posts/', '2023-08-01', '-', 'ship_packages','.md'
      ),
      envir = globalenv()
    )
  })
---

### Introduction

Re-installing packages after an R update always seems be a bit of a
pain. I can never remember exactly what I did the last time I updated,
so I always end up looking through the same Google search results,
trying to land on the easiest/most efficient way of making library
migration a little easier.

Eventually, I decided that it was time to standardize this process. I
wrote an R script,
[ship_packages.R](https://github.com/gbedwell/ship_packages), that
contains two functions. These functions will:

1.  Export information for all of the packages in the current R library
    to a CSV file.

2.  Read that CSV file and automatically install packages from CRAN,
    Bioconductor, and/or GitHub.

The script itself is best used when <code>source</code>’d.

### Address packages

The first function in the R script is <code>address_packages()</code>.
This function uses <code>installed_packages()</code> and
<code>packageDescription()</code> to retrieve package information about
the packages installed in a given library. The information retrieved
includes package name, path, version, dependencies, imports, R build
version, and location (e.g., CRAN, Bioconductor, GitHub, etc.).

Τhe default behavior of <code>address_packages()</code> is to write
information about the <i>current</i> library (i.e., <i>before
updating</i>) into a CSV file in the current working directory. This can
be done by simply running <code>address_packages()</code>. However, the
behavior is somewhat flexible.

In the event that you forget to run the function before updating, you
can specify a specific library path with the <code>lib.path</code>
argument. In this case, you can also avoid writing a CSV file and run
the function directly in the new R environment by setting <code>write =
FALSE</code>. If you’re retrieving information about a library that is
not the current R library, the version of the <i>target</i> library must
be provided. The function will check that the provided version and the
provided library path are compatible. This is intended to help ensure
that the retrieved information is the desired information.

### Deliver packages

<code>deliver_packages()</code> takes as input the output of
<code>address_packages()</code>. The <code>pkgs</code> argument in
<code>deliver_packages()</code> can accept either a file path (to the
CSV file) or a data frame. Package information is the parsed and
packages from the defined repositories (currently any/all of CRAN,
Bioconductor, and/or GitHub) are installed. Installation from CRAN does
not require any exogenous packages. Installation from Bioconductor and
GitHub, however, require the installation of BiocManger and devtools,
respectively. These packages are automatically installed (if they are
not already) if installation from these repositories is requested. If
there are packages included in the input information that you <i>do
not</i> want installed, define them by name with the <code>omit</code>
argument.

### Example usage

- In the <i>current</i> R version (before updating), run
  <code>address_packages()</code>. The code below will write out a CSV
  file to the stated directory path. The current R library/version are
  exported by default.

``` r
address_packages( dir.path = "~/path/to/directory" )
```

- Update R.

- In the <i>new</i> R version, run <code>deliver_packages()</code>. By
  default, the function will install <i>all</i> packages from CRAN,
  Bioconductor, and GitHub (i.e., no packages are omitted).

``` r
deliver_packages( pkgs = "~/path/to/directory/packages_R-4.3.1_2023-10-25.csv" )
```
