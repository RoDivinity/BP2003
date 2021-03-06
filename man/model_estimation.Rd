% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Main.R
\name{model_estimation}
\alias{model_estimation}
\title{Robust structural change estimation}
\usage{
model_estimation(
  y_name,
  z_name = NULL,
  x_name = NULL,
  data,
  eps1 = 0.15,
  m = -1,
  prewhit = 1,
  robust = 1,
  hetdat = 1,
  hetvar = 1,
  hetomega = 1,
  hetq = 1,
  procedure = c("doglob", "dotest", "dospflp1", "doorder", "dosequa", "dorepart"),
  CI = 1,
  method = c("BIC", "LWZ", "seq", "rep", "fix"),
  maxi = 10,
  fixb = 0,
  eps = 1e-05,
  betaini = 0,
  fixn = -1,
  printd = 0
)
}
\arguments{
\item{data}{the data set for estimation}

\item{m}{Maximum number of structural changes allowed. If not specify,
m will be set to \code{default} value from \code{eps1}}

\item{prewhit}{set to \code{1} if want to apply AR(1) prewhitening prior to estimating
the long run covariance matrix.}

\item{robust}{set to \code{1} if want to allow for heterogeneity
and autocorrelation in the residuals, \code{0} otherwise.
The method used is \emph{Andrews(1991)} automatic bandwidth with AR(1) approximation and the quadratic
kernel. Note: Do not set to \code{1} if lagged dependent variables are
included as regressors.}

\item{hetdat}{option for the construction of the F tests. Set to 1 if want to
allow different moment matrices of the regressors across segments.
If \code{hetdat} = \code{0}, the same moment matrices are assumed for each segment
and estimated from the ful sample. It is recommended to set
\code{hetdat}=\code{1} if number of regressors \code{x} > \code{0}.}

\item{hetvar}{option for the construction of the F tests.Set to \code{1}
if want to allow
for the variance of the residuals to be different across segments.
If \code{hetvar}=\code{0}, the variance of the residuals is assumed constant
across segments and constructed from the full sample. This option
is not available when \code{robust}=\code{1}}

\item{hetomega}{used in the construction of the confidence intervals for the break
dates. If \code{hetomega}=\code{0}, the long run covariance matrix of zu is
assumed identical across segments
(the variance of the errors u if \code{robust}={0})}

\item{hetq}{used in the construction of the confidence intervals for the break
dates. If \code{hetq}=\code{0}, the moment matrix of the data is assumed identical
across segments}

\item{procedure}{Selectable procedures to execute:
\itemize{
\item{\code{\link{doglob}}}{ A recursive procedure to obtain global minimizers of SSR,
corresponding to the break date.}
\item{\code{\link{dotest}}} {Procedure to conduct SupF test of 0 versus m breaks and
 Double Max test.}
\item{\code{\link{dospflp1}}} {Procedure to conduct SupF(l+1|l).}
\item{\code{\link{doorder}}} {Procedure to find number of break by criteria selection}
\item{\code{\link{dosequa}}} {Procedure to obtain break dates via sequential method}
\item{\code{\link{dorepart}}} {Procedure to obtain break dates via repartition method}
}}

\item{CI}{Option to estimate dates, model parameters and their confidence intervals.
If \code{1}, specify method to estimate in \code{method} below.}

\item{method}{\itemize{
\item{\code{"BIC"}} {Estimate and compute confidence intervals following
order selection method to pick number of breaks by BIC. For more details, see
\code{\link{doorder}},\code{\link{estim}}}
\item{\code{"LWZ"}} {Estimate and compute confidence intervals following
order selection method to pick number of breaks by LWZ. For more details, see
\code{\link{doorder}},\code{\link{estim}}}
\item{\code{"seq"}} {Estimate and compute confidence intervals following
sequential method estimation of the break date. For more details, see
\code{\link{dosequa}},\code{\link{estim}}}
\item{\code{"rep"}} {Estimate and compute confidence intervals following
repartition method estimation of the break date. For more details, see
\code{\link{dorepart}},\code{\link{estim}}}
\item{\code{"fix"}} {Estimate and compute confidence intervals following
pre-specified number of breaks, \code{i}. For more details, see
\code{\link{estim}}}}}

\item{maxi}{number of maximum iterations for recursive calculations of finding
global minimizers.\code{default} = 10}

\item{fixb}{Option to use initial values of beta. Set to 1 if initial values
are entered by users.}

\item{eps}{convergence criterion for recursive calculations}

\item{betaini}{values of initial betas. Only used when \code{fixb} = 1.}

\item{fixn}{number of pre-specified breaks. \code{default} = -1. It will be replaced
automatically to 2 if no specification is given}

\item{printd}{Print option for model estimation. \code{default} = 0, to suppress outputs}

\item{y}{name of dependent variable}

\item{z}{name of independent variables which coefficients are allowed to change
across regimes. \code{default} is vector of 1 (Mean-shift model)}

\item{x}{name of independent variables which coefficients are constant across
regimes. \code{default} is NULL}
}
\description{
Function executes main procedures described in Bai and Perron
}
\details{
Function executes the main procedures selected by users. There are 7 main
procedures including:\itemize{
\item{\code{\link{doglob}}}{ A recursive procedure to obtain global minimizers of SSR,
corresponding to the break date.}
\item{\code{\link{dotest}}} {Procedure to conduct SupF test of 0 versus m breaks and
 Double Max test.}
\item{\code{\link{dosupflp1}}} {Procedure to conduct SupF(l+1|l).}
\item{\code{\link{doorder}}} {Procedure to find number of break by criteria selection}
\item{\code{\link{dosequa}}} {Procedure to obtain break dates via sequential method}
\item{\code{\link{dorepart}}} {Procedure to obtain break dates via repartition method}
}
To obtain the confidence intervals for the break dates and corrected errors for
estimates of the model, set \code{est} = \code{1}. If \code{est} = \code{1}, specify
one of the following methods for estimation procedure:
\itemize{
\item{\code{"BIC"}} {Estimate and compute confidence intervals following
order selection method to pick number of breaks by BIC. For more details, see
\code{\link{doorder}},\code{\link{estim}}}
\item{\code{"LWZ"}} {Estimate and compute confidence intervals following
order selection method to pick number of breaks by LWZ. For more details, see
\code{\link{doorder}},\code{\link{estim}}}
\item{\code{"seq"}} {Estimate and compute confidence intervals following
sequential method estimation of the break date. For more details, see
\code{\link{dosequa}},\code{\link{estim}}}
\item{\code{"rep"}} {Estimate and compute confidence intervals following
repartition method estimation of the break date. For more details, see
\code{\link{dorepart}},\code{\link{estim}}}
\item{\code{"fix"}} {Estimate and compute confidence intervals following
pre-specified number of breaks, \code{i}. For more details, see
\code{\link{estim}}}}
\emph{All \code{default} values} of error assumptions (\code{robust},
\code{hetdat}, \code{hetvar}, \code{hetq}) will be set to 1
}
