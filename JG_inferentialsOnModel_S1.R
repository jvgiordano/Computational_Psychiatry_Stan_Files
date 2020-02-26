library(rstan)
library(parallel)
library(matlab)

## Load in Stan Fitted Model

setwd('C:/Users/jgior/Desktop/Internship/Modeling-eLife/')
load('stan_fits/stanfits_jonny_output_s1_Feb2_2020.RData')
m = extract(fit, permuted=TRUE)

## Derive subject means for Betas, Alpha
bySubj = data.frame(subj=unique(data$subj), betac=rep(0,(length(unique(data$subj)))), alpha1=rep(0,(length(unique(data$subj)))), beta1m=rep(0,(length(unique(data$subj)))), beta1t=rep(0,(length(unique(data$subj)))),beta2=rep(0,(length(unique(data$subj)))))
for( i in 1:length(unique(data$subj))){
    bySubj[i,2:6] = c(mean(m$betac[,i]),mean(m$alpha1[,i]), mean(m$beta1m[,i]),mean(m$beta1t[,i]), mean(m$beta2[,i]))
}

## Check R-Hat Values

fit_summary = summary(fit)
print(fit_summary$summary)

## Load in Psychiatric Scores

scores = read.csv('data/self_report_study1.csv', header=TRUE)
sreps = scores[c("subj", "age", "iq", "gender", "sds_total", "stai_total", "oci_total")]
#sreps$subj = sreps$subj.x


## Merge Psychiatric scores with Subject fittings
comb = merge(sreps, bySubj, by="subj")

## Analysis

summary(lm(beta1m ~ scale(iq) + scale(age) + gender + scale(sds_total), data=comb))
summary(lm(beta1m ~ scale(iq) + scale(age) + gender + scale(oci_total), data=comb))
summary(lm(beta1m ~ scale(iq) + scale(age) + gender + scale(stai_total), data=comb))