library(mongolite)
library(stringr)
library(dplyr)
library(ggplot2)
library(GGally)
library(corrplot)

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
source("../data_read_in.R")

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
# TODO: Look at response time as % of first image time... learning/remember/tired effects?

# Correlation
ggpairs(responses_an %>% 
          select(-c(uuid, maptype, rangeMin, rangeMax, submitVal, correctVal))
        )
corrplot(cor(responses_an %>% 
               select(-c(uuid, maptype, rangeMin, rangeMax, submitVal, correctVal, colour, legend))), 
         method = "circle")



########################################
# Visual inspection and outliers by variables
# 1-way ANOVA + plots (NOT SUITABLE)
# The repeated-measures ANOVA is used for analyzing data where same subjects are measured more than once. This test is also referred to as a within-subjects ANOVA or ANOVA with repeated measures. The “within-subjects” term means that the same individuals are measured on the same outcome variable under different time points or conditions.
# TODO: Check statistical assumptions BEFORE running models
# TODO: statistical assumptions section (export as functions...)
# TODO: Model only the most interesting ones (2-3)
# https://statistics.laerd.com/statistical-guides/repeated-measures-anova-statistical-guide.php
# https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/#:~:text=The%20repeated-measures%20ANOVA%20is%20used%20for%20analyzing%20data,outcome%20variable%20under%20different%20time%20points%20or%20conditions.
########################################

#### Against vis/legend type; X = VisualizationType

# PerceptionValueError
p <- ggplot(responses_an, aes(legend, percept_error))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(percept_error ~ legend, data=responses_an)
# summary(m)


# ABS PerceptionValueError
p <- ggplot(responses_an, aes(legend, percept_error_abs))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(percept_error_abs ~ legend, data=responses_an)
# summary(m)


# TimeToSubmit
p <- ggplot(responses_an, aes(legend, submitTime))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(submitTime ~ legend, data=responses_an)
# summary(m)



# DecisionChanges
p <- ggplot(responses_an, aes(legend, inputChanges))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(inputChanges ~ legend, data=responses_an)
# summary(m)


# Acceptance
# How are alternative legend design choices received by the subjects 
# (subjective user acceptance testing)?
p <- ggplot(responses_an, aes(legend, acceptance))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(acceptance ~ legend, data=responses_an)
# summary(m)



#### Against color; X = colour

# PerceptionValueError
p <- ggplot(responses_an, aes(colour, percept_error))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(percept_error ~ colour, data=responses_an)
# summary(m)


# ABS PerceptionValueError
p <- ggplot(responses_an, aes(colour, percept_error_abs))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(percept_error_abs ~ colour, data=responses_an)
# summary(m)


# TimeToSubmit
p <- ggplot(responses_an, aes(colour, submitTime))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(submitTime ~ colour, data=responses_an)
# summary(m)



# DecisionChanges
p <- ggplot(responses_an, aes(colour, inputChanges))
p + geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5)
# p + geom_boxplot() + geom_jitter(height = 0, width = 0.1, alpha=0.5)

# m <-aov(inputChanges ~ colour, data=responses_an)
# summary(m)



########################################
# Fixed individual effects models
# https://www.econometrics-with-r.org/10-3-fixed-effects-regression.html
# https://cran.r-project.org/web/packages/fixest/vignettes/fixest_walkthrough.html
# TODO: assumptions on distributions
# TODO: Increase models (all FE-models)
# TODO: learning effects as progression or getting tired of task... (INDIVIDUAL+PROGNUM)
# TODO: Progression fixed effects or as linear effect?
# TODO: Visualize coeffiecients
########################################
library(plm)
library(zoo)

responses_an$legend = relevel(responses_an$legend, ref = "headline")

# Baseline
lm_mod_percept <- lm(percept_error ~ legend, 
              data = responses_an)
summary(lm_mod_percept)


# estimate the fixed effects regression with plm()
fe_mod_percept <- plm(percept_error ~ legend, 
                    data = responses_an,
                    index = c("uuid"), 
                    model = "within")

# print summary using robust standard errors
coeftest(fe_mod_percept, vcov. = vcovHC, type = "HC1")

# Baseline
lm_mod_percept_abs <- lm(percept_error ~ legend, 
              data = responses_an)
summary(lm_mod_percept_abs)


# estimate the fixed effects regression with plm()
fe_mod_percept_abs <- plm(percept_error_abs ~ legend, 
              data = responses_an,
              index = c("uuid"), 
              model = "within")

# print summary using robust standard errors
coeftest(fe_mod_percept_abs, vcov. = vcovHC, type = "HC1")


# fe_mod_color <- plm(percept_error_abs ~ colour, 
#               data = responses_an,
#               index = c("uuid"), 
#               model = "within")

# # print summary using robust standard errors
# coeftest(fe_mod, vcov. = vcovHC, type = "HC1")



library(stargazer)
stargazer(lm_mod_percept, fe_mod_percept, lm_mod_percept_abs, fe_mod_percept_abs, title="Regression Results", align=TRUE)


# TODO: Subset = first 4-5 images? if signs of learning/remember/tired effects
# TODO-OPTIONAL: SelectionRagneDistFromCorrectAnswer
# TODO-OPTIONAL: Colour map of interactions + interaction map of users (changed inputs, etc..)
