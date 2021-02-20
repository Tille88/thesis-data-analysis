library(mongolite)
library(stringr)
library(dplyr)
library(ggplot2)
library(GGally)
library(corrplot)
library(gtsummary)

# RES QUESTIONS
# ERROR AND DISPLAY TYPES: 
# 1. legends -> opacity mapping perception? baseline = no legend
# 2. alternative legend choices vs. standard? baseline = checkered
# 3. legend to data proximity-reduction|contextualised -> error? baseline = checkered

# DONE: 
# - Can decision times and user selection behaviour be affected 
# by legend choices?
# DONE: 
# - How are alternative legend design choices received 
# by the subjects (subjective user acceptance testing)?

# R studio wd same as source file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

########################################
# Data READ IN
########################################
source("../data_read_in.R")

responses_an = df_from_db()


########################################
# Data Cleaning
########################################
error_uuids = c(
  "db5cf00b-448f-47cf-842c-8d237f6cf45b",
  "f0e25470-5bf5-4363-b75f-bc9f704dc9b1"
)


responses_an = responses_an %>% filter(!(uuid %in% error_uuids))



responses_an$uuid = as.factor(responses_an$uuid)
responses_an$maptype = as.factor(responses_an$maptype)
responses_an$colour = as.factor(responses_an$colour)
responses_an$legend = as.factor(responses_an$legend)



########################################
# Data and variable descriptions + exploratory analysis
########################################



#######################
# TREATMENT
# Legend types -> WRITE DESCRIPTION WITH PICTURES

#######################
# DEPENDENT VARIABLES
# Error distribution
#   Relative -> all centered around 0
# LARGE VARIANCE
ggplot(responses_an, aes(legend, percept_error, color=legend)) + 
  geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.3) +
  stat_summary(fun.data="mean_sdl", mult=1, 
               geom="pointrange", width=0.2, color="black") + 
  theme(legend.position="none")


tbl_summary(
  responses_an %>%
    select(legend, percept_error),
  by = legend, # split table by group
  # missing = "no" # don't list missing data separately
) %>%
  add_n() %>% # add column with total number of non-missing observations
  add_p() %>% # test for a difference between groups
  modify_header(label = "**Variable**") %>% # update the column header
  bold_labels() 


#   Absolute
# OUTLIERS IN ALL CATEGORIES
ggplot(responses_an, aes(legend, percept_error_abs, color=legend)) + 
  geom_boxplot()  +
  stat_summary(fun="mean", geom="point", color="black")

tbl_summary(
  responses_an %>%
    select(legend, percept_error_abs),
  by = legend
) %>%
  add_n() %>% # add column with total number of non-missing observations
  add_p() %>% # test for a difference between groups
  modify_header(label = "**Variable**") %>% # update the column header
  bold_labels() 

# Acceptance - table
tbl_summary(
  # Need to keep only 1 observation per uuid
  responses_an %>% 
    select(uuid, acceptance, legend) %>% 
    distinct() %>% select(-c(uuid)),
  by = legend
) %>%
  add_n() %>% # add column with total number of non-missing observations
  modify_header(label = "**Legend**") %>% # update the column header
  bold_labels() 

#######################
# Respondents
length(unique(responses_an$uuid))
length(responses_an$uuid) / length(unique(responses_an$uuid))

#######################
# Controls and events

# Submit time
ggplot(responses_an, aes(legend, submitTime, color=legend)) + 
  geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.3) +
  theme(legend.position="none")


# Events - inputChanges and hover events, sbumit time
# Not useful -> not indication of uncertainty
#   1. Not all same usage (discuss around example) hovering, taking time
ggplot(responses_an, aes(legend, inputChanges, color=legend)) + 
  geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.3) +
  theme(legend.position="none")

ggplot(responses_an, aes(legend, hoverEvents, color=legend)) + 
  geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.3) +
  theme(legend.position="none")


# Control variables
# progresssion, colour
# Are they likely to provide anything?
# More feeling of randomness
ggplot(responses_an, aes(colour, percept_error_abs, color=colour)) + 
  geom_violin() + geom_jitter(height = 0, width = 0.1, alpha=0.5) +
  stat_summary(fun="mean", geom="point", color="black")

 
########################################
########################################
# ANALYSIS
########################################
########################################


########################################
# ERROR AND DISPLAY TYPES
# 1. legends -> opacity mapping perception? baseline = no legend
# 2. alternative legend choices vs. standard? baseline = checkered
# 3. legend to data proximity-reduction|contextualised -> error? baseline = checkered
########################################

# Data sets
no_legend_baseline = responses_an
no_legend_baseline$legend = relevel(responses_an$legend, ref = "headline")
checkered_baseline = responses_an
checkered_baseline = checkered_baseline %>% filter(legend != "headline")
checkered_baseline$legend = relevel(checkered_baseline$legend, ref = "checkered")

########################################
# Absolute error: Baselines -> FE
########################################
library(plm)
library(lmtest)
library(zoo)

library(gplots)
plotmeans(percept_error_abs ~ legend, main="Heterogeineity across legend types", data=no_legend_baseline)
plotmeans(percept_error_abs ~ uuid, main="Heterogeineity across respondents", data=no_legend_baseline)

# Absolute error - simple OLS
## 1. legend useful at all
### Baseline
baseline_legend_of_use <- lm(percept_error_abs ~ legend, 
                     data = no_legend_baseline)
summary(baseline_legend_of_use)
### FE = robustness
fe_legend_of_use <- plm(percept_error_abs ~ legend,
                          data = no_legend_baseline,
                          index = c("uuid"),
                          model = "within")
# print summary using robust standard errors
coeftest(fe_legend_of_use, vcov. = vcovHC, type = "HC1")
# Nonrobust -> summary(fe_legend_of_use)


## 2. Legend vs standard = checkered
## 3. annotated or contextualized also answered
### Baseline
standard_baseline_difference <- lm(percept_error_abs ~ legend, 
                             data = checkered_baseline)
summary(standard_baseline_difference)
### FE = robustness
fe_standard_difference <- plm(percept_error_abs ~ legend,
                            data = checkered_baseline,
                            index = c("uuid"),
                            model = "within")
# print summary using robust standard errors
coeftest(fe_standard_difference, vcov. = vcovHC, type = "HC1")
# Nonrobust -> summary(fe_standard_difference)

library(stargazer)
stargazer(
  baseline_legend_of_use, 
  fe_legend_of_use, 
  standard_baseline_difference, 
  fe_standard_difference, 
  title="Regression Results", align=TRUE)



########################################
# Simply error: Variance testing
########################################

# For relative errors will center around 0
#  Variance testing (could use bootstrapping, but easier to use statistical test)

test_normality <- function(df, legend_type){
  if(legend_type=="combined"){
    perception_error_only_df = responses_an %>% select(percept_error)
  } else if(legend_type=="headline_removed"){
    perception_error_only_df = responses_an %>% filter(legend!="headline") %>% select(percept_error)
  } 
  else{
    perception_error_only_df = responses_an %>% filter(legend==legend_type) %>% select(percept_error)
  }
  normality = shapiro.test(perception_error_only_df$percept_error)
  normality_results = ifelse(normality$p.value > 0.05, paste(legend_type, "NORMALity not rejected"), paste(legend_type, "NON-NORMAL"))
  print(normality_results)
}

# Sensitive to normality
legend_types = c(
  "combined",
  "headline_removed",
  "headline", 
  "sampled", 
  "clustered", 
  "checkered", 
  "annotated"
)

for(legend in legend_types){
  test_normality(responses_an, legend)
}


# check which cateoy has the highest variance
no_legend_baseline %>% 
  group_by(legend) %>% 
  summarize(sd = sd(percept_error)) %>%
  arrange(desc(sd))


# F-test two categories at the time: instead:
# Multiple variances assuming normal -> Bartlett's http://www.sthda.com/english/wiki/compare-multiple-sample-variances-in-r
bartlett_model_all = bartlett.test(percept_error ~ legend, data = no_legend_baseline)
ifelse(
  bartlett_model_all$p.value < 0.5,
  "Variance SIGNIFICANT difference",
  "Variance NO significant difference"
)


bartlett_model_against_checkered = bartlett.test(percept_error ~ legend, data = checkered_baseline)
ifelse(
  bartlett_model_against_checkered$p.value < 0.5,
  "Variance SIGNIFICANT difference",
  "Variance NO significant difference"
)




########################################
# DECISION TYPES
# legend choices -> user selection behaviour?
########################################

# As shown earlier - a lot of variance, not a lot of signal
# Outliers likely affecting, simple OLS only

# Time until submit -> likely because of first interaction as legend
time_submit_all <- lm(submitTime / 1000 ~ legend, 
                             data = no_legend_baseline)
summary(time_submit_all)
# Between those with legend, no statistically significant difference difference compared to baseline
time_submit_w_legend <- lm(submitTime / 1000 ~ legend, 
                  data = checkered_baseline)
summary(time_submit_w_legend)

# inputChanges - only on first interaction, nothing significant vs. checkered
summary(lm(inputChanges ~ legend, 
           data = no_legend_baseline))
summary(lm(inputChanges ~ legend, 
           data = checkered_baseline))

# hoverEvents - no significant difference, high std errors, order of baseline category will not matter
summary(lm(hoverEvents ~ legend, 
           data = no_legend_baseline))
summary(lm(hoverEvents ~ legend, 
           data = checkered_baseline))


########################################
# ACCEPTANCE
# legend choices subjective -> how do users percieve these types? Useful/not useful
########################################

# NEED TO USE DATA WITHOUT DUPLICATES

acceptance_data_unique = responses_an %>% 
    select(uuid, acceptance, legend) %>% 
    distinct()

# Generally by group, which highest
acceptance_data_unique %>% 
  group_by(legend) %>% 
  summarize(mean = mean(acceptance, na.rm = T)) %>%
  arrange(desc(mean))
# 1 sampled    4.18
# 2 annotated  4.06
# 3 checkered  3.47
# 4 clustered  3.09
# 5 headline   2.09

# Checkered over clustered... let's keep still

# Earlier baselines still makes rough sense
acceptance_data_unique_legend_baseline = acceptance_data_unique
acceptance_data_unique_legend_baseline$legend = relevel(acceptance_data_unique_legend_baseline$legend, ref = "headline")
acceptance_data_unique_checkered_baseline = acceptance_data_unique
acceptance_data_unique_checkered_baseline = acceptance_data_unique_checkered_baseline %>% filter(legend != "headline")
acceptance_data_unique_checkered_baseline$legend = relevel(acceptance_data_unique_checkered_baseline$legend, ref = "checkered")


# Models- all significant against no-legend (= preferred over)
summary(lm(acceptance ~ legend, 
           data = acceptance_data_unique_legend_baseline))
# Annotated and sampled significantly preferred, clustered lower, but not significantly so
summary(lm(acceptance ~ legend, 
           data = acceptance_data_unique_checkered_baseline))



########################################
# SUBSET ANALYSIS - ROBUSTNESS
########################################


########
# Correlation error with progression 
# learning effects as progression or getting tired of task... (INDIVIDUAL+PROGNUM)
progression_effect_mod <- lm(percept_error_abs ~ prog, 
                             data = responses_an)
summary(progression_effect_mod)
# Nothing significant, not going to take this into account - or do analysis using e.g. first 5 images only

########
# Respondents with smaller average errors (outlier removal) - top 50th percentile

num_respondents_chosen = (responses_an$uuid %>% unique() %>% length())/2

arranged_respondents_by_error = responses_an %>% group_by(uuid) %>%
  summarize(mean_abs_error = mean(percept_error_abs)) %>%
  arrange(mean_abs_error) 

resp_low_errors = arranged_respondents_by_error[1:num_respondents_chosen,] %>% select(uuid)

resp_low_errors_df = responses_an %>% filter(uuid %in% resp_low_errors$uuid)

# Absolute
# Not really anything that sticks out
ggplot(resp_low_errors_df, aes(legend, percept_error_abs, color=legend)) + 
  geom_boxplot()  +
  stat_summary(fun="mean", geom="point", color="black")

# For completeness
no_legend_baseline_accurate = resp_low_errors_df
no_legend_baseline_accurate$legend = relevel(no_legend_baseline_accurate$legend, ref = "headline")
checkered_baseline_accurate = no_legend_baseline_accurate
checkered_baseline_accurate = checkered_baseline_accurate %>% filter(legend != "headline")
checkered_baseline_accurate$legend = relevel(checkered_baseline_accurate$legend, ref = "checkered")

# Absolute error - simple OLS
## 1. legend useful at all
### Baseline
baseline_legend_of_use_accurate <- lm(percept_error_abs ~ legend, 
                             data = no_legend_baseline_accurate)
summary(baseline_legend_of_use_accurate)
### FE = robustness
fe_legend_of_use_accurate <- plm(percept_error_abs ~ legend,
                        data = no_legend_baseline_accurate,
                        index = c("uuid"),
                        model = "within")
# print summary using robust standard errors
coeftest(fe_legend_of_use_accurate, vcov. = vcovHC, type = "HC1")
# Nonrobust -> summary(fe_legend_of_use)


## 2. Legend vs standard = checkered
## 3. annotated or contextualized also answered
### Baseline
standard_baseline_difference_accurate <- lm(percept_error_abs ~ legend, 
                                   data = checkered_baseline_accurate)
summary(standard_baseline_difference_accurate)
### FE = robustness
fe_standard_difference_accurate <- plm(percept_error_abs ~ legend,
                              data = checkered_baseline_accurate,
                              index = c("uuid"),
                              model = "within")
# print summary using robust standard errors
coeftest(fe_standard_difference_accurate, vcov. = vcovHC, type = "HC1")
# Nonrobust -> summary(fe_standard_difference)



########################################
# Additional
########################################

# Acceptance and performance correlation?
# Is subjective preference correlated with errors
summary(lm(percept_error_abs ~ acceptance, 
   data = responses_an))
# Low level of correlation and significant, likely pushed by low scores of no-legend
# When filtering out non-legend types, no significance
summary(lm(percept_error_abs ~ acceptance, 
           data = responses_an %>% filter(legend!="headline")))

# ###################
# For "later studies"

# Colour -> nothing significant against blue (highest average error)
summary(lm(percept_error_abs ~ colour, 
           data = responses_an ))


# Error distribution different parts of scale of correctVal?
# Can mention, but nothing of interest here...
plot(responses_an$correctVal, responses_an$percept_error)
abline(0, 0)


plot(responses_an$correctVal, responses_an$percept_error_abs)
error_over_ranges = lm(responses_an$correctVal ~ responses_an$percept_error_abs)
abline(error_over_ranges)
summary(error_over_ranges)


