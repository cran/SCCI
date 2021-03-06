# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

conditionalShannonEntropy <- function(x,y) {
    if(dim(data.frame(y))[2] == 0){
        y = data.frame(rep(0,length(x)))
    }
    ret = .Call("conditionalShannonEntropy", x, data.matrix(y), PACKAGE="SCCI")
    return(ret)
}

shannonEntropy <- function(x) {
    ret = .Call("shannonEntropy", x, PACKAGE="SCCI")
    return(ret)
}

stochasticComplexity <- function(x){
    #score in {fNML, qNML}
    y = rep(1,length(x))
    return(conditionalStochasticComplexity(x,y,"fNML"))
}

conditionalStochasticComplexity <- function(x,y,score="fNML"){
    #score in {fNML, qNML}
    fCall = "conditionalFNML"
    if(score == "qNML"){
        fCall = "conditionalQNML"
    }
    ret = .Call(fCall, data.matrix(x), data.matrix(y), PACKAGE="SCCI")
    return(ret)
}

SCCI <- function(x,y,Z,score="fNML",sym=FALSE){
    #score in {fNML, qNML}
    #sym in {F: use asymmetric version and maximize (default), T: use symmetric version (only used for testing)}
    ret = 0
    if(sym){
        fcall = "indepfNML"
        if(score == "qNML"){
            fcall = "indepqNML"
        }
        ret = .Call(fcall, data.matrix(x), data.matrix(y), data.matrix(data.frame(x,y)), data.matrix(Z), PACKAGE="SCCI")
    }else{
        fcall = "indepAsymfNML"
        if(score == "qNML"){
            fcall = "indepAsymqNML"
        }
        cxgy = .Call(fcall, data.matrix(x), data.matrix(y), data.matrix(Z), PACKAGE="SCCI")
        cygx = .Call(fcall, data.matrix(y), data.matrix(x), data.matrix(Z), PACKAGE="SCCI")
        ret = max(cxgy,cygx)
    }
    ret = max(0, ret)
    return(ret)
}

pSCCI <- function(x,y,S,suffStat){
    xx = suffStat$dm[,x]
    yy = suffStat$dm[,y]
    n = length(xx)
    ss = data.frame(suffStat$dm[,S])
    val = SCCI(xx, yy, ss, score="fNML") / n
    pv = 2^(-6.643855 - val)
    pv = min(pv, 1)
    pv = max(pv, 0)
    return(pv)
}

regret <- function(n,k){
    ret = .Call("regret", n, k, PACKAGE="SCCI")
    return(ret)
}
