library(mongolite)
library(stringr)
library(dplyr)
library(ggplot2)

# RES QUESTIONS
# DONE: - How is data opacity mapping perception influenced by legend display choices?
# DONE: (maybe have checkered as baseline) - Does alternative legend methods compared to GIS industry standard’s choice influence errors in perceived data mapping and colour choices?
# DONE: - Does legend to data proximity-reduction or contextualised legend design influence perception errors for opacity data mapping?
# DONE: - Can decision times and user selection behaviour be affected by legend choices?
# DONE: - How are alternative legend design choices received by the subjects (subjective user acceptance testing)?
# ADD: colour differences?

# R studio wd same as source file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


########################################
# Data READ IN
########################################
source("data_read_in.R")

responses_an = df_from_db()
# Read from CSV as alternative
# readr::write_csv(responses_an, "./data/responses.csv")

########################################
# Data Cleaning
########################################
responses_an$uuid = as.factor(responses_an$uuid)
responses_an$maptype = as.factor(responses_an$maptype)
responses_an$colour = as.factor(responses_an$colour)
responses_an$legend = as.factor(responses_an$legend)
# TODO: if needed remove outliers

########################################
# Summary statistics/Exploratory analysis
########################################
summary(responses_an)
# TODO: When color perception -> plot against error - should be correlated if not random...

# TODO: Increase models (all FE-models)
# TODO: statistical assumptions section (export as functions...)
# TODO: colourvalueerror - once there is alpha-picker data
# TODO: Look at response time as % of first image time... learning/remember/tired effects?
# TODO: learning effects as progression or getting tired of task... (INDIVIDUAL+PROGNUM)
# TODO: Progression fixed effects or as linear effect?
# TODO: Coefficient plots
# TODO: More plots


########################################
# Visual inspection and outliers by variables
# 1-way ANOVA + plots
# TODO: Check statistical assumptions BEFORE running models
# https://stat-methods.com/home/one-way-anova-r/#:~:text=%20One-way%20ANOVA%20Annotated%20R%20Output%20%201,the%20theoretical%20normal%20reference%20line%20and...%20More%20
# http://www.sthda.com/english/wiki/one-way-anova-test-in-r
########################################

#### Against vis/legend type; X = VisualizationType

# PerceptionValueError
p <- ggplot(responses_an, aes(factor(legend), percept_error))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(percept_error ~ factor(legend), data=responses_an)
summary(m)


# ABS PerceptionValueError
p <- ggplot(responses_an, aes(factor(legend), percept_error_abs))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(percept_error_abs ~ factor(legend), data=responses_an)
summary(m)


# TimeToSubmit
p <- ggplot(responses_an, aes(factor(legend), submitTime))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(submitTime ~ factor(legend), data=responses_an)
summary(m)



# DecisionChanges
p <- ggplot(responses_an, aes(factor(legend), inputChanges))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(inputChanges ~ factor(legend), data=responses_an)
summary(m)


# Acceptance
# How are alternative legend design choices received by the subjects 
# (subjective user acceptance testing)?
p <- ggplot(responses_an, aes(factor(legend), acceptance))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(acceptance ~ factor(legend), data=responses_an)
summary(m)



#### Against color; X = colour

# PerceptionValueError
p <- ggplot(responses_an, aes(factor(colour), percept_error))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(percept_error ~ factor(colour), data=responses_an)
summary(m)


# ABS PerceptionValueError
p <- ggplot(responses_an, aes(factor(colour), percept_error_abs))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(percept_error_abs ~ factor(colour), data=responses_an)
summary(m)


# TimeToSubmit
p <- ggplot(responses_an, aes(factor(colour), submitTime))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(submitTime ~ factor(colour), data=responses_an)
summary(m)



# DecisionChanges
p <- ggplot(responses_an, aes(factor(colour), inputChanges))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

m <-aov(inputChanges ~ factor(colour), data=responses_an)
summary(m)



########################################
# Fixed individual effects models
# https://www.econometrics-with-r.org/10-3-fixed-effects-regression.html
# https://cran.r-project.org/web/packages/fixest/vignettes/fixest_walkthrough.html
# TODO: assumptions on distributions
########################################
library(plm)
library(zoo)

# Baseline
# estimate the fixed effects regression with plm()
lm_mod <- lm(percept_error ~ relevel(factor(legend), ref = "headline"), 
              data = responses_an)
summary(lm_mod)


# estimate the fixed effects regression with plm()
fe_mod <- plm(percept_error ~ relevel(factor(legend), ref = "headline"), 
                    data = responses_an,
                    index = c("uuid"), 
                    model = "within")

# print summary using robust standard errors
coeftest(fe_mod, vcov. = vcovHC, type = "HC1")


# estimate the fixed effects regression with plm()
fe_mod <- plm(percept_error_abs ~ relevel(factor(legend), ref = "headline"), 
              data = responses_an,
              index = c("uuid"), 
              model = "within")

# print summary using robust standard errors
coeftest(fe_mod, vcov. = vcovHC, type = "HC1")


fe_mod <- plm(percept_error_abs ~ factor(colour), 
              data = responses_an,
              index = c("uuid"), 
              model = "within")

# print summary using robust standard errors
coeftest(fe_mod, vcov. = vcovHC, type = "HC1")



library(stargazer)
stargazer(lm_mod, fe_mod, title="Regression Results", align=TRUE)


# TODO: Subset = first 4-5 images? if signs of learning/remember/tired effects
# TODO-OPTIONAL: SelectionRagneDistFromCorrectAnswer
# TODO-OPTIONAL: Colour map of interactions + interaction map of users (changed inputs, etc..)
