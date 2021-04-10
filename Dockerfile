FROM jonastillman/tillman-thesis:0.1.0

ARG RSTUDIO_PATH=/home/rstudio

# WORKDIR ${RSTUDIO_PATH}}
COPY thesis-writeup/ ${RSTUDIO_PATH}/thesis-writeup
COPY data_read_in.R /${RSTUDIO_PATH}/
COPY data/2021-02-06-11-45-27.RData /${RSTUDIO_PATH}/data/
# For mounting
COPY pdf-output/  ${RSTUDIO_PATH}/pdf-output/
RUN chmod a+rwx -R ${RSTUDIO_PATH}
CMD ["/init"]



# docker run -it --rm -e DISABLE_AUTH=true -p 8787:8787 thesis-output-test
# docker run -it --rm -v $PWD/pdf-output:/home/rstudio/pdf-output thesis-output-test Rscript -e "rmarkdown::render('thesis-writeup.Rmd', output_file = 'tillman_thesis.pdf', output_dir = './pdf-output')"