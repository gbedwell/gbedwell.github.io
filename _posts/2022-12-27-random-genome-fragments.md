---
title: Generating random genome fragments in R
excerpt: Quickly and easily generating simulated random fragments of a chosen genome.
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

In the analysis of genomic integration site data, a theoretical random
integration site distribution is often used as a lower boundary for
feature enrichment. That is, whether or not a given feature (e.g. a
particular gene) harbors more integration sites than would be expected
given a uniform random distribution. In principle, the derivation of an
expected random distribution is not too difficult. Given the genome
size, $L_G$, the probability of integration into a particular region $i$
is simply $p_i = L_i/L_G$, where $L_i$ is the length of $i$. Therefore,
the expected number of integration sites in $i$ can be expressed as
$I \sim Bin(n, p_i)$.

In reality, however, the entire genome is rarely accessible by common
next-generation sequencing technologies. While long-read sequencing is
growing in both accessibility and throughput, it is still common for
integration site mapping to be done using e.g. 150 bp paired-end
sequencing. Because of this, certain regions of the genome, such has
highly repetitive regions, are effectively “invisible” due to the
inability to confidently align short reads to them. In addition,
different genome fragmentation strategies may influence the mappable
regions of a genome in a given experiment. For example, when using a
restriction enzyme (or a cocktail of several restriction enzymes) to
fragment the genome, certain regions deficient in the target recognition
sequence(s) will have comparatively fewer mapped reads than other
regions.

To accurately calculate $p_i$ for a given set of sequencing conditions,
one really needs to know the <i>effective</i> genome length,
$L_{G_{eff}}$. Because mappable regions of the genome can depend on
things like fragmentation strategy, it is convenient to be able to
easily estimate the mappable genome using simulated genomic fragments
that match both the genome fragmentation method used and the sequencing
approach.

This idea is not new. People doing integration site analyses have been
using simulated random datasets for many years in one way or another.
However, many of the scripts in use (at least that I have seen), are
rather slow, somewhat inflexible, and are provided as stand alone
software. After spending a substantial amount of time adapting and
eventually wholly rewriting some existing Python scripts for random
fragment generation, I decided to develop an R approach that would slot
seamlessly into the Bioconductor framework. I’ve wrapped those functions
up in the xInt package that is still under development (as of 12/2022).
This aspect of the package, however, is functional. I’ll briefly explain
the workflow below.

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

Now you want to generate random integration sites throughout the genome.
This step is the same regardless of the fragmentation method used.
First, define the number of sites that you want to generate. For good
estimation of the mappable genome, this number should be rather high
(e.g. $10^7-10^8$ sites). If you just want a representative random
dataset, however, this number can be much smaller (e.g. $10^4-10^5$
sites). For example purposes, I’ll generate $10^5$ sites.

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
Fragment coordinates are defined from the simulated random integration
site to the nearest restriction enzyme cut position <i>downstream</i> of
the integration site. This is analogous to sequencing off of the viral
3’ LTR. I have not yet incorporated a way to simulate fragments
generated from the viral 5’ LTR.

``` r
re.fragments <- make_fragments( int.sites = rand.sites,
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
rand.fragments <- make_fragments( int.sites = rand.sites,
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
    #>      [1]   414 CCTTCTCAATCTGCAAGAAAAATGTAGAAGG...CCCCCAACTCCAGTTCATGTTTTTCCCTCCA
    #>      [2]   201 GGGCCTGTTGCACTGTGTTGTTGTGGGGCGG...AGAGTCAAACTCAGTAAAATATTTGAAGAGA
    #>      [3]   808 GAGGATCGCTTCAGCCTGGAAGGTTGAGGCT...TGAGACCCCGTGTCTACAAAACAATTTAAAA
    #>      [4]   378 ACCGAATGGAATGGAATGGACTTGAATGGAA...GGAATGGAATGCAATGGAATGCACTCGAACG
    #>      [5]   369 TCTAACACATGAAAATCAGTGTAATATCACA...TATTCCAATTTTTTAAAAAGTAAAATTATCT
    #>      ...   ... ...
    #>  [99996]   303 AGAGACGAGCCCTCACCAGACATGGAATCTT...ACATGGATGTATTTAACAATTTAGAAACTCT
    #>  [99997]   292 CTCCTCCCAGGTTCAAGCAATTCTTCTGCCT...TCCAAATTTCCCCTTTTTAAAATCACAATAA
    #>  [99998]   452 CAGTGACATGATCTTGGCTCACTGCAACCTG...TCTCATCCACACAGCGGCAGTCACTTTGCGG
    #>  [99999]   701 CGGGTTCGGGTTCGGGTTCGGGTTCGGGTTA...AGGGTTAGGGTTAGGGTTAGGGTTAGGGGTT
    #> [100000]   424 TGTGAGAAGAAGCAGGCCGGATGTCAGAGGG...AATTAGTACGGGAAGGGTATAACCAACATTT

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
    #> DNAStringSet object of length 98820:
    #>         width seq                                           names               
    #>     [1]   150 CCTTCTCAATCTGCAAGAAAA...TATTGCCCGAGCTGGAGTGAG sequence_1
    #>     [2]   150 GGGCCTGTTGCACTGTGTTGT...GTGATCAAAGAAAATCATTTC sequence_2
    #>     [3]   150 GAGGATCGCTTCAGCCTGGAA...AATGAGGTCTGCTGGGCAAAA sequence_3
    #>     [4]   150 ACCGAATGGAATGGAATGGAC...AATGGAATACAATGGAATTTA sequence_4
    #>     [5]   150 TCTAACACATGAAAATCAGTG...ATAAAAAGAAAGAAAACACCT sequence_5
    #>     ...   ... ...
    #> [98816]   150 AGAGACGAGCCCTCACCAGAC...CCTGAAAGGACTAAGACCCCA sequence_98816
    #> [98817]   150 CTCCTCCCAGGTTCAAGCAAT...GGTCTCAAACTCCTGATATCA sequence_98817
    #> [98818]   150 CAGTGACATGATCTTGGCTCA...ATAGACGCGGTTTCACCATGT sequence_98818
    #> [98819]   150 CGGGTTCGGGTTCGGGTTCGG...TTAGAGTTAGAGTTAGAGGGT sequence_98819
    #> [98820]   150 TGTGAGAAGAAGCAGGCCGGA...AGTATTGGTTATGGTTCATTG sequence_98820
    #> 
    #> [[2]]
    #> DNAStringSet object of length 98820:
    #>         width seq                                           names               
    #>     [1]   150 TGGAGGGAAAAACATGAACTG...CCCTCTGGGGCAGCCCGGAAC sequence_1
    #>     [2]   150 TCTCTTCAAATATTTTACTGA...ATGAGAGAGGGAGATGGCTCC sequence_2
    #>     [3]   150 TTTTAAATTGTTTTGTAGACA...TCAATTTTCTAAAAAAGAAAT sequence_3
    #>     [4]   150 CGTTCGAGTGCATTCCATTGC...CTATTCCATTCGAGTCCATTC sequence_4
    #>     [5]   150 AGATAATTTTACTTTTTAAAA...TGAGGGTAAAAGCTTTCAGTC sequence_5
    #>     ...   ... ...
    #> [98816]   150 AGAGTTTCTAAATTGTTAAAT...TTTACCATGTCCTTTATAATG sequence_98816
    #> [98817]   150 TTATTGTGATTTTAAAAAGGG...CAGACGGATCACTTGATATCA sequence_98817
    #> [98818]   150 CCGCAAAGTGACTGCCGCTGT...CTGTGGATTTTGGAAATTACG sequence_98818
    #> [98819]   150 AACCCCTAACCCTAACCCTAA...CCCTAACCCTAACCCTAACCC sequence_98819
    #> [98820]   150 AAATGTTGGTTATACCCTTCC...AATAAACATGCTAGCTTTTAT sequence_98820

### Generating fasta files

Finally, now that your pairs have been generated, you can save the pairs
as R1 and R2 fasta files for genome alignment. The <code>compress</code>
option in <code>save_fasta()</code> will compress the fasta files to
save space. Given the input parameters below, the files will be saved as
<code>path/to/directory/prefix_R1.fa(.gz)</code> and
<code>path/to/directory/prefix_R2.fa(.gz)</code>, respectively.

``` r
save_fasta( trimmed.seqs = frag.trim,
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
integrate (lol, get it?!) seamlessly with your other Bioconductor
workflows!
