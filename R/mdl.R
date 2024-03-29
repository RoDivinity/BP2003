#Main program to handle users' input

#' Robust structural change estimation
#' 
#' @description 
#' Function executes all the main procedures to estimate either i) pure structural
#' breaks model or ii) partial structural breaks model 
#'
#' @param y_name name of dependent variable in the data set
#' @param z_name name of independent variables in the data set which coefficients are allowed to change
#' across regimes. \code{default} is vector of 1 (Mean-shift model)
#' @param x_name name of independent variables in the data set which coefficients are constant across
#' regimes. \code{default} is NULL
#' @param data the data set for estimation
#' @param eps1 value of trimming (in percentage) for the construction
#' and critical values. Minimal segment length will be set
#' at \code{default} = int(\code{eps1}*T) (T is total sample size).
#  There are five options: 
#' \itemize{
#' \item{\code{eps1}=.05: Maximal value of \code{m} = 10}
#' \item{\code{eps1}=.10: Maximal value of \code{m} = 8}
#' \item{\code{eps1}=.15: Maximal value of \code{m} = 5}
#' \item{\code{eps1}=.20: Maximal value of \code{m} = 3}
#' \item{\code{eps1}=.25: Maximal value of \code{m} = 2}
#' } The \code{default} value is set at 0.15
#' @param m Maximum number of structural changes allowed. If not specify,
#' m will be set to \code{default} value from \code{eps1}
#' @param prewhit set to \code{1} if want to apply AR(1) prewhitening prior to estimating
#' the long run covariance matrix.
#' @param robust set to \code{1} if want to allow for heterogeneity
#' and autocorrelation in the residuals, \code{0} otherwise.
#' The method used is \emph{Andrews(1991)} automatic bandwidth with AR(1) approximation and the quadratic
#' kernel. Note: Do not set to \code{1} if lagged dependent variables are
#' included as regressors.
#' @param hetdat option for the construction of the F tests. Set to 1 if want to
#' allow different moment matrices of the regressors across segments.
#' If \code{hetdat} = \code{0}, the same moment matrices are assumed for each segment
#' and estimated from the ful sample. It is recommended to set
#' \code{hetdat}=\code{1} if number of regressors \code{x} > \code{0}.
#' @param hetvar option for the construction of the F tests.Set to \code{1}
#' if users want to allow for the variance of the residuals to be different across segments.
#' If \code{hetvar}=\code{0}, the variance of the residuals is assumed constant
#' across segments and constructed from the full sample. \code{hetvar}=\code{1} when \code{robust} =\code{1})
#' @param hetomega used in the construction of the confidence intervals for the break
#' dates. If \code{hetomega}=\code{0}, the long run covariance matrix of zu is
#' assumed identical across segments
#' (the variance of the errors u if \code{robust}={0})
#' @param hetq used in the construction of the confidence intervals for the break
#' dates. If \code{hetq}=\code{0}, the moment matrix of the data is assumed identical
#' across segments
#' @param maxi number of maximum iterations for recursive calculations of finding
#' global minimizers.\code{default} = 10
#' @param eps convergence criterion for recursive calculations
#' @param fixn number of pre-specified breaks. \code{default} = -1. It will be replaced
#' automatically to 2 if no specification is given
#' @param printd Print option for model estimation. \code{default} = 0, to 
#' suppress intermediate outputs printing to console
#' @return  A list that contains the following:
#'\itemize{
#'\item{Wtest: Sup F tests of 0 versus m breaks and Double Max tests}
#'\item{spflp1: Sequential Sup F test of l versus l+1 breaks }
#'\item{BIC: Estimated number of breaks by BIC and the corresponding model}
#'\item{LWZ: Estimated number of breaks by LWZ and the corresponding model}
#'\item{sequa: Estimated number of breaks by sequential procedure the corresponding model}
#'\item{repart: Estimated number of breaks by repartition procedure the corresponding model}
#'\item{fix: Estimated model with pre-specified number of breaks}
#'}
#' 
#' @details 
#' The 7 main procedures include:
#' \itemize{
#' \item{\code{\link{dotest}}: Procedure to conduct SupF test of 0 versus m breaks and
#'  Double Max test.}
#' \item{\code{\link{dospflp1}}: Procedure to conduct sequential SupF(l+1|l) (l versus l+1 breaks)}
#' \item{\code{\link{doorder}}: Procedure to find number of break by criteria selection 
#' (including BIC and LWZ criterion)}
#' \item{\code{\link{dosequa}}: Procedure to find number of break and break dates via sequential method}
#' \item{\code{\link{dorepart}}: Procedure to find number of break and break dates via repartition method}
#' \item{\code{fix}: Procedure to find number of break by pre-specified number of breaks, which are set at \code{default} 
#' to be 2 }}
#' 
#' 
#' All \code{default} values of error assumptions (\code{robust},
#' \code{hetdat}, \code{hetvar}, \code{hetq}) will be set to 1. The implications on 
#' the structure of model's errors related to individual settings are explained within 
#' the arguments section for each option. Users can separately invoke only one at a
#' time one of the main7 procedures mentioned above
#' 
#' @export

mdl <- function(y_name,z_name = NULL,x_name = NULL,data,eps1 = 0.15,m = -1,prewhit = 1,
                           robust = 1,hetdat = 1,hetvar = 1,hetomega = 1,hetq = 1,
    maxi = 10,eps = 0.00001,fixn=-1,printd = 0){
  #handle data
  y_ind = match(y_name,colnames(data))
  x_ind = match(x_name,colnames(data))
  z_ind = match(z_name,colnames(data))
  
  if(printd==1){
  cat('The options chosen are:\n')
  cat(paste(' i) hetdat = ',hetdat),'\n',paste('ii) hetvar = ',hetvar),'\n',
      paste('iii) hetomega = ',hetomega),'\n',paste('iv) hetq = ',hetq),'\n',
      paste('v) robust = ',robust),'\n',paste('vi) prewhite = ',prewhit),'\n')
  }
  
  mdl = list()

  if(is.na(y_ind)){
    print('No dependent variable found. Please try again')
    return(NULL)}

  y = data[,y_ind]
  y = data.matrix(y)
  T = dim(y)[1]

  if (is.null(x_name)) {x = c()}
  else{
    if(anyNA(x_ind)){print('No x regressors found. Please try again')}
    else{x = data.matrix(data[,x_ind,drop=FALSE])}}
  if (is.null(z_name)) {z = matrix(1L,T,1)}
  else{
    if(anyNA(z_ind)){print('No z regressors found. Please try again')}
    else{z = data.matrix(data[,z_ind,drop=FALSE])}}

  #set maximum breaks
  v_eps1 = c(0.05,0.10,0.15,0.20,0.25)
  v_m = c(10,8,5,3,2)
  index = match(eps1,v_eps1)

  #set significant level
  siglev=matrix(c(10,5,2.5,1),4,1)

  if(is.na(index)) {
    print('Invalid trimming level, please choose 1 of the following values')
    print(v_eps1)
    return(NULL)
  }
  if (m == -1) {
    m = v_m[index]
  }
  if (fixn == -1){
    fixn = 2
  }

  if(length(dim(x))==0){p = 0}
  else{p = dim(x)[2]}
  q = dim(z)[2]
  #currently not allowing for user-input coefficients estimates
  fixb = 0;
  betaini = 0;
  #Sup F test
  mdl$Wtest = dotest(y_name=y_name,z_name=z_name,x_name=x_name,data=data,m=m,
                     eps=eps,eps1=eps1,maxi=maxi,fixb=fixb,
                     betaini=betaini,printd=0,prewhit=prewhit,robust=robust,
                     hetdat=hetdat,hetvar=hetvar)
  #Sequential test
  mdl$spflp1 = dospflp1(y_name=y_name,z_name=z_name,x_name=x_name,data=data,m=m,
                        eps=eps,eps1=eps1,maxi=maxi,fixb=fixb,
                        betaini=betaini,printd=0,prewhit=prewhit,robust=robust,
                        hetdat=hetdat,hetvar=hetvar)
  #Information criteria to select num of breaks and estimate break dates
  mdl$BIC = doorder(y_name=y_name,z_name=z_name,x_name = x_name,data=data,
                    m=m,eps=eps,eps1=eps1,maxi=maxi,fixb=fixb,
                    betaini=betaini,printd=printd,bic_opt = 1)
  mdl$LWZ = doorder(y_name=y_name,z_name=z_name,x_name = x_name,data=data,
                    m=m,eps=eps,eps1=eps1,maxi=maxi,fixb=fixb,
                    betaini=betaini,printd=printd,bic_opt = 0)
  #Sequential procedure to select num of breaks and estimate break dates
  mdl$sequa = dosequa(y_name=y_name,z_name=z_name,x_name=x_name,data=data,
                      m=m,eps=eps,eps1=eps1,maxi=maxi,fixb=fixb,betaini=betaini,
                      printd=printd,prewhit=prewhit,robust=robust,hetdat=hetdat,hetvar=hetvar)
  #Repartition procedure to select num of breaks and estimate break dates
  mdl$repart = dorepart(y_name=y_name,z_name=z_name,x_name=x_name,data=data,
                        m=m,eps=eps,eps1=eps1,maxi=maxi,fixb=fixb,betaini=betaini,
                        printd=printd,prewhit=prewhit,robust=robust,hetdat=hetdat,hetvar=hetvar)
  #Estimate a model with pre-specified number of breaks 
    t_out = doglob(y,z,x,fixn,eps,eps1,maxi,fixb,betaini,printd)
    datevec = t_out$datevec
    if(length(datevec) == 0){
      print('No break is found')
      return(NULL)
    }else{
    date = datevec[,fixn,drop=FALSE]
    fix_mdl = estim(fixn,q,z,y,date,robust,prewhit,hetomega,hetq,x,p,hetdat,hetvar)}
    mdl$fix = fix_mdl
    mdl$fix$p_name = 'fix'
    mdl$fix$nbreak = fixn
    class(mdl$fix) = 'model'
    mdl$fix$numz = q
    mdl$fix$numx = p
    mdl$fix$y_name =y_name
    mdl$fix$x_name =x_name
    mdl$fix$z_name =z_name
    mdl$fix$y = y
    mdl$fix$z = z
    mdl$fix$x = x
    mdl$fix = compile.model(mdl$fix)
  



  #reorganize the results into the list
  class(mdl) <- 'mdl'
  mdl$maxb = m

  
  return(mdl)
  }



print.mdl <- function(x,digits = -1,...)
{
  
  cat(paste('Number of max breaks specified: ',x$maxb),'\n')
  cat('-----------------------------------------------------')
  if (is.null(x$BIC)) {cat('\nNo breaks were founded\n')}
  else{
  print(x$BIC)}
  cat('-----------------------------------------------------')
  print(x$Wtest)
  cat('-----------------------------------------------------')
  print(x$spflp1)
  
  cat(paste('\nTo access additional information about specific procedures 
  (not included above), type stored variable name + \'$\' + procedure name'))
  cat('\nList of procedure\'s names stored in the results:\n')
  cat(paste('1) Sup F tests: ','\t\tWtest'),'\n')
  cat(paste('2) Sequential tests: ','\t\tspflp1'),'\n')
  cat(paste('3) BIC model selection: ','\tBIC'),'\n')
  cat(paste('4) LWZ model selection: ','\tLWZ'),'\n')
  cat(paste('5) Sequential procedure: ','\tsequa'),'\n')
  cat(paste('6) Repartition procedure: ','\trepart'),'\n')
  cat(paste('7) Pre-specified #s of breaks: ','fix'),'\n')
  
  
  invisible(x)
}






