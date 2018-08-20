#' Mean Target Achievement (MTA) Function
#'
#' The mean target achievement (MTA) function determines the degree of representation target achievement as a value between 0 and 1.
#' @param data data is a dataframe with three columns: feature, ai, and pi. feature is the name of the conservation features (e.g. ecoregions, habitats, species), ai is the total area/amount of conservation features, and pi is the protected area/amount of conservation features.
#' @param target target is the representation target as a value between 0 and 1 (0 is zero protection and 1 is 100\% protection).
#' @param plot plots the  target and the protected amount of conservation features ordered from low to high. Defaults to TRUE.
#' @return \tabular{rlll}{\tab \code{mta}   \tab Mean Target Achievement value (0 is no achievement and 1 is 100\% achievement of representation target) \cr \tab \code{target} \tab representation target \cr \tab \code{N} \tab number of conservation features \cr \tab \code{proportion_protected}  \tab protected proportion of conservation features as a value from 0 to 1, sorted from low to high}
#' @keywords conservation representation target protection
#' @export
#' @examples
#' # Generate input data
#' feature <- paste("Ecoregion",1:10)  #conservation feature names
#' ai      <- c(41,223,1053,520,230,303,343,2684,6507,1010)  #total amount of conservation features
#' pi      <- c(0,53,282,237,70,5,123,606,2695,496)  #protected amount of conservation features
#' data    <- data.frame(feature,ai,pi)
#'
#' # Run the mta function for representation target 0.5 (50% protection of each feature)
#' mta(data,0.5,plot=FALSE)

mta <- function(data = list(), target, plot = TRUE) {
  if (target < 0 | target > 1) {
    stop("Target is not between 0 and 1 - cannot compute metric")
  }

  pi_delete<- which(is.na(data$pi))
  if (length(pi_delete) > 0) {
    data <- data[-pi_delete, ]
    warning("NAs in pi column. Number of rows deleted:", length(pi_delete))
  }

  ai_delete<- which(is.na(data$ai))
  if (length(ai_delete) > 0) {
    data <- data[-ai_delete, ]
    warning("NAs in ai column. Number of rows deleted:", length(ai_delete))
  }

  N <- length(data$pi)
  pi <- data$pi
  ai <- data$ai

  if (sum(data$ai) == 0) {
    stop("All ai equal 0 - cannot compute metric")
  }
  if (sum(data$ai) < sum(data$pi)) {
    stop("ai smaller than pi - cannot compute metric")
  }

  MTA <- sum((pmin(((pi / ai) / (target) ), 1)) / N)

  pi_ai <- pi/ai
  prepdf <- cbind.data.frame(data, pi_ai)
  sorteddf <- prepdf[order(prepdf$pi_ai), ]
  feature <- sorteddf$feature

  proportion_protected <- cbind.data.frame(sorteddf$feature,sorteddf$pi_ai)
  names(proportion_protected) <- c("conservation_feature","proportion_protected")

  if (plot == TRUE) {
    p <- ggplot(sorteddf, aes(reorder(feature,pi_ai),pi_ai*100)) + geom_bar(stat = 'identity', col = "black", fill = "lightgrey", width = 1) +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
            axis.title = element_text(size = 15),
            axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(hjust = 1, size = 12)) +
      scale_y_continuous(breaks = seq(0,100,10), limits = c(0,100), expand = c(0,0))+
      scale_x_discrete(expand = c(0,0))+
      geom_hline(yintercept = target*100, linetype = "longdash") +
      ylab("protected amount (%)") + xlab("conservation feature")
    print(p)
  }

  list(MTA = MTA, target = target, N = N, proportion_protected = proportion_protected)
}
