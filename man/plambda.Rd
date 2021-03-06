% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Utilities.R
\name{plambda}
\alias{plambda}
\title{Construct diagonal matrix according to break date}
\usage{
plambda(b, m, bigT)
}
\arguments{
\item{b}{Estimated date of changes}

\item{m}{Number of breaks}

\item{bigT}{The sample size T}
}
\value{
lambda (m+1) by (m+1) diagonal matrix
with i-th entry \eqn{\frac{T_{i} - T_{i-1}}{ T}}
}
\description{
Function constructs a diagonal matrix of dimension (m+1) by (m+1) matrix
with i-th entry \eqn{\frac{T_{i} - T_{i-1}}{ T}}
}
