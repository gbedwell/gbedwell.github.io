---
title: Generating random genome fragments in R
excerpt: Quickly and easily generating random genomic fragments.
classes: wide
output:
  md_document:
    variant: gfm
    preserve_yaml: true
knit: (function(input, ...) {
    rmarkdown::render(
      input,
      output_file = paste0(
        '/Users/gbedwell/Documents/github/gbedwell.github.io/_posts/', '2022-12-27', '-', 'random-genome-fragments','.md'
      ),
      envir = globalenv()
    )
  })
---

In the analysis of genomic data, a theoretical random distribution is
often used as a reference point for feature enrichment or depletion. In
principle, the derivation of an expected random distribution is not too
difficult. Given the genome size, $L_G$, the probability of integration
into a particular region $i$ is simply $p_i = L_i/L_G$, where $L_i$ is
the length of $i$. Therefore, the expected number of integration sites
in $i$ can be expressed as $I \sim Bin(n, p_i)$.

In reality, however, the entire genome is rarely accessible by common
next-generation sequencing technologies. While long-read sequencing is
growing in both accessibility and throughput, it is still common for
genomic experiments to be done using e.g. 150 bp paired-end sequencing.
Because of this, certain regions of the genome, such has highly
repetitive regions, are effectively “invisible” due to the inability to
confidently align short reads to them. In addition, different genome
fragmentation strategies may influence the mappable regions of a genome
in a given experiment. For example, when using a restriction enzyme (or
a cocktail of restriction enzymes) to fragment the genome, certain
regions deficient in the target recognition sequence(s) will have
comparatively fewer mapped reads than other regions.

To accurately calculate $p_i$ for a given set of sequencing conditions,
one really needs to know the <i>effective</i> genome length,
$L_{G_{eff}}$. Because mappable regions of the genome can depend on
things like fragmentation strategy, it is convenient to derive the
mappable genome using simulated genomic fragments that match both the
genome fragmentation method used and the sequencing approach.

This idea is not new. People doing integration site analyses have been
using simulated random datasets for many years in one way or another.
However, many of the scripts in use (at least that I have seen and
used), are rather slow and somewhat inflexible. After spending a
substantial amount of time adapting and eventually wholly rewriting some
existing Python scripts for random fragment generation, I decided to
develop an R approach that would slot seamlessly into the Bioconductor
framework. I’ve wrapped those functions up in the xInt package that is
still under development (as of 12/2022). This aspect of the package,
however, is functional. I’ll briefly explain the workflow below.

### Load packages

To get started, install xInt if it isn’t already.

``` r
devtools::install_github(repo = "gbedwell/xInt")
```

Next, load xInt and the [BSgenome
object](https://bioconductor.org/packages/release/bioc/html/BSgenome.html)
that corresponds to the genome of interest. In this example, I’ll be
using the new [CHM13v2
T2T](https://bioconductor.org/packages/release/data/annotation/html/BSgenome.Hsapiens.NCBI.T2T.CHM13v2.0.html)
human genome build.

``` r
library(xInt)
library(BSgenome.Hsapiens.NCBI.T2T.CHM13v2.0)
```

### Restriction enzyme cut positions

If fragmenting the genome by restriction digestion, the first step in
generating random genome fragments is to extract the sequences of each
chromosome.

``` r
chr.seqs <- get_chromosome_seqs( genome.obj = BSgenome.Hsapiens.NCBI.T2T.CHM13v2.0 )
```

The output of <code>get_chromosome_seqs()</code> is a list of DNAString
objects corresponding to each of the chromosomes in the target genome.

    #> $`1`
    #> 248387328-letter DNAString object
    #> seq: CACCCTAAACCCTAACCCCTAACCCTAACCCTAACC...AGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTT
    #> 
    #> $`2`
    #> 242696752-letter DNAString object
    #> seq: TAACCCTAACCCTAACCCTAACCCTAACCCTAACCC...TAGGGTTAGGGTTTAGGGGTTTAGGGTTAGGGTTAG

Next, you can use the <code>digest()</code> function to identify all of
the possible fragmentation positions on both forward and reverse strands
of each chromosome. You must supply the recognition sequences of the
enzymes being used as a character vector.

``` r
re.cuts <- digest( string.list = chr.seqs, 
                   re.sites=c( "TTAA","AGATCT" ) )
```

### Random integration site positions

Now you want to generate random positions-of-interest throughout the
genome. These positions could represent integration site locations,
binding site locations, etc. This step is the same regardless of the
fragmentation method used. First, define the number of sites that you
want to generate. For good estimation of the mappable genome, this
number should be rather high (e.g. $10^8-10^9$ sites). If you just want
a representative random dataset, however, this number can be much
smaller (e.g. $10^4-10^5$ sites). For example purposes, I’ll generate
$10^5$ sites.

``` r
rand.sites <- random_sites( n.sites = 1E5,
                            genome.obj = BSgenome.Hsapiens.NCBI.T2T.CHM13v2.0 )
```

### Generating genomic fragments

You now want to make genomic fragments that mimic the genomic fragments
obtained in your experiment. For restriction digestion, you want to use
the random sites and the restriction enzyme cut positions generated with
the <code>digest()</code> function to generate the fragments. Be sure to
set <code>random = FALSE</code> in <code>make_fragments()</code>.
Fragment coordinates are defined from the random position-of-interest to
the nearest <i>downstream</i> restriction enzyme cut position.

``` r
re.fragments <- make_fragments( insert.sites = rand.sites,
                                frag.sites = re.cuts,
                                random = FALSE,
                                genome.obj = BSgenome.Hsapiens.NCBI.T2T.CHM13v2.0 )
```

For random fragmentation, you want to set <code>frag.sites = NULL</code>
and <code>random = TRUE</code> in <code>make_fragments()</code>. You
also want to set the mean ± sd fragment lengths (default values of 500
bp and 250 bp, respectively). Fragments lengths are randomly sampled
from a log-normal distribution with the defined parameters and fragment
end positions are calculated relative to each simulated random
integration site.

``` r
rand.fragments <- make_fragments( insert.sites = rand.sites,
                                  frag.sites = NULL, 
                                  random = TRUE,
                                  mean = 500, 
                                  sd = 250,
                                  genome.obj = BSgenome.Hsapiens.NCBI.T2T.CHM13v2.0 )
```

### Extracting and trimming fragment sequences

I rely on <code>BSgenome::getSeq()</code> to extract the sequences
corresponding to the fragment positions. These sequences are intended to
mimic the genomic fragments sequenced in the sequencing reaction.

``` r
frag.seqs <- getSeq( x = BSgenome.Hsapiens.NCBI.T2T.CHM13v2.0,
                     names = rand.fragments,
                     as.character = FALSE )
```

    #> DNAStringSet object of length 100000:
    #>          width seq
    #>      [1]   512 AAGGAAGAGAGAGCCGGGGGAGGTGGCGGGC...CCGCCAGGCCTGGGCATCTCCTCTCCTGCAG
    #>      [2]   448 TCATTGGAATTTTTTCTGTTAGTTAAATAAA...TGCACACCAGATGTGGCCCAATTGTTAATAA
    #>      [3]   495 TGAGAGGCCCTAGTGTGTGTTGTTCCCCTCC...GAGGCCCTGGTGTGTGTTGTTCCCCTCCATG
    #>      [4]   434 GTGCAAGCCTCAAGCTTTGGCAGCTTCCATG...ACCATGGGAACCCACCACTTGCATGAGTATG
    #>      [5]   759 CCAGCCTGGGTGACAGAGTGAGACCCTGTCT...GCTCAAACTTCAGCATTCCGAGTAGCTGGGA
    #>      ...   ... ...
    #>  [99996]   332 CAGTGTGACTATATTTGGAGACAAGGCCTTT...ATACCTGGTTTATATCATAGTCCCTTTCCCT
    #>  [99997]   326 TGTTCTTCTGATCTTCTGGTACCTGCCTTCC...TGGGAAGCAACCCAGTATCTTTGTCTATCTT
    #>  [99998]   281 GATTTTGGAAATTAAAACTGAAAGAGAGCCT...CATTCATAAAAACTAGAAACACAGTTAAAAG
    #>  [99999]   760 AGAAACGGGATTTCACCATGTTGCCCAGGGT...AGACTGTGTGTTCTGTTATATTTCTCTGGAG
    #> [100000]   904 CCACTGACATGACTTTCCAAAAAACACATAA...CAAACCCCCTGAAGCTTCACCGGCGCAGTCA

To mimic the sequencing output, however, the genomic fragments must be
trimmed. The function <code>trim_seqs()</code> will trim the ends of
each fragment to the maximum desired length and return the paired reads
as matched entries in one of two list elements. The first list element
corresponds to forward reads and the second list element corresponds to
reverse reads. The reverse reads are returned in 5’ to 3’ orientation.

In addition to defining the maximum read length,
<code>trim_seqs()</code> has options to define the minimum fragment
width (default 14 bp) and the maximum inner distance between pairs
(default 1000 bp). These filtering parameters will decrease the number
of output read pairs, so don’t be alarmed if the lengths of the
<code>trim_seqs()</code> list elements is less than the number of
generated sites.

``` r
frag.trim <- trim_seqs( fragments = frag.seqs,
                        min.width = 14,
                        max.distance = 1000,
                        max.bp = 150 )
```

    #> [[1]]
    #> DNAStringSet object of length 98797:
    #>         width seq                                           names               
    #>     [1]   150 AAGGAAGAGAGAGCCGGGGGA...CCTGAGCCCACCCTTCGCGGC sequence_1
    #>     [2]   150 TCATTGGAATTTTTTCTGTTA...GCAAACAAGGATCTTCTATCC sequence_2
    #>     [3]   150 TGAGAGGCCCTAGTGTGTGTT...ATGGTCTCCTACCCCCTGTCC sequence_3
    #>     [4]   150 GTGCAAGCCTCAAGCTTTGGC...AGAAGTTTGCTGCAGGGGTGA sequence_4
    #>     [5]   150 CCAGCCTGGGTGACAGAGTGA...CTTACCAACTCTGTCTTCAGT sequence_5
    #>     ...   ... ...
    #> [98793]   150 CAGTGTGACTATATTTGGAGA...CCACCTGAGAACACAGCAAGA sequence_98793
    #> [98794]   150 TGTTCTTCTGATCTTCTGGTA...CTGGATTCACGCTGATATACA sequence_98794
    #> [98795]   150 GATTTTGGAAATTAAAACTGA...ATGGATAAAACTGGAATTTGA sequence_98795
    #> [98796]   150 AGAAACGGGATTTCACCATGT...TTAAGATGCACTTTTTGCTTA sequence_98796
    #> [98797]   150 CCACTGACATGACTTTCCAAA...TTTTCCTCCGACCCCCTAACA sequence_98797
    #> 
    #> [[2]]
    #> DNAStringSet object of length 98797:
    #>         width seq                                           names               
    #>     [1]   150 CTGCAGGAGAGGAGATGCCCA...GGCGGCGCTGCAGGAGAGGAG sequence_1
    #>     [2]   150 TTATTAACAATTGGGCCACAT...AGAGGATGCCTATCAGACTAA sequence_2
    #>     [3]   150 CATGGAGGGGAACAACACACA...GACCATCAAGACAAACACGTG sequence_3
    #>     [4]   150 CATACTCATGCAAGTGGTGGG...CAAGCTGTCGGTGATCTACCA sequence_4
    #>     [5]   150 TCCCAGCTACTCGGAATGCTG...ATTTACAGACAGAAAAGAAAT sequence_5
    #>     ...   ... ...
    #> [98793]   150 AGGGAAAGGGACTATGATATA...CGCTAATTCAGTTCTTGATGA sequence_98793
    #> [98794]   150 AAGATAGACAAAGATACTGGG...CTTCTCAAGTATAATAAACAG sequence_98794
    #> [98795]   150 CTTTTAACTGTGTTTCTAGTT...TTTCAAATTCCAGTTTTATCC sequence_98795
    #> [98796]   150 CTCCAGAGAAATATAACAGAA...TCAATGAAGATTGACTTCCAG sequence_98796
    #> [98797]   150 TGACTGCGCCGGTGAAGCTTC...TAATTATGCCTCATAGGGATA sequence_98797

### Generating fasta files

Finally, now that your pairs have been generated, you can save the pairs
as R1 and R2 fasta files for genome alignment. The <code>compress</code>
option in <code>save_fasta()</code> will compress the fasta files to
save space. Given the input parameters below, the files will be saved as
<code>path/to/directory/prefix_R1.fa(.gz)</code> and
<code>path/to/directory/prefix_R2.fa(.gz)</code>, respectively.

``` r
save_fasta( reads = frag.trim,
            directory.path = "path/to/directory",
            file.prefix = "prefix",
            compress = TRUE )
```

### Conclusions

On my 2 GHz quad-core laptop with 16 GB RAM, this entire process ran in
just over 2 minutes. Obviously, as you increase the number of random
sites generated, this run time will increase. For generating extremely
large datasets, I would recommend moving this to an HPC cluster.
Regardless of where you run this, I hope I’ve demonstrated how easy it
can be to generate random genome fragments in a way that should
integrate seamlessly with your other Bioconductor workflows!

### Addendum: 08/01/2023

A wrapper function, <code>simulate_random_data()</code>, has been
included in the package that automatically calls all of these functions.
There are some convenient additions to this function that are not part
of the other functions, including the ability to simultaneously generate
multiple random datasets. Concatenating multiple smaller random datasets
together is a convenient and reasonably quick way to generate extremely
large random datasets. The general syntax of this function is below. The
source code with argument descriptions can be found on
[GitHub](https://github.com/gbedwell/xInt/blob/master/R/simulate_random_data.R).

``` r
simulate_random_data( genome.obj,
                      re.sites = NULL,
                      cut.after = 1,
                      n.sites,
                      mean,
                      sd,
                      min.width = 14,
                      max.distance = 1000,
                      max.bp = 150,
                      iterations = 1,
                      n.cores = 1,
                      write.ranges = FALSE,
                      prefix = NULL,
                      directory.path = NULL,
                      compress = TRUE,
                      collapse = TRUE )
```
