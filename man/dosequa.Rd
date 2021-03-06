% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Procedures.R
\name{dosequa}
\alias{dosequa}
\title{Sequential procedure}
\usage{
dosequa(
  y,
  z,
  x,
  m,
  eps,
  eps1,
  maxi,
  fixb,
  betaini,
  printd,
  prewhit,
  robust,
  hetdat,
  hetvar
)
}
\arguments{
\item{y}{dependent variables in matrix form}

\item{z}{matrix of independent variables with coefficients are allowed to change across
regimes}

\item{x}{matrix of independent variables with coefficients constant across regimes}

\item{m}{maximum number of breaks}

\item{eps}{convergence criterion for iterative recursive computation}

\item{eps1}{trimming level}

\item{maxi}{maximum number of iterations}

\item{fixb}{option to use fixed initial input \eqn{\beta}. If \code{1},
the model will use values given in \code{betaini}. If \code{0}, betaini is skipped}

\item{betaini}{Initial \eqn{beta_0} to use in estimation}

\item{printd}{option to print results of iterations for partial change model}

\item{prewhit}{option to use AR(1) for prewhitening process}

\item{robust, hetdat, hetvar}{options on error terms assumptions}
}
\value{
A list that contains following:
\itemize{
\item{nbreak}{Number of breaks}
\item{dateseq}{Sequence of break dates}}
}
\description{
function to apply sequential procedure to obtain number of breaks and break
dates. Current version only allows pure structural changes. This will be
generalized
}
