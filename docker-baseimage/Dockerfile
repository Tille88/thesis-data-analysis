# FROM rocker/verse:4.0.4
FROM rocker/tidyverse:4.0.4
ARG RSTUDIO_PATH=/home/rstudio
ARG WORKDIR_PATH=/home/rstudio/working

## install debian packages
RUN apt-get update -qq && apt-get -y install \
texlive-xetex 
# NEED TO DO MANUALLY BEFORE PUSHING... But whatevs... 
#apt-get install ttf-mscorefonts-installer

WORKDIR ${WORKDIR_PATH}
COPY thesis-writeup/ ${WORKDIR_PATH}
COPY docker-baseimage/init.R ${WORKDIR_PATH}/
COPY data_read_in.R /${RSTUDIO_PATH}/
COPY data/2021-02-06-11-45-27.RData /${RSTUDIO_PATH}/data/
# For mounting
COPY pdf-output/  ${WORKDIR_PATH}/pdf-output/
RUN Rscript ./init.R
# Not writable, but lets force it to be easier for interactive work from default folder of wher Rstudio opens...
RUN chmod a+rwx -R ${WORKDIR_PATH}
# RUN Rscript -e "rmarkdown::render('thesis-writeup.Rmd')"



# COMMIT AND PUSH TO DOCKERHUB