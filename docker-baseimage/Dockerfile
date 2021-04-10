# FROM rocker/verse:4.0.4
FROM rocker/tidyverse:4.0.4
ARG RSTUDIO_PATH=/home/rstudio
# COPY docker-baseimage/init.R ${RSTUDIO_PATH}
# Moved to follow best practices from docker-project.org
RUN  echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN install2.r \ 
    stargazer gplots plm rmarkdown \
    xfun tinytex bookdown
WORKDIR ${RSTUDIO_PATH}
# Moved up to hopefully get some caching...
# RUN Rscript ./init.R
# RUN rm ./init.R

## install debian packages
RUN apt-get update -qq && apt-get -y install \
    texlive-xetex 
# NEED TO DO MANUALLY BEFORE PUSHING... But whatevs... 
#apt-get install ttf-mscorefonts-installer

RUN chmod a+rwx -R ${RSTUDIO_PATH}
