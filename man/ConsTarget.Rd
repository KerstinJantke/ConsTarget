\name{ConsTarget}
\alias{ConsTarget}

\title{ConsTarget - Calculate Conservation Target Achievement}

\description{
This package is used to calculate two different metrics of conservation target achievement. It comes with the two functions mpg and mta. mpg function: The mean protection gap (MPG) function determines the degree of conservation target shortfall as a value between 0 and 1. mta function: The mean target achievement (MTA) function determines the degree of conservation target achievement as a value between 0 and 1.
}

\details{

\tabular{rlll}{
    \tab Package:   \tab ConsTarget \cr
    \tab Type:      \tab Package \cr
    \tab Version:   \tab 0.1 \cr
    \tab Date:      \tab 2018-08-13\cr
    \tab License:   \tab GPL 2 | GPL 3\cr
    \tab Lazyload:  \tab yes
  }
}


\author{Kerstin Jantke <kerstin.jantke@uni-hamburg.de>}

\examples{
# Generate input data
feature <- paste("Ecoregion",1:10)  #conservation feature names
ai           <- c(41,223,1053,520,230,303,343,2684,6507,1010)  #total amount of conservation features
pi           <- c(0,53,282,237,70,5,123,606,2695,496)  #protected amount of conservation features
data      <- data.frame(feature,ai,pi)

# Run the mpg function for conservation target 0.3 (30\% protection of each feature)
mpg(data,0.3,plot=TRUE)

# Run the mta function for conservation target 0.5 (50\% protection of each feature)
mta(data,0.5,plot=FALSE)
}
