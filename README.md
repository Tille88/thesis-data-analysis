# thesis-data-analysis

## Build docker image

From root of repository run

```bash
docker build -t thesis-local .
```

## Example usages (after image built):

### Open interactive Rstudio setting

```bash
docker run -it --rm -e DISABLE_AUTH=true -p 8787:8787 thesis-local
```

Then open `http://localhost:8787/` in your browser.

You can open the file `./thesis-writeup/thesis-writeup.Rmd` and press the "knit" button, and it should generate a PDF.

Alternatively, you can open `./thesis-writeup/load_data_for_interactive.R`, and work with the data

### Generate PDF-output to local folder

Run the command below from root of repository. The file should end up in `./pdf-output`

```bash
docker run -it --rm -v $PWD/pdf-output:/home/rstudio/pdf-output thesis-local Rscript -e "rmarkdown::render('./thesis-writeup/thesis-writeup.Rmd', output_file = 'tillman_thesis.pdf', output_dir = './pdf-output')"
```

### Work in R from command line

```r
$ docker run -it --rm  thesis-local R
R version 4.0.4 (2021-02-15) -- "Lost Library Book"
Copyright (C) 2021 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)
R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.
R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.
Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.
> source("./thesis-writeup/load_data_for_interactive.R")
> ls()
[1] "acceptancessdf"      "acceptancessdf_long" "clean_df"
[4] "hover_df"            "progressiondf"       "respondentdf"
[7] "responsesdf"         "slider_df"
```

## Raw and semi-processed data

Raw data exists in the data frames

- acceptancessdf / acceptancessdf_long (long format)    
- progressiondf  
- respondentdf 
- responsesdf

Specific event data in the data frames
- hover_df
- slider_df

And clean data for start of thesis analysis in
- clean_df

