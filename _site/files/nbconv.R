library(nbconv)
library(ggplot2)
library(magrittr)
library(tidyr)
library(dplyr)
library(patchwork)

### CREATE DATA ###
set.seed(1234)
mus <- rgamma(n = 25, shape = 3.5, scale = 3.5)

set.seed(1234)
phis1 <- rgamma(n = 25, shape = 2, scale = 4)

set.seed(1234)
phis3 <- rgamma(n = 25, shape = 1, scale = 4)

phis2 <- phis3
phis2[ phis2 < 0.1 ] <- 0.1

phis <- cbind( phis1, phis2, phis3 )

# Calculate convolution parameters for each dispersion mixture.
params <- apply(X = phis, 
                MARGIN = 2, 
                FUN = function(x){ nbconv_params( mus = mus, phis = x ) } )

colnames( params ) <- c( "Convolution 1", "Convolution 2", "Convolution 3" )

t( params )

# Sample empirical data
samps <- apply(X = phis, 
               MARGIN = 2, 
               FUN = function(x){ rnbconv( mus = mus, phis = x, n.samp = 1e6 ) } )
n = 700

### CALCULATE PMFs ###
# Calculate empirical PMF from samples
empirical.pmf <- apply(X = samps,
                       MARGIN = 2,
                       FUN = function(x){
                         stats::density(x = x, from = 0, to = n, n = n + 1)$y
                         } )

# Calculate convolution PMF using Furman's exact method.
exact.pmf <- apply(X = phis, 
                   MARGIN = 2, 
                   FUN = function(x){ dnbconv( mus = mus, 
                                               phis = x, 
                                               counts = 0:n, 
                                               method = "exact", 
                                               n.terms = 5000, 
                                               n.cores = 4 ) } )

# Calculate convolution PMF using saddlepoint approximation.
saddlepoint.pmf <- apply(X = phis, 
                         MARGIN = 2, 
                         FUN = function(x){ dnbconv( mus = mus, 
                                                     phis = x, 
                                                     counts = 0:n, 
                                                     method = "saddlepoint",
                                                     n.cores = 4,
                                                     normalize = TRUE ) } )

# Calculate convolution PMF using method of moments.
moments.pmf <- apply(X = phis, 
                     MARGIN = 2, 
                     FUN = function(x){ dnbconv( mus = mus, 
                                                 phis = x, 
                                                 counts = 0:n, 
                                                 method = "moments" ) } )

lpmf <- list(empirical.pmf, exact.pmf, saddlepoint.pmf, moments.pmf)
names(lpmf) <- c("empirical", "exact", "saddlepoint", "moments")


### CALCULATE CDFs ###
# Calculate empirical CDF from samples
empirical.cdf <- apply(X = empirical.pmf,
                       MARGIN = 2,
                       FUN = function(x){
                         ecdf <- cumsum( x ) 
                         # Renormalize so that the maximum value is exactly 1.
                         # The noise in the empirical PMF makes the maximum value slightly > 1.
                         # ecdf / max( ecdf )
                         return( ecdf )
                       } )

# Calculate convolution CDF using Furman's exact method.
exact.cdf <- apply(X = phis, 
                   MARGIN = 2, 
                   FUN = function(x){ pnbconv( mus = mus, 
                                               phis = x, 
                                               quants = 0:n, 
                                               method = "exact", 
                                               n.terms = 5000, 
                                               n.cores = 4 ) } )

# Calculate convolution CDF using saddlepoint approximation.
saddlepoint.cdf <- apply(X = phis, 
                         MARGIN = 2, 
                         FUN = function(x){ pnbconv( mus = mus, 
                                                     phis = x, 
                                                     quants = 0:n, 
                                                     method = "saddlepoint",
                                                     n.cores = 4,
                                                     normalize = TRUE ) } )

# Calculate convolution CDF using method of moments.
moments.cdf <- apply(X = phis, 
                     MARGIN = 2, 
                     FUN = function(x){ pnbconv( mus = mus, 
                                                 phis = x, 
                                                 quants = 0:n, 
                                                 method = "moments" ) } )

lcdf <- list(empirical.cdf, exact.cdf, saddlepoint.cdf, moments.cdf)
names(lcdf) <- c("empirical", "exact", "saddlepoint", "moments")



### PLOTS ###
## PMF PLOTS ##
# Make data frame for plotting PMFs
lpmf.df <- lapply(X = lpmf,
                  FUN = function(x){
                    dat <- data.frame(x)
                    colnames(dat) <- paste0("dist",1:ncol(x))
                    dat$count <- 0:n
                    df <- tidyr::pivot_longer(data = dat,
                                              cols = !count,
                                              names_to = "distribution",
                                              values_to = "probability") %>%
                      dplyr::arrange(distribution)
                     }
                   )

lpmf.df <- Map(cbind, lpmf.df, method = c("empirical", "exact", "saddlepoint", "moments"))

pmf.df <- do.call( rbind, lpmf.df )
rownames(pmf.df) <- NULL

pmf.df$method <- factor( pmf.df$method, levels = c("empirical", "exact", "saddlepoint", "moments") )

shapes <- paste0("Convolution ", 1:length( unique(pmf.df$distribution) ))
names(shapes) <- unique(pmf.df$distribution)

p2 <- ggplot(data = pmf.df,
             aes(x = count, y = probability , fill = method ) ) +
  geom_line(data = pmf.df[pmf.df$method == "empirical",],
            aes(x = count, y = probability ),
            linewidth = 1.5,
            color = "gray50",
            inherit.aes = FALSE) +   
  geom_area(data = pmf.df[pmf.df$method == "empirical",],
              aes(x = count, y = probability ),
              color = "gray50", fill="gray50",
              inherit.aes = FALSE, alpha = 0.5 ) +  
  # geom_ribbon(data = pmf.df[pmf.df$method == "empirical",],
  #             aes(x = count, ymin = 0, ymax = probability ),
  #             color = "gray50", fill="gray50",
  #             inherit.aes = FALSE, alpha = 0.5 ) + 
  geom_point(shape = 21, size = 1, color = "#00000000") +
  scale_fill_manual(values = c("gray50","darkblue","darkred","darkgreen"),
                     labels = c("Empirical", "Exact", "Saddlepoint", "Moments"),
                     guide = guide_legend(title.position = "top",
                                          title.hjust = 0.5,
                                          override.aes = list( size = 2 ) ) ) +
  facet_wrap(vars(distribution), 
             labeller = labeller(distribution = shapes) ) +
  theme_bw() +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        # axis.text.x = element_text(angle = 30, hjust = 1),
        strip.text = element_text(size = 12),
        legend.position = "top",
        legend.title = element_blank(),
        legend.key.size = unit(3, "point"),
        panel.spacing = unit(1, "lines") ) +
  labs(x = "Counts", y = "Probability")

p2.log <- ggplot(data = pmf.df[pmf.df$method != "empirical",],
                 aes(x = count, y = log( probability ) , fill = method ) ) +
  geom_line(data = pmf.df[pmf.df$method == "empirical",],
            aes(x = count, y = log( probability ) ),
            linewidth = 1.5,
            color = "gray50",
            inherit.aes = FALSE) +   
  # geom_area(data = pmf.df[pmf.df$method == "empirical",],
  #           aes(x = count, y = log( probability ) ),
  #           color = "gray50", fill="gray50",
  #           inherit.aes = FALSE, alpha = 0.5 ) +  
  geom_ribbon(data = pmf.df,
              aes(x = count, ymin = -30, ymax = log( probability ) ),
              color = "gray50", fill="gray50",
              inherit.aes = FALSE, alpha = 0.5, outline.type = "upper" ) +
  geom_point(shape = 21, size = 1, color = "#00000000") +
  scale_fill_manual(values = c("gray50","darkblue","darkred","darkgreen"),
                    labels = c("Empirical", "Exact", "Saddlepoint", "Moments"),
                    guide = guide_legend(title.position = "top",
                                         title.hjust = 0.5,
                                         override.aes = list( size = 2 ) ) ) +
  facet_wrap(vars(distribution), 
             labeller = labeller(distribution = shapes) ) +
  theme_bw() +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        # axis.text.x = element_text(angle = 30, hjust = 1),
        strip.text = element_text(size = 12),
        legend.position = "top",
        legend.title = element_blank(),
        legend.key.size = unit(3, "point"),
        panel.spacing = unit(1, "lines") ) +
  scale_y_continuous(limits = c(-30, 0)) +
  labs(x = "Counts", y = "log(Probability)")

# ggsave( filename = "pmf_log_plot.png",
#         path = "~/Documents/github/nbconv_manuscript/arxiv/figures/",
#         plot = p2.log,
#         device = "png",
#         height = 4,
#         width = 7,
#         units = "in",
#         dpi = 300 )

## CDF PLOTS ##
# Make data frame for plotting CDFs
lcdf.df <- lapply(X = lcdf,
                  FUN = function(x){
                    dat <- data.frame(x)
                    colnames(dat) <- paste0("dist",1:ncol(x))
                    dat$count <- 0:n
                    df <- tidyr::pivot_longer(data = dat,
                                              cols = !count,
                                              names_to = "distribution",
                                              values_to = "probability") %>%
                      dplyr::arrange(distribution)
                  }
)

lcdf.df <- Map(cbind, lcdf.df, method = c("empirical", "exact", "saddlepoint", "moments"))

cdf.df <- do.call( rbind, lcdf.df )
rownames(cdf.df) <- NULL

cdf.df$method <- factor( cdf.df$method, levels = c("empirical", "exact", "saddlepoint", "moments") )

shapes <- paste0("Convolution ", 1:length( unique(cdf.df$distribution) ))
names(shapes) <- unique(cdf.df$distribution)

p3 <- ggplot(data = cdf.df,
             aes(x = count, y = probability , fill = method ) ) +
  geom_line(data = cdf.df[cdf.df$method == "empirical",],
            aes(x = count, y = probability ),
            linewidth = 1.5,
            color = "gray50",
            inherit.aes = FALSE) +   
  geom_area(data = cdf.df[cdf.df$method == "empirical",],
            aes(x = count, y = probability ),
            color = "gray50", fill="gray50",
            inherit.aes = FALSE, alpha = 0.5 ) + 
  geom_point(shape = 21, size = 1, color = "#00000000") +
  scale_fill_manual(values = c("gray50","darkblue","darkred","darkgreen"),
                    labels = c("Empirical", "Exact", "Saddlepoint", "Moments"),
                    guide = guide_legend(title.position = "top",
                                         title.hjust = 0.5,
                                         override.aes = list( size = 2 ) ) ) +
  facet_wrap(vars(distribution), 
             labeller = labeller(distribution = shapes) ) +
  theme_bw() +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        # axis.text.x = element_text(angle = 30, hjust = 1),
        strip.text = element_text(size = 12),
        legend.position = "top",
        legend.title = element_blank(),
        legend.key.size = unit(3, "point"),
        panel.spacing = unit(1, "lines") ) +
  labs(x = "Counts", y = "Probability")

# ggsave( filename = "cdf_plot.png",
#         path = "~/Documents/github/nbconv_manuscript/arxiv/figures/",
#         plot = p3,
#         device = "png",
#         height = 4,
#         width = 7,
#         units = "in",
#         dpi = 300 )

## Q-Q PLOTS ##
# Calculate empirical quantiles
empirical.quants <- apply(X = empirical.cdf,
                          MARGIN = 2,
                          FUN = function(x){ 
                            sapply(X = seq(0.005, 0.995, 0.005),
                                   FUN = function(y){
                                     max( which( x <= y ) - 1 )
                                   })
                          })
  
# Calculate convolution quantiles using the exact method.
exact.quants <- apply(X = phis, 
                      MARGIN = 2, 
                      FUN = function(x){ qnbconv( mus = mus, 
                                                  phis = x, 
                                                  probs = seq(0.005, 0.995, 0.005),
                                                  counts = 0:n,
                                                  method = "exact", 
                                                  n.terms = 5000, 
                                                  n.cores = 4 ) } )

# Calculate convolution quantiles using saddlepoint approximation.
saddlepoint.quants <- apply(X = phis, 
                         MARGIN = 2, 
                         FUN = function(x){ qnbconv( mus = mus, 
                                                     phis = x, 
                                                     probs = seq(0.005, 0.995, 0.005),
                                                     counts = 0:n, 
                                                     method = "saddlepoint",
                                                     n.cores = 4,
                                                     normalize = TRUE ) } )

# Calculate convolution quantiles using method of moments.
moments.quants <- apply(X = phis, 
                     MARGIN = 2, 
                     FUN = function(x){ qnbconv( mus = mus, 
                                                 phis = x, 
                                                 probs = seq(0.005, 0.995, 0.005),
                                                 counts = 0:n, 
                                                 method = "moments" ) } )

lquants <- list(empirical.quants, exact.quants, saddlepoint.quants, moments.quants)
names(lquants) <- c("empirical", "exact", "saddlepoint", "moments")

lquants.df <- lapply(X = lquants,
                  FUN = function(x){
                    dat <- data.frame(x)
                    colnames(dat) <- paste0("dist",1:ncol(x))
                    df <- tidyr::pivot_longer(data = dat,
                                              cols = everything(),
                                              names_to = "distribution",
                                              values_to = "quantiles") %>%
                      dplyr::arrange(distribution)
                    }
                  )

lquants.df <- Map(cbind, lquants.df[2:4], emp.quantiles = lquants.df[1]$empirical[,2] )

lquants.df <- Map(cbind, lquants.df, method = c("exact", "saddlepoint", "moments"))

quants.df <- do.call( rbind, lquants.df )
rownames(quants.df) <- NULL

quants.df$method <- factor( quants.df$method, levels = c("exact", "saddlepoint", "moments") )

shapes <- paste0("Convolution ", 1:length( unique(quants.df$distribution) ))
names(shapes) <- unique(quants.df$distribution)

p4 <- ggplot(data = quants.df,
             aes(x = emp.quantiles, y = quantiles , fill = method ) ) +
  geom_abline(intercept = 0, slope = 1, size = 0.25) +
  geom_point(shape = 21, size = 2, color = "#00000000") +
  scale_fill_manual(values = c("darkblue","darkred","darkgreen"),
                    labels = c("Exact", "Saddlepoint", "Moments"),
                    guide = guide_legend(title.position = "top",
                                         title.hjust = 0.5,
                                         override.aes = list( size = 2 ) ) ) +
  facet_wrap(vars(distribution), 
             labeller = labeller(distribution = shapes) ) +
  theme_bw() +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        strip.text = element_text(size = 12),
        legend.position = "top",
        legend.title = element_blank(),
        legend.key.size = unit(3, "point"),
        panel.spacing = unit(1, "lines") ) +
  labs(x = "Empirical Quantiles", y = "Calculated Quantiles")


distplots <- p2 + p3 + p4 + 
  plot_layout(ncol = 1) + 
  plot_annotation(tag_levels = "A") &
  theme(plot.tag = element_text(face = "bold", size = 18))

ggsave( filename = "fig1.png",
        path = "~/Documents/github/nbconv_manuscript/arxiv/",
        plot = distplots,
        device = "png",
        height = 12,
        width = 3.5*ncol(phis),
        units = "in",
        dpi = 300 )

mad <- sapply(X = c("lpmf", "lcdf", "lquants"),
              FUN = function(x){
                sapply(X = 2:4,
                       FUN = function(y){
                         sapply(X = 1:ncol(phis),
                                FUN = function(z){
                                  obj <- eval(parse(text = x))
                                  mean(abs(obj[[1]][,z] - obj[[y]][,z])) # / mean(abs(obj[[1]][,z]))
                                  })
                         })
                })

labs <- sapply(X = c("exact", "sp", "mom"),
               FUN = function(x){
                 paste0(x, "-", paste0("C",1:ncol(phis)))
                 })

rownames(mad) <- c(labs[,1:ncol(labs)])

tmad <- t(mad)















