# Read In Secrets
# path <- "./secrets.json"
# if (!file.exists(path)) {
#     stop("Can't find secret file: '", path, "'")
# }
# secrets = jsonlite::read_json(path)


df_from_db = function(){
  # TODO: SANITY CHECK ALL DATA READ INS AND JOINS
  ##############
  # Respondents
  respondentdf <- mongo("respondents", url = "mongodb://127.0.0.1:27017/thesis-dev")$find()
  respondentdf[,ncol(respondentdf)] <- NULL
  
  
  ##############
  # Responses
  responsesdf <- mongo("responses", url = "mongodb://127.0.0.1:27017/thesis-dev")$find()
  responsesdf[,ncol(responsesdf)] <- NULL
  
  # Variable generation
  responsesdf$maptype = as.numeric(stringr::str_extract(responsesdf$mapVersion, "/[0-9]+") %>% str_remove("/") )
  responsesdf$colour = stringr::str_extract(responsesdf$mapVersion, "green|blue|red")
  responsesdf$legend = stringr::str_extract(responsesdf$mapVersion, "sampled|annotated|checkered|headline|clustered")
  
  responsesdf$inputChanges = lapply(responsesdf$sliderChanges, function(x){ length(x$val) }) %>% unlist()
  responsesdf$submitVal = lapply(responsesdf$sliderChanges, function(x){ tail(x$val, 1) }) %>% unlist()
  responsesdf$rangeMin = lapply(responsesdf$sliderChanges, function(x){ min(x$val) }) %>% unlist()
  responsesdf$rangeMax = lapply(responsesdf$sliderChanges, function(x){ max(x$val) }) %>% unlist()

  responsesdf$hoverEvents = lapply(responsesdf$imageHoverEvents, function(x){ nrow(x) }) %>% unlist()
  # INCLUDE WHICH MAP
  # imagehover events
  hoverev_list = responsesdf %>% 
    apply(MARGIN = 1,function(x){ 
      if(ncol(x$imageHoverEvents)){
        data.frame(
          "uuid" = x$uuid,
          "mapVersion" = x$mapVersion,
          "timestamp" = x$imageHoverEvents$timestamp,
          "x" = x$imageHoverEvents$x,
          "y" = x$imageHoverEvents$y
        )
      }
    })
  hover_df = do.call("rbind", hoverev_list)
  
  # Slider events as separate DF
  sliderev_list = responsesdf %>% 
    apply(MARGIN = 1,function(x){ 
      if(ncol(x$sliderChanges)){
        data.frame(
          "uuid" = x$uuid,
          "mapVersion" = x$mapVersion,
          "timestamp" = x$sliderChanges$timestamp,
          "val" = x$sliderChanges$val
        )
      }
    })
  slider_df = do.call("rbind", sliderev_list)
  
  
  
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
  
  ##############
  # Acceptance
  acceptancessdf <- mongo("acceptances", url = "mongodb://127.0.0.1:27017/thesis-dev")$find()
  acceptancessdf[,ncol(acceptancessdf)] <- NULL
  acc_cols_to_num <- c(1:5)                                  
  acceptancessdf[ , acc_cols_to_num] <- apply(acceptancessdf[ , acc_cols_to_num], 2,            # Specify own function within apply
                                              function(x) as.numeric(x))
  acceptancessdf_long = acceptancessdf %>% tidyr::gather("legend", "acceptance", -uuid)
  
  ##############
  # Actual values
  correct = read.csv("../data/correct-vals.csv")
  
  
  # Joins
  responses_joined = left_join(responsesdf, correct, by = c("maptype" ="MapVersion"))
  responses_joined$percept_error = responses_joined$submitVal - responses_joined$correctVal
  responses_joined$percept_error_abs = abs(responses_joined$percept_error)
  
  responses_joined = left_join(
    responses_joined, acceptancessdf_long, 
    c("uuid", "legend"), 
    keep=F
  )
  
  responses_joined = left_join(
    responses_joined, progressiondf, 
    c("uuid", "mapVersion" = "imageProg"), 
    keep=F
  )
  
  clean_df = responses_joined %>% select(-c(mapVersion, sliderChanges, imageHoverEvents)) 
  
  save(
    respondentdf, 
    responsesdf, 
    acceptancessdf, 
    hover_df, 
    slider_df, 
    progressiondf, 
    acceptancessdf_long, 
    clean_df,
    file = paste0("../data/", Sys.time() %>% str_replace_all("[ :]", "-"), ".RData")
  )
  # load("data.RData") used to programmatically read in file
  
  
  return(clean_df)
}