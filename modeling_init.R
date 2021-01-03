library(mongolite)
library(stringr)
library(dplyr)
library(ggplot2)

########################################
# Data READ IN
########################################
respondents <- mongo("respondents", url = "mongodb://127.0.0.1:27017/thesis-dev")
responses <- mongo("responses", url = "mongodb://127.0.0.1:27017/thesis-dev")
acceptances <- mongo("acceptances", url = "mongodb://127.0.0.1:27017/thesis-dev")


correct = read.csv("~/Dev/Thesis/thesis-data-analysis/correct-vals.csv")
names(correct) <- c("MapVersion", "correctVal")


respondentdf = respondents$find()
responsesdf = responses$find()
acceptancessdf = acceptances$find()
acceptancessdf[,ncol(acceptancessdf)] <- NULL
acc_cols_to_num <- c(1:5)                                  
acceptancessdf[ , acc_cols_to_num] <- apply(acceptancessdf[ , acc_cols_to_num], 2,            # Specify own function within apply
                    function(x) as.numeric(x))

acceptancessdf_long = acceptancessdf %>% tidyr::gather("legend", "acceptance", -uuid)


names(responsesdf) <- c("uuid", "mapVersion", "sliderChanges", "imageHoverEvents", "submitTime", "TBR")


########################################
# Data Cleaning
########################################


########################################
# Variable generation
########################################

responsesdf$maptype = as.numeric(stringr::str_extract(responsesdf$mapVersion, "/[0-9]+") %>% str_remove("/") )
responsesdf$colour = stringr::str_extract(responsesdf$mapVersion, "green|blue|red")
responsesdf$legend = stringr::str_extract(responsesdf$mapVersion, "sampled|annotated|checkered|headline|clustered")

responsesdf$inputChanges = lapply(responsesdf$sliderChanges, function(x){ length(x$val) }) %>% unlist()
responsesdf$submitVal = lapply(responsesdf$sliderChanges, function(x){ tail(x$val, 1) }) %>% unlist()
responsesdf$rangeMin = lapply(responsesdf$sliderChanges, function(x){ min(x$val) }) %>% unlist()
responsesdf$rangeMax = lapply(responsesdf$sliderChanges, function(x){ max(x$val) }) %>% unlist()

# TODO: imagehover events


# Prog-number of user
prog_df_list = respondentdf %>% 
  apply(MARGIN = 1,function(x){ 
    data.frame(
      "uuid" = x$uuid,
      "imageProg" = x$imageProg,
      "prog" = 1:length(x$imageProg)
    )
  })
progressiondf <- do.call("rbind", prog_df_list)
progressiondf %>% glimpse()





responsesd_joined = left_join(responsesdf, correct, by = c("maptype" ="MapVersion"))
responsesd_joined$percept_error = responsesd_joined$submitVal - responsesd_joined$correctVal
responsesd_joined$percept_error_abs = abs(responsesd_joined$percept_error)

responsesd_joined = left_join(
  responsesd_joined, acceptancessdf_long, 
  c("uuid", "legend"), 
  keep=F
)

responsesd_joined = left_join(
  responsesd_joined, progressiondf, 
  c("uuid", "mapVersion" = "imageProg"), 
  keep=F
)


responsesd_joined$uuid = as.factor(responsesd_joined$uuid)
responsesd_joined$mapVersion = as.factor(responsesd_joined$mapVersion)

########################################
# Summary statistics/Exploratory analysis
########################################
responses_an = responsesd_joined %>% select(-c(mapVersion, sliderChanges, imageHoverEvents, TBR)) 
summary(responses_an)

# TODO: Increase models (all FE-models)
# TODO: statistical assumptions section (export as functions...)
# TODO: When color perception -> plot against error - should be correlated if not random...
# TODO: Look at response time as % of first image time... learning/remember/tired effects?
# TODO: learning effects as progression or getting tired of task... (INDIVIDUAL+PROGNUM)
# TODO: Progression fixed effects or as linear effect?
# TODO: Coefficient plots
# TODO: More plots
# TODO: colourvalueerror - once there is alpha-picker data
# TODO: acceptance scores analysis
# TODO: SelectionRagneDistFromCorrectAnswer
# TODO: Subset = first 4-5 images? if signs of learning/remember/tired effects
# TODO-OPTIONAL: Colour map of interactions

########################################
# Visual inspection and outliers by variables
# TODO: if needed remove outliers
# 1-way ANOVA + plots
# TODO: Check statistical assumptions BEFORE running models
# https://stat-methods.com/home/one-way-anova-r/#:~:text=%20One-way%20ANOVA%20Annotated%20R%20Output%20%201,the%20theoretical%20normal%20reference%20line%20and...%20More%20
# http://www.sthda.com/english/wiki/one-way-anova-test-in-r
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



# 3) Learning-effects not included if no specific progression is 
# fixed for the subjects, this is assumed to eliminate any such effects. 
# If clear learning effects are included – but no immediate feedback 
# to the subjects during the study ought to reduce those effects 
# slightly.


library(stargazer)
stargazer(lm_mod, fe_mod, title="Regression Results", align=TRUE)

