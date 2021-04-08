# thesis-data-analysis

## Reproducable results
- Opening up into Rstudio
- Opening up into R interactive session with source(data) only
- Running to get re-produced PDF LateX output

Want reproducable, but something of a tradeoff between cleaning up local setup and having some things not being super clean in the Docker setup... Reproducing the complex Mac setup working for Linux has a lot of versioning dependencies and similar. Want to save those to work FOREVER. Reproducibility over size of Docker-image. Rather get too much in and have it work, than too little and have to fiddle around even more...

## DOCKER DIARY

_Background Reading_
- Docker interactive tutorial
- http://ropenscilabs.github.io/r-docker-tutorial/
- https://www.r-bloggers.com/2019/02/running-your-r-script-in-docker/
- https://www.cascadia-analytics.com/2018/07/21/docker-r-p1.html
- https://jlintusaari.net/how-to-compile-r-markdown-documents-using-docker/

_Use Cases_
- Setting up base image
- Want to make useful for interactive investigations
+ Simple command that can generate PDF-output on local machine


_Selecting base image for "own base image gen"_
Minimal Latex needed, but going to https://hub.docker.com/r/rocker/verse/tags?page=1&ordering=last_updated can see 
Fixing version to know what is used, not latest...
Want to hide base image setup in subfolder:
`$ docker build -t test-rmarkdown -f docker-baseimage/Dockerfile .`

When debugging directory and similar
`docker run -it --rm test-rmarkdown bash`

Commenting out last line of Dockerfile 
<!-- RUN Rscript -e "rmarkdown::render('thesis-writeup.Rmd')"  -->
Then can open in interactive mode (installing images)
`docker run -e PASSWORD=test -p 8787:8787 test-rmarkdown`
`docker run --rm -p 8787:8787 test-rmarkdown`

**SIGN IN = rstudio PASSW=test**



#10 5.128 output file: thesis-writeup.knit.md
#10 5.128
#10 5.134 /usr/local/bin/pandoc +RTS -K512m -RTS thesis-writeup.utf8.md --to latex --from markdown+autolink_bare_uris+tex_math_single_backslash --output thesis-writeup.tex --self-contained --number-sections --highlight-style tango --pdf-engine xelatex --variable graphics --lua-filter /usr/local/lib/R/site-library/rmarkdown/rmd/lua/pagebreak.lua --lua-filter /usr/local/lib/R/site-library/rmarkdown/rmd/lua/latex-div.lua --wrap preserve --include-in-header /tmp/RtmpZGFOZT/rmarkdown-str926bc49a.html --variable 'geometry:margin=1in' --variable tables=yes --standalone -Mhas-frontmatter=false --filter pandoc-citeproc
#10 5.509 [WARNING] Deprecated: pandoc-citeproc filter. Use --citeproc instead.
#10 6.143 Error running filter pandoc-citeproc:
#10 6.143 Could not find executable pandoc-citeproc
#10 6.153 Error: pandoc document conversion failed with error 83
#10 6.154 Execution halted
--------------------





_Cleanup needed_
Some libraries not used...


Show how to run part by part in Rstudio

Needing to update Rmarkdown....

Picking smaller base image, typical "working on my machine"-issues...

Then needing PDF to be using Times... not available... adding another download...

SUCCESS

When trying to use in dockerfile.. gets stuck.. in 
Do you accept the EULA license terms? [yes/no]

Ugh... Google...

- FINALLY...
- NOW NEED TO GENERATE AUTOMATIC OUTPUT WITH VOLUME

- Getting into container... to install Times New Roman Ugh...

Then committing whatever we have from new window...

WHERE WE ARE...

$ docker run -it --rm test-rmarkdown bash
FROM CONTAINER
$ apt-get install ttf-mscorefonts-installer


- TEST IF IT WORKS INTERACTIVELY TO GENERATE CORRECT PDF
(After installing fonts through container)

- Then commit working container
CHECK WHICH ID CONTAINER HAS OR NAME
$ docker commit [id|name] newimagename
$ docker commit compassionate_antonelli tillman-thesis


docker run -it --rm -v $PWD/test:/test tillman-thesis ls


- THEN should be able to mount and run to show up at local location...
$ docker run -it --rm -v $PWD/pdf-output:/home/rstudio/working/pdf-output tillman-thesis Rscript -e "rmarkdown::render('thesis-writeup.Rmd', output_file = 'tillman_thesis.pdf', output_dir = './pdf-output')"

WORKS!!!
**Next steps:**
- Make sure cachable order... And if loading package script doesn't cache... then bring into Dockerfile
- File ADD to docker not default behavior for end-build - instead in dockerfile...
- Default start of image... should be?

NOW ALL PROVEN:
- Push new committed tested image
- New docker file
- Document



DOCUMENTATION:

Default in dockerfile = To run command to generate output, can also be done manually

`$ docker run -it --rm -v $PWD/pdf-output:/home/rstudio/working/pdf-output tillman-thesis Rscript -e "rmarkdown::render('thesis-writeup.Rmd', output_file = 'tillman_thesis.pdf', output_dir = './pdf-output')"`

If you want to open up and run through code block-by-block:

`$ docker run -e PASSWORD=test -p 8787:8787 tillman-thesis`

Open http://localhost:8787/ in browser

Seeing window, open file= click to the file, can run through all, or bit by bit

To interactively work with the data:

Can either execute script to read in data and end up in R session

Or open in Rstudio by clicking to file... load_data_for_interactive.R

Run file, then you have a list of data frames with raw and processed data:
"acceptancessdf"      "acceptancessdf_long" "clean_df"            "hover_df"            "progressiondf"      "respondentdf"        "responsesdf"         "slider_df"          