library(mongolite)
library(stringr)
library(dplyr)
library(ggplot2)

########################################
# Data READ IN
########################################
respondents <- mongo("respondents", url = "mongodb://127.0.0.1:27017/thesis-dev")
responses <- mongo("responses", url = "mongodb://127.0.0.1:27017/thesis-dev")

correct = read.csv("~/Dev/Thesis/thesis-data-analysis/correct-vals.csv")
names(correct) <- c("MapVersion", "correctVal")


respondentdf = respondents$find()
responsesdf = responses$find()
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
# TODO: Prog-number of user
# TODO: acceptance scores
# TODO: learning effects as progression or getting tired of task...

responsesd_joined = dplyr::left_join(responsesdf, correct, by = c("maptype" ="MapVersion"))
responsesd_joined$percept_error = responsesd_joined$submitVal - responsesd_joined$correctVal
responsesd_joined$percept_error_abs = abs(responsesd_joined$percept_error)

names(responsesd_joined)
responsesd_joined$sliderChanges

responsesd_joined$uuid = as.factor(responsesd_joined$uuid)
responsesd_joined$mapVersion = as.factor(responsesd_joined$mapVersion)

########################################
# Summary statistics
########################################
responses_an = responsesd_joined %>% select(-c(mapVersion, sliderChanges, imageHoverEvents, TBR)) 
summary(responses_an)

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


# TODO: colourvalueerror, acceptance score, SelectionRagneDistFromCorrectAnswer

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


# TODO: colourvalueerror, acceptance score, SelectionRagneDistFromCorrectAnswer

########################################
# Fixed individual effects models
# https://www.econometrics-with-r.org/10-3-fixed-effects-regression.html
# https://cran.r-project.org/web/packages/fixest/vignettes/fixest_walkthrough.html
# TODO: assumptions on distributions
########################################
library(plm)
# estimate the fixed effects regression with plm()
fe_mod <- plm(percept_error ~ factor(legend), 
                    data = responses_an,
                    index = c("uuid"), 
                    model = "within")

# print summary using robust standard errors
coeftest(fe_mod, vcov. = vcovHC, type = "HC1")



# Event logging path per user... hovering and changes visualization...
# 1) Baseline without individual fixed effects as baseline model for 
# comparison ought to be included as well. Due to the use of convenience 
# sampling and large variability in the environments where the answers 
# to provided study are submitted, large individual effects are to be 
# expected.
# 2) Separate analysis of subgroups (e.g. desktop and smartphone using 
# respondents) ought to be included, or if those should be controlled 
# for in some of the of the models that does not use fixed individual 
# effects – but not possible using simple on-way ANOVA testing.
# 3) Learning-effects not included if no specific progression is 
# fixed for the subjects, this is assumed to elimit any such effects. 
# If clear learning effects are included – but no immediate feedback 
# to the subjects during the study ought to reduce those effects 
# slightly.
# Nice table layouts for reports + Rmarkdown setup
# Colour map of interactions
